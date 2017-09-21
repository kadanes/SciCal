//
//  ViewController.swift
//  SciCal
//
//  Created by Parth Tamane on 13/09/17.
//  Copyright © 2017 Parth Tamane. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var modeSelector: UISegmentedControl!
    
    @IBOutlet weak var alphabetRow: UIStackView!
    
    @IBOutlet weak var permutationRow: UIStackView!
    
    @IBOutlet weak var cursorPositionSlider: UISlider!
    
    
    @IBAction func addToMemory(_ sender: UIButton) {
    }
    
    @IBOutlet weak var baseChoiceButtons: UIStackView!
    
    @IBOutlet weak var decimalModeBtn: UIButton!
    
    @IBOutlet weak var binaryModeBtn: UIButton!
    
    @IBOutlet weak var hexModeBtn: UIButton!
    
    
    var operationFlag: Bool = false
    var decimalFlag: Bool = false
    var openingBracketFlag: Bool = false
    var closingBracketFlag: Bool = false
    var baseValue = 10
    var calculationMode = 0
    var runs = 0
    
    let converter = BaseConverter()
    
    @IBAction func pressedA(_ sender: Any) {
        if calculationMode == 1 && baseValue == 16 {
            updateMainScreen(input: "A")
        }
    }
    
    @IBAction func pressedB(_ sender: Any) {
        if calculationMode == 1 && baseValue == 16 {
            updateMainScreen(input: "B")
        }
    }
   
    @IBAction func pressedC(_ sender: Any) {
        
        if calculationMode == 1 && baseValue == 16 {
          updateMainScreen(input: "C")
        }
        
    }
    @IBAction func pressedD(_ sender: Any) {
        if calculationMode == 1 && baseValue == 16 {
            updateMainScreen(input: "D")
        }
    }
    @IBAction func pressedE(_ sender: Any) {
        if calculationMode == 1 && baseValue == 16 {
            updateMainScreen(input: "E")
        }
    }
    @IBAction func pressedF(_ sender: Any) {
        if calculationMode == 1 && baseValue == 16 {
            updateMainScreen(input: "F")
        }
    }
    @IBAction func pressedMultiply(_ sender: UIButton) {
        if !operationFlag{
            updateMainScreen(input: " * ")
            operationFlag = true
            decimalFlag = false
            operationFlag = false
            openingBracketFlag = false
            closingBracketFlag = true
        }
        
    }
    @IBAction func pressedDivide(_ sender: UIButton) {
        if !operationFlag{
            updateMainScreen(input: " / ")
            operationFlag = true
            decimalFlag = false
            openingBracketFlag = false
            closingBracketFlag = true
        }
    }
    @IBAction func pressedPlus(_ sender: UIButton) {
        if !operationFlag{
            updateMainScreen(input: " + ")
            operationFlag = true
            decimalFlag = false
            openingBracketFlag = false
            closingBracketFlag = true
        }
    }
    @IBAction func pressedMinus(_ sender: UIButton) {
        if !operationFlag{
            updateMainScreen(input: " - ")
            operationFlag = true
            decimalFlag = false
            openingBracketFlag = false
            closingBracketFlag = true
        }
    }
    @IBAction func pressedOpeningBracket(_ sender: UIButton) {
        if !openingBracketFlag {
            updateMainScreen(input: " ( ")
        }
        
    }
    @IBAction func pressedOpeningClosing(_ sender: UIButton) {
        if !closingBracketFlag {
            updateMainScreen(input: " ) ")
        }
        
    }
    
    @IBAction func pressedDecimalPoint(_ sender: Any) {
        if !decimalFlag {
            updateMainScreen(input: ".")
            decimalFlag = true
            operationFlag = true
            closingBracketFlag = true
            openingBracketFlag = true
        }
    }
    
    @IBAction func pressedExponent(_ sender: UIButton) {
        if !operationFlag {
            updateMainScreen(input: " * 10^")
        }
    }
    
    @IBAction func pressedAC(_ sender: UIButton) {
        mainScreen.text = "0"
        resetFlags()
        updateCursor()
    }
    
    func resetFlags() {
        operationFlag = false
        openingBracketFlag = false
        closingBracketFlag = false
        decimalFlag = false
    }
    
    @IBOutlet weak var mainScreen: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        mainScreen.delegate = self
        mainScreen.inputView = UIView()
        mainScreen.becomeFirstResponder()
        
    }
    
    @IBAction func primaryButtonPressed(_ sender: UIButton){
        
        let btnValue = sender.tag
        
        if calculationMode == 0 {
            
            updateMainScreen(input: "\(btnValue)")
        } else if calculationMode == 1 {
            
            if baseValue == 2 {
                
                if btnValue == 0 || btnValue == 1 {
                    
                    updateMainScreen(input: "\(btnValue)")
                }
            } else {
                
                updateMainScreen(input: "\(btnValue)")
            }
        } else {
            
            updateMainScreen(input: "\(btnValue)")
        }
        
        operationFlag = false
        openingBracketFlag = true
        closingBracketFlag = false
    }
    
    @IBAction func didChangeMode(_ sender: UISegmentedControl) {
        
        calculationMode = sender.selectedSegmentIndex
        
        if sender.selectedSegmentIndex == 0 {
            
            permutationRow.isHidden = false
            alphabetRow.isHidden = true
            baseChoiceButtons.isHidden = true
            
            
            
            
        } else if sender.selectedSegmentIndex == 1 {
            
            permutationRow.isHidden = true
            alphabetRow.isHidden = false
            baseChoiceButtons.isHidden = false
            
            
        }
        
    }
    
    @IBAction func convertToDecimal(_ sender: UIButton) {
        
        switch baseValue {
        case 2:
            
            changeBaseBtnBg(base: 2, newBase: 10)
            mainScreen.text = converter.converBinaryToDecimal(input: mainScreen.text!)
           
        case 16:
    
            changeBaseBtnBg(base: 16, newBase: 10)
            mainScreen.text = converter.convertHexToDecimal(input: mainScreen.text!)
            
        default:
            print("Already decimal")
        }
 
        updateCursor()
        baseValue = 10
        
    }
    
    @IBAction func convertToBinary(_ sender: UIButton) {
        
        switch baseValue {
        case 10:
            changeBaseBtnBg(base: 10, newBase: 2)
            mainScreen.text = converter.convertDecimalToBinary(input: mainScreen.text!)
            
        case 16:
            changeBaseBtnBg(base: 16, newBase: 2)
            mainScreen.text = converter.convertHexToBinary(input: mainScreen.text!)
            
            
        default: print("Already binary")
        
        }
        updateCursor()
        baseValue = 2
    
    }
    
    @IBAction func convertToHex(_ sender: UIButton) {
        
        switch baseValue {
        case 2:
            
            changeBaseBtnBg(base: 2, newBase: 16)
            mainScreen.text = converter.convertBinaryToHex(input: mainScreen.text!)
        case 10:
            changeBaseBtnBg(base: 10, newBase: 16)
            mainScreen.text = converter.converDecimalToHex(input: mainScreen.text!)
            
        default: break
        }
        updateCursor()
        baseValue = 16
    }
    
    
    
    @IBAction func deleteText(_ sender: Any) {
        
        if let range = mainScreen.selectedTextRange {
            
            if range.start == range.end {
                if let newPosition = mainScreen.position(from: range.start, offset: -1) {
                    
                    // set the new position
                    mainScreen.selectedTextRange = mainScreen.textRange(from: newPosition, to: range.start)
                    let updatedRange = mainScreen.selectedTextRange!
                    
                    let selectedItems = mainScreen.text(in: updatedRange)
                    
                    if selectedItems == "." {
                        
                        decimalFlag = false
                        mainScreen.replace(updatedRange, withText: "")
                    } else if selectedItems == " " {
                        
                        let newPositionNext = mainScreen.position(from: newPosition, offset: -1)!
                        mainScreen.replace(updatedRange, withText: "")
                        
                        mainScreen.selectedTextRange = mainScreen.textRange(from: newPositionNext, to: newPosition)
                        let nextUpdatedRange = mainScreen.selectedTextRange!
                        
                        let newSelectedItem = mainScreen.text(in: nextUpdatedRange )!
                        
                        switch newSelectedItem {
                            
                        case ")":
                            
                            closingBracketFlag = false
                        
                        case "(":
                            
                            openingBracketFlag = false
                            
                        case "+" , "-" , "*" , "/" :
                            
                            operationFlag = false
                        
                        default: break
                            
                        }
                        
                        let finalPosition = mainScreen.position(from: newPositionNext, offset: -1)!
                        mainScreen.selectedTextRange = mainScreen.textRange(from: finalPosition, to: newPosition)
                        if let finalUpdatedRange = mainScreen.textRange(from: finalPosition, to: newPosition) {
                         
                             mainScreen.replace(finalUpdatedRange, withText: "")
                        }
                        
                    } else {
                        
                        mainScreen.replace(updatedRange, withText: "")
                    }
                    
                        
                        
                        //mainScreen.replace(updatedRange, withText: "")
                    
                    updateCursor()
                    
                }
            }
        }
    }
    
    @IBAction func changeCursorPosition(_ sender: Any) {
        
        let cursorPosition = Int(cursorPositionSlider.value)
        
        let position = mainScreen.position(from: mainScreen.beginningOfDocument, offset: cursorPosition)!
        mainScreen.selectedTextRange = mainScreen.textRange(from: position, to: position)
        
        
    }
    
    func updateMainScreen( input: String){
        
        if let range = mainScreen.selectedTextRange {
            mainScreen.replace(range, withText: input)

        }
        
        updateCursor()
        
        }
    
    func updateCursor(){
        
        if let range = mainScreen.selectedTextRange{
            var characterCount:Int {
                get{
                    return (mainScreen.text?.characters.count)!
                }
            }
            let cursorPosition = Float(mainScreen.offset(from: mainScreen.beginningOfDocument, to: range.start) + 1)
        
            cursorPositionSlider.maximumValue = Float(characterCount)
            cursorPositionSlider.setValue(cursorPosition, animated: true)
        }
        
    }
    
    
    @IBAction func didPanKeyboard(_ sender: UIPanGestureRecognizer) {
        
//        let translation = sender.translation(in: self.view)
//        let startPoint = CGPointZero
//        let distance = Double(translation.y - startPoint.y)
//        print("\(distance)")
        
        switch(sender.state){
            
        case .began:
            let touchStart = sender.location(in: self.view)
            
        case .changed:
            let distance = sender.translation(in: self.view)
//            print(distance.x)
            let xTranslation = round(Double(Int(distance.x)/30))
            
            
            
            
            
            if xTranslation < 0 {
                
                
                runs += 1
                
                print("X Translation: ",xTranslation, "Runs: ", runs)

                
                let leftCharacterRange = mainScreen.textRange(from: (mainScreen.selectedTextRange?.start)!, to: mainScreen.beginningOfDocument)
                let beginingOfCursor = mainScreen.position(from: (mainScreen.selectedTextRange?.start)!, offset: 0)
                
                mainScreen.selectedTextRange = leftCharacterRange
                
              let remainingCharacters = Double((mainScreen.text(in: leftCharacterRange!)?.characters.count)!)
                
                
                let resetCharacterRange = mainScreen.textRange(from: beginingOfCursor!, to: beginingOfCursor!)
                
                mainScreen.selectedTextRange = resetCharacterRange
                
                if remainingCharacters > 0 && xTranslation <= remainingCharacters && runs > 15 {
                    
                    let position = mainScreen.position(from: (mainScreen.selectedTextRange?.start)!, offset: Int(xTranslation))!
                    mainScreen.selectedTextRange = mainScreen.textRange(from: position, to: position)
                    runs = 0
                }
                
            } else {
                
                runs += 1
                
                print("X Translation: ",xTranslation, "Runs: ", runs)
                
                
                let rightCharacterRange = mainScreen.textRange(from: (mainScreen.selectedTextRange?.start)!, to: mainScreen.endOfDocument)
                let beginingOfCursor = mainScreen.position(from: (mainScreen.selectedTextRange?.start)!, offset: 0)
                
                mainScreen.selectedTextRange = rightCharacterRange
                
                let remainingCharacters = mainScreen.text(in: rightCharacterRange!)?.characters.count
                
                
                let resetCharacterRange = mainScreen.textRange(from: beginingOfCursor!, to: beginingOfCursor!)
                
                mainScreen.selectedTextRange = resetCharacterRange
                
                if remainingCharacters! > 0  && runs > 20 {
                    
                    let position = mainScreen.position(from: (mainScreen.selectedTextRange?.start)!, offset: 1 )!
                    mainScreen.selectedTextRange = mainScreen.textRange(from: position, to: position)
                    runs = 0
                }
            }
         
        default:
            print("default")
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
}

