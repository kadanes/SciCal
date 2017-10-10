//
//  ViewController.swift
//  SciCal
//
//  Created by Parth Tamane on 13/09/17.
//  Copyright © 2017 Parth Tamane. All rights reserved.
//

import UIKit
import AudioToolbox
import iosMath

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var modeSelector: UISegmentedControl!
    
    @IBOutlet weak var alphabetRow: UIStackView!
    
    @IBOutlet weak var permutationRow: UIStackView!
    
 
    
    
    @IBAction func addToMemory(_ sender: UIButton) {
    }
    
    @IBOutlet weak var baseChoiceButtons: UIStackView!
    
    @IBOutlet weak var decimalModeBtn: UIButton!
    
    @IBOutlet weak var binaryModeBtn: UIButton!
    
    @IBOutlet weak var hexModeBtn: UIButton!
    
    @IBOutlet weak var arithmeticEqualTo: UIButton!
    
    @IBOutlet weak var baseNEqualTo: UIButton!
    
    @IBOutlet weak var expressionView: UIView!
    
    //@IBOutlet weak var mainScreenStackView: UIStackView!
    
    var operationFlag: Bool = false
    var decimalFlag: Bool = false
    var openingBracketFlag: Bool = false
    var closingBracketFlag: Bool = false
    var baseValue = 10
    var calculationMode = 0
    var runs = 0
    var latexString = ""
    
    var cursorIndex = 0
    var literalCount = 0
    var labelLatixSize: CGSize!
    var cursorLatixSize: CGSize!
    
    let converter = BaseConverter()
    
    let label =  MTMathUILabel()
    let labelCursor = MTMathUILabel()
    var expressionScrollView : UIScrollView!
    
    let inputLinkedList = LinkedList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
//        labelCursor.latex = "12\\wr34"
//        label.latex = "12\\;34"
//
//        labelLatixSize = label.intrinsicContentSize
//        cursorLatixSize = labelCursor.intrinsicContentSize
//
//        expressionScrollView = UIScrollView(frame: expressionView.bounds)
       
        
        //MTMathAtomFactory.addLatexSymbol("new", value: MTMathAtomFactory.operator(withName: "new", limits: false))
        
        MTMathAtomFactory.addLatexSymbol("fcursor", value: MTMathAtom.init(type: MTMathAtomType.accent, value: "𝖨"))  //𝖨∣
        MTMathAtomFactory.addLatexSymbol("bcursor", value: MTMathAtom.init(type: MTMathAtomType.accent, value: "˙"))//˙
        
        
        renderMathEquation()
        
        blinkCursor()
    }
    
    
    func renderMathEquation() {
        
        expressionView.isHidden = false
        
        label.fontSize = 40.0
        labelCursor.fontSize = 40.0
        label.textColor = UIColor.white
        labelCursor.textColor = UIColor(red:1.00, green:0.35, blue:0.33, alpha:1.0)
        
        labelCursor.latex = "0\\fcursor"
        label.latex = "0\\bcursor"
        labelLatixSize = label.intrinsicContentSize
        cursorLatixSize = labelCursor.intrinsicContentSize
        
        expressionScrollView = UIScrollView(frame: expressionView.bounds)
        
        expressionScrollView.addSubview(labelCursor)
        
        expressionScrollView.addSubview(label)
        
        updateExpressionFrame()
        
        expressionView.addSubview(expressionScrollView)
    }
    

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
     
        setScreenSize(mode: 0)
 
    }
    
    @IBAction func primaryButtonPressed(_ sender: UIButton){
        
        let btnValue = sender.tag
        
        insertInList(input: "\(btnValue)")
        refreshLatexString(calledFrom: 0)
        
        if calculationMode == 0 {
            
             AudioServicesPlaySystemSound(1520)
            
        } else if calculationMode == 1 {
            
            if baseValue == 2 {
                
                if btnValue == 0 || btnValue == 1 {
                    
                   
                     AudioServicesPlaySystemSound(1520)
                }
            } else {
                
                 AudioServicesPlaySystemSound(1520)
            }
        } else {
            
             AudioServicesPlaySystemSound(1520)
        }
    }
    
    @IBAction func didChangeMode(_ sender: UISegmentedControl) {
        
        calculationMode = sender.selectedSegmentIndex
        setScreenSize(mode: calculationMode)
        
        if sender.selectedSegmentIndex == 0 {
            
            permutationRow.isHidden = false
            alphabetRow.isHidden = true
            baseChoiceButtons.isHidden = true
            
            arithmeticEqualTo.isHidden = false
            baseNEqualTo.isHidden = true
            
            
        } else if sender.selectedSegmentIndex == 1 {
            
            permutationRow.isHidden = true
            alphabetRow.isHidden = false
            baseChoiceButtons.isHidden = false
           
            arithmeticEqualTo.isHidden = true
            baseNEqualTo.isHidden = false
            
        }
        
    }
    
    func setScreenSize(mode: Int) {
    
        switch mode {
            
        case 0,2,3,4,5 :
            
            expressionView.frame = CGRect( x: 10 , y: 8, width: expressionView.frame.width + 90 , height: expressionView.frame.height)
            expressionScrollView.frame = expressionView.bounds

        case 1:
            expressionView.frame = CGRect( x: 100 , y: 8, width: expressionView.frame.width - 90 , height: expressionView.frame.height)
            expressionScrollView.frame = expressionView.bounds
        default:
            break
        }
    }
    
    @IBAction func convertToDecimal(_ sender: UIButton) {
        
        var decimalNumber = ""
        let input = inputLinkedList.displayString(cursorPosition: 0).normal

        switch baseValue {
        case 2:
            
            changeBaseBtnBg(base: 2, newBase: 10)
            decimalNumber = converter.converBinaryToDecimal(input: input)
           
        case 16:
    
            changeBaseBtnBg(base: 16, newBase: 10)
            decimalNumber = converter.convertHexToDecimal(input: input)
            
        default: decimalNumber = input
        }
        baseValue = 10
        displayAnswer(result: decimalNumber)
    }
    
    @IBAction func convertToBinary(_ sender: UIButton) {
        
        var binaryNumber = ""
        let input = inputLinkedList.displayString(cursorPosition: 0).normal

        switch baseValue {
        case 10:
            changeBaseBtnBg(base: 10, newBase: 2)
            binaryNumber = converter.convertDecimalToBinary(input: input)
            
            
        case 16:
            changeBaseBtnBg(base: 16, newBase: 2)
            binaryNumber = converter.convertHexToBinary(input: input)
            
        default: binaryNumber = input
        
        }
        baseValue = 2
        displayAnswer(result: binaryNumber)
    }
    
    @IBAction func convertToHex(_ sender: UIButton) {
        
        var hexNumber = ""
        let input = inputLinkedList.displayString(cursorPosition: 0).normal

        switch baseValue {
        case 2:
            
            changeBaseBtnBg(base: 2, newBase: 16)
            hexNumber = converter.convertBinaryToHex(input: input)
        case 10:
            changeBaseBtnBg(base: 10, newBase: 16)
            hexNumber = converter.converDecimalToHex(input: input)
            
        default: hexNumber = input
        }
        displayAnswer(result: hexNumber)
        baseValue = 16
    }
    
    @IBAction func deleteText(_ sender: Any) {
        
        if cursorIndex != 0 {
            
            if inputLinkedList.delete(cursorPosition: cursorIndex) {
                literalCount -= 1
                cursorIndex -= 1
            }
            
            literalCount -= 1
            cursorIndex -= 1
            refreshLatexString(calledFrom: 1)
        }
    }
    
    
    @IBAction func arithmeticEqualPressed(_ sender: UIButton) {
        
        let answer = evaluateAnswer(mode: 0)
        displayAnswer(result: answer )
    }
    
    func evaluateAnswer(mode: Int) -> String{
        let expressionStrings = inputLinkedList.displayString(cursorPosition: 0)
        let solver = ExpressionEvaluator(infix: expressionStrings.normal, mode: mode)
        
        let result = solver.evaluateExpression()
        return result
    }
    
    func displayAnswer(result: String) {
        
        
        inputLinkedList.empty()
        
        cursorIndex = 0;
        literalCount = 0;
        
        for charecters in result {
            
            insertInList(input: "\(charecters)")
            refreshLatexString(calledFrom: 0)
        }
        
        
        
        print("Result is: ",result)
        
    }
    
 
    
   
    
   
    
    func refreshLatexString(calledFrom: Int) {
        
        if calledFrom == 0 {
            
            cursorIndex += 1
            literalCount += 1
            let result = inputLinkedList.displayString(cursorPosition: cursorIndex)
            label.latex = result.latex
            labelCursor.latex = result.cursor
            
            
        } else if calledFrom == 1 {
            
            let result = inputLinkedList.displayString(cursorPosition: cursorIndex)
            label.latex = result.latex
            labelCursor.latex = result.cursor
        }
        
        cursorLatixSize = labelCursor.intrinsicContentSize
        labelLatixSize = label.intrinsicContentSize
        
        updateExpressionFrame()
        
    }
    
    @IBAction func didPanKeyboard(_ sender: UIPanGestureRecognizer) {
        
        let maxRuns = 10
        
        switch(sender.state){
            
//        case .began:
//            let touchStart = sender.location(in: self.view)
            
        case .changed:
            
            let distance = sender.translation(in: self.view)
            let xTranslation = Double(distance.x)
            
            if xTranslation < 0 {
                
                runs += 1
                
                if cursorIndex > 0 && runs > maxRuns {
                    cursorIndex -= 1
                    
                    refreshLatexString(calledFrom: 1)
                    AudioServicesPlaySystemSound(1519)
                    runs = 0
                }
                
                } else {
                
                runs += 1
                
                if  runs > maxRuns && literalCount > 0 {
                    
                    AudioServicesPlaySystemSound(1519)
                    
                    if cursorIndex <  literalCount - 1 {
                        print("Called in C < L")
                        cursorIndex += 1
                        
                    } else {
                        print("Called in else of C < L")
                        cursorIndex = literalCount
                    }
                    
                    refreshLatexString(calledFrom: 1)
                    runs = 0
                    
                }
        }
            
        default:
            print("Default: ",cursorIndex)
        }
    }
    
    
    func changeBaseBtnBg( base: Int, newBase: Int) {
        
        switch base {
            
        case 10:
             decimalModeBtn.backgroundColor = .clear
             
            if newBase == 2 {
               
                binaryModeBtn.backgroundColor = UIColor.darkGray
            } else if newBase == 16 {
               
                hexModeBtn.backgroundColor = UIColor.darkGray
            }
    
        case 2:
            binaryModeBtn.backgroundColor = .clear

            if newBase == 10 {
                
                decimalModeBtn.backgroundColor = UIColor.darkGray
            } else if newBase == 16 {
               
                hexModeBtn.backgroundColor = UIColor.darkGray
            }
            
        case 16:
            hexModeBtn.backgroundColor = .clear
            
            if newBase == 10 {
                
                decimalModeBtn.backgroundColor = UIColor.darkGray
            } else if newBase == 2 {
                
                binaryModeBtn.backgroundColor = UIColor.darkGray
            }
        default: break
            
        }
    }
    

    func blinkCursor() {
        
        func blink(T: Timer) {
            let subviews = expressionScrollView.subviews
            
            if subviews[0].isHidden {
                //print("Showing")
                subviews[0].isHidden = false
            } else {
                
                subviews[0].isHidden = true
//                print("Hiding")
            }
        }
        
        _ = Timer.scheduledTimer(withTimeInterval: 0.40, repeats: true, block: blink(T:))
        
    }
    
    func updateExpressionFrame() {
        
        expressionScrollView.contentSize = CGSize(width: labelLatixSize.width + 5.0, height: labelLatixSize.height + 10.0 )
        
        labelCursor.frame = CGRect(x: 5.0 , y: 3.9, width: cursorLatixSize.width + 10, height: cursorLatixSize.height)
        
        label.frame = CGRect(x: 5.0, y: 5.0, width: labelLatixSize.width + 10, height: labelLatixSize.height)
        
        
    }
    
    func insertInList(input: String){
        
        switch input{
         
        case "\\times": inputLinkedList.insert(type: "operator", position: cursorIndex, isSubscript: false, superscriptPosition: 0, latexValue: "\\times", ignore: false)
        
        case "\\div": inputLinkedList.insert(type: "operator", position: cursorIndex, isSubscript: false, superscriptPosition: 0, latexValue: "\\div", ignore: false)
            
        case "^": inputLinkedList.insert(type: "operator", position: cursorIndex, isSubscript: false, superscriptPosition: 0, latexValue: "^{", ignore: false)
        
        literalCount += 1
        
        inputLinkedList.insert(type: "operator", position: cursorIndex + 1 , isSubscript: false, superscriptPosition: 0, latexValue: "}", ignore: false)
            
        default: inputLinkedList.insert(type: "operand", position: cursorIndex, isSubscript: false, superscriptPosition: 0, latexValue: input, ignore: false);
        }
    }
    
    @IBAction func pressedA(_ sender: Any) {
        if calculationMode == 1 && baseValue == 16 {
            
            AudioServicesPlaySystemSound(1520)
            
            insertInList(input: "A")
            refreshLatexString(calledFrom: 0)
        }
        
    }
    
    @IBAction func pressedB(_ sender: Any) {
        if calculationMode == 1 && baseValue == 16 {
          
            AudioServicesPlaySystemSound(1520)
            
            insertInList(input: "B")
            refreshLatexString(calledFrom: 0)
        }
    }
    
    @IBAction func pressedC(_ sender: Any) {
        
        if calculationMode == 1 && baseValue == 16 {
           
            
            AudioServicesPlaySystemSound(1520)
            
            insertInList(input: "C")
            refreshLatexString(calledFrom: 0)
        }
        
    }
    
    @IBAction func pressedD(_ sender: Any) {
        if calculationMode == 1 && baseValue == 16 {
            
            AudioServicesPlaySystemSound(1520)
            
            insertInList(input: "D")
            refreshLatexString(calledFrom: 0)
        }
    }
    
    @IBAction func pressedE(_ sender: Any) {
        if calculationMode == 1 && baseValue == 16 {
            
            AudioServicesPlaySystemSound(1520)
            
            insertInList(input: "E")
            refreshLatexString(calledFrom: 0)
        }
    }
    
    @IBAction func pressedF(_ sender: Any) {
        if calculationMode == 1 && baseValue == 16 {
        
            AudioServicesPlaySystemSound(1520)
            
            insertInList(input: "F")
            refreshLatexString(calledFrom: 0)
        }
    }
    
    @IBAction func pressedMultiply(_ sender: UIButton) {
     
        insertInList(input: "\\times")
        refreshLatexString(calledFrom: 0)
        AudioServicesPlaySystemSound(1520)
    }
    
    @IBAction func pressedDivide(_ sender: UIButton) {
        
        
        insertInList(input: "\\div")
        refreshLatexString(calledFrom: 0)
        AudioServicesPlaySystemSound(1520)

    }
    
    @IBAction func pressedPlus(_ sender: UIButton) {
        
        insertInList(input: "+")
        refreshLatexString(calledFrom: 0)
        AudioServicesPlaySystemSound(1520)
    }
    
    @IBAction func pressedMinus(_ sender: UIButton) {
      
        insertInList(input: "-")
        refreshLatexString(calledFrom: 0)
        AudioServicesPlaySystemSound(1520)
    }
    
    @IBAction func pressedOpeningBracket(_ sender: UIButton) {
        
        insertInList(input: "(")
        refreshLatexString(calledFrom: 0)
        AudioServicesPlaySystemSound(1520)
    }
    
    @IBAction func pressedOpeningClosing(_ sender: UIButton) {
       
        insertInList(input: ")")
        refreshLatexString(calledFrom: 0)
        AudioServicesPlaySystemSound(1520)
    }
    
    @IBAction func pressedDecimalPoint(_ sender: Any) {
       
        insertInList(input: ".")
        refreshLatexString(calledFrom: 0)
        AudioServicesPlaySystemSound(1520)
    }
    
    @IBAction func pressedFactorial(_ sender: UIButton) {
    
        insertInList(input: "!")
        refreshLatexString(calledFrom: 0)
        AudioServicesPlaySystemSound(1520)
    }
    
    
    @IBAction func pressedExponent(_ sender: UIButton) {
        
        insertInList(input: "^")
        refreshLatexString(calledFrom: 0)
        AudioServicesPlaySystemSound(1520)

    }
    
    @IBAction func pressedAC(_ sender: UIButton) {
        
        literalCount = 0
        cursorIndex = 0
        inputLinkedList.empty()
       
        //labelCursor.latex = "0\\check{\\ }"
        //label.latex = "0\\ "
        labelCursor.latex = "0\\fcursor"
        label.latex = "0\\bcursor"
        cursorLatixSize = labelCursor.intrinsicContentSize
        labelLatixSize = label.intrinsicContentSize

        updateExpressionFrame()
        
        AudioServicesPlaySystemSound(1520)
    }
    
}
