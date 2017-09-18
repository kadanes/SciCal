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
    
    let converter = BaseConverter()
    
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
    
    
    func hexToIntVal(digit: String) -> Int {
        if digit == "A" {
            return 10
        } else if digit == "B" {
            return 11
        } else if digit == "C" {
            return 12
        } else if digit == "D" {
            return 13
        } else if digit == "E" {
            return 14
        } else if digit == "F" {
            return 15
        } else {
            return Int(digit)!
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

