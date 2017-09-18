//
//  BaseConverter.swift
//  SciCal
//
//  Created by Parth Tamane on 18/09/17.
//  Copyright © 2017 Parth Tamane. All rights reserved.
//

import Foundation

class BaseConverter {
    var outputInt = 0.0
    var outputFraction = 0.0
    var multiplier = 1.0
    var output  = 0.0
    var inputSplit = [String?]()
    var inputInt: String = "0"
    var inputFraction: String = "0"
    var noFractionalPart: Bool = false
    
    func splitInput( input : String ) {
        
        print("Received string is \(input)")
        
        self.inputSplit = input.components(separatedBy: ".")
    
        var isIndexValid = inputSplit.indices.contains(0)
        
        if isIndexValid{
            self.inputInt = inputSplit[0]!
            
        } else {
            inputInt = "0"
        }
        
        isIndexValid = inputSplit.indices.contains(1)
        
        if isIndexValid{

            self.inputFraction = inputSplit[1]!
            noFractionalPart = false
            
        } else {
            noFractionalPart = true
        }
    }
    
    func converBinaryToDecimal( input: String ) -> String {
        
        
        splitInput(input: input)
        
        if let outputInt = Int(inputInt, radix: 2) {
             self.outputInt = Double(outputInt)
            
        }
        
        
        
        multiplier = 1/2
        
        for inputFractionBit in inputFraction.characters {
        
            outputFraction += Double("\(inputFractionBit)")! * multiplier
            multiplier = multiplier/2
        }
        
        if noFractionalPart {
            
            print("No fractional part")
            return String(Int(outputInt))

        } else {
            
            print("Fractional part")
            output = outputInt + outputFraction
            return String(output)
        }
    }
    
    
    func convertHexToDecimal(input: String) -> String {
        
        
        splitInput(input: input)
        
        if let outputInt = Int(inputInt, radix: 16) {
            self.outputInt = Double(outputInt)
        }
        
        multiplier = 1/16
        
        for inputFractionBit in inputFraction.characters {
            
            outputFraction += Double(hexToDigit(digit: "\(inputFractionBit)")) * multiplier
            multiplier = multiplier/16
        }
        
        if noFractionalPart {
            
            return String(Int(outputInt))
            
        } else {
            
            output = outputInt + outputFraction
            return String(output)
        }

    }
    
    func convertDecimalToBinary(input: String) -> String {
        
        splitInput(input: input)
        let inputIntOfTypeInt = Int(inputInt)
        let outputIntofTypeString = String(inputIntOfTypeInt!, radix:2)
        outputInt = Double(outputIntofTypeString)!
        
        var outputFrac: Double = 0.0
        var inputFrac: String = ".\(Int(inputFraction)!)"
        for _ in stride(from: 1, to: 10, by: 1){
            
            var inputFracInDouble = Double(inputFrac)
            inputFracInDouble = inputFracInDouble! * 2.0
            
            let inputFractionToProcessSplit = String(inputFracInDouble!).components(separatedBy: "." )
            
            inputFrac = ".\(inputFractionToProcessSplit[1])"
            
            outputFrac += Double(Int(inputFractionToProcessSplit[0])!)
            outputFrac *= 10
            
        }
        
        outputFraction = Double(".\(Int(outputFrac))")!
        
        if noFractionalPart {
            
            return String(Int(outputInt))
            
        } else {
            
            output = outputInt + outputFraction
            return String(output)
        }
    }
    
    
    func convertHexToBinary(input: String ) -> String {
        
        let toDecimal = convertHexToDecimal(input: input)
        return convertDecimalToBinary(input: toDecimal)
    
    }
    
    
    func converDecimalToHex(input: String) -> String {
        
        splitInput(input: input)
        
        let inputIntOfTypeInt = Int(inputInt)
        let outputIntofTypeString = String(inputIntOfTypeInt!, radix: 16, uppercase: true)
       
        var outputFrac = ""
        var inputFrac: String = ".\(Int(inputFraction)!)"
        
        for _ in stride(from: 1, to: 5, by: 1){
            
            var inputFracInDouble = Double(inputFrac)
            
            if inputFracInDouble != 0.0 {
                
                inputFracInDouble = inputFracInDouble! * 16.0
            
                print(inputFracInDouble!)
                let inputFractionToProcessSplit = String(inputFracInDouble!).components(separatedBy: "." )
                
                inputFrac = ".\(inputFractionToProcessSplit[1])"
                
                let hexBitToAppend = digitToHex(hex: inputFractionToProcessSplit[0])
                outputFrac = "\(outputFrac)\(hexBitToAppend)"

            }
        }
        
        outputFrac = ".\(outputFrac)"
        
        
        if noFractionalPart {
            
            return outputIntofTypeString
            
        } else {
            
            
            return "\(outputIntofTypeString)\(outputFrac)"
        }
        
    }
    
    
    func convertBinaryToHex(input: String) -> String {
        
        let toDecimal = converBinaryToDecimal(input: input)
        return converDecimalToHex(input: toDecimal)
        
    }
    
    func digitToHex(hex: String) -> String {
        if hex == "15" {
            return "F"
        } else if hex == "14" {
            return "E"
        } else if hex == "13" {
            return "D"
        } else if hex == "12" {
            return "C"
        } else if hex == "11" {
            return "B"
        } else if hex == "10" {
            return "A"
        } else {
            return hex
        }
    }
    
    func hexToDigit(digit: String) -> Int {
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
}
