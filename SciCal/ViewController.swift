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
    
    @IBAction func pressedA(_ sender: Any) {
        updateMainScreen(input: "A")
    }
    
    @IBAction func pressedB(_ sender: Any) {
        updateMainScreen(input: "B")
    }
   
    @IBAction func pressedC(_ sender: Any) {
        updateMainScreen(input: "C")
    }
    @IBAction func pressedD(_ sender: Any) {
        updateMainScreen(input: "D")
    }
    @IBAction func pressedE(_ sender: Any) {
        updateMainScreen(input: "E")
    }
    @IBAction func pressedF(_ sender: Any) {
        updateMainScreen(input: "F")
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
        operationFlag = false
        openingBracketFlag = true
        closingBracketFlag = false
        updateMainScreen(input: "\(btnValue)")
       
    }
    
    @IBAction func didChangeMode(_ sender: UISegmentedControl) {
        
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
        
        
        let inputSplit = mainScreen.text?.components(separatedBy: ".")
    
        
        var fractionalInputString: String
        
        if ( inputSplit?.count == 2){
            
          fractionalInputString = (inputSplit?[1])!
            
        } else {
            
           fractionalInputString = "0"
            
        }
        
        var integerInputString: String

        if (inputSplit?.count)! > 0 {
            
            integerInputString = (inputSplit?[0])!
            
        } else {
            
            integerInputString = "0"
            
        }
        
        //var intInput = Double(integerInputString)
        
        var outputInt = 0.0
        var outputFraction = 0.0
        var multiplier = 1.0
        let output: Double
        
        switch baseValue {
        case 2:

            let countInt = integerInputString.characters.count
            
            var ctrInt = Int(countInt) - 1
            
            print("Count: \(ctrInt)")
            while ctrInt >= 0 {
                let index = integerInputString.characters.index((integerInputString.startIndex), offsetBy: ctrInt)
                let integerBit = Double(String(integerInputString[index]))
                
                outputInt += integerBit! * multiplier
                multiplier *= 2
                ctrInt -= 1
            }
            
//            while intInput != 0 {
//                
//                
//                let temp = intInput!.truncatingRemainder(dividingBy: 10.0)
//                outputInt += temp * multiplier
//                multiplier *= 2
//                intInput! = Double(Int(intInput! / 10))
//                print("\(intInput!)")
//            }
            
            multiplier = 1/2
            
            let countFraction = fractionalInputString.characters.count
            var ctrFraction = 0
            while ctrFraction != countFraction {
                let index = fractionalInputString.characters.index((fractionalInputString.startIndex), offsetBy: ctrFraction)
                
                let fractionBit = Double(String(fractionalInputString[index]))
                print(fractionBit!)
                outputFraction += fractionBit! * multiplier
                multiplier = multiplier/2
                
                ctrFraction += 1
            }
            
            output = outputInt + outputFraction
            mainScreen.text = "\(output)"
            updateCursor()
            
        case 16:
            print("Convert from hex")
        default:
            print("Already decimal")
        }
        
        baseValue = 10
        
    }
    
    @IBAction func convertToBinary(_ sender: UIButton) {
        
        baseValue = 2
    }
    
    @IBAction func convertToHex(_ sender: UIButton) {
        
        baseValue = 16
    }
    
    
    
    @IBAction func deleteText(_ sender: Any) {
        
        if let range = mainScreen.selectedTextRange {
            
            if range.start == range.end {
                if let newPosition = mainScreen.position(from: range.start, offset: -1) {
                    
                    // set the new position
                    mainScreen.selectedTextRange = mainScreen.textRange(from: newPosition, to: range.start)
                    if let updatedRange = mainScreen.selectedTextRange {
                        mainScreen.replace(updatedRange, withText: "")
                    }
                    
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
    
    
    

}

