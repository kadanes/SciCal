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
    
    var precission = 100000.0
    
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
        
        outputFraction = 0.0
        
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
            
            output = round(output * precission ) / precission
            return String(output)
        }
    }
    
    
    func convertHexToDecimal(input: String) -> String {
        
        outputFraction = 0.0
        outputInt = 0.0
        
        splitInput(input: input)
        
        if let outputInt = Int(inputInt, radix: 16) {
            self.outputInt = Double(outputInt)
        }
        
        multiplier = 1/16
        
        for inputFractionBit in inputFraction.characters {
            
            var nextOutputFractionBit = Double(hexToDigit(digit: "\(inputFractionBit)")) * multiplier
            nextOutputFractionBit = round(nextOutputFractionBit * precission)/precission
            outputFraction += nextOutputFractionBit
            
            //print("The output fraction bit is: ", nextOutputFractionBit, inputFractionBit, multiplier )
            multiplier = round(multiplier/16 * precission)/precission
        }
        
        if noFractionalPart {
            
            return String(Int(outputInt))
            
        } else {
            
            print("Output fraction in H -> D",outputFraction)
            print("Output integer in H -> D",outputInt)
            
            outputFraction = round(outputFraction * precission)/precission
            output = outputInt + outputFraction
            print("Output in H -> D",output)
            return String(output)
        }

    }
    
    func convertDecimalToBinary(input: String) -> String {
        
        splitInput(input: input)
        let inputIntOfTypeInt = Int(inputInt)
        let outputIntofTypeString = String(inputIntOfTypeInt!, radix:2)
        outputInt = Double(outputIntofTypeString)!
        
        var outputFrac = ""
        var inputFrac: String = ".\(Int(inputFraction)!)"
        var repeatFractionData = checkRecurringFractionalPart(obtainedFraction: outputFrac)
        while !repeatFractionData.isRepeating && inputFrac != ".0" {
            
            var inputFracInDouble = Double(inputFrac)
            inputFracInDouble = inputFracInDouble! * 2.0
            
            let inputFractionToProcessSplit = String(inputFracInDouble!).components(separatedBy: "." )
            
            
            if inputFractionToProcessSplit.indices.contains(1){
                inputFrac = ".\(inputFractionToProcessSplit[1])"
            }
            else{
                inputFrac = ".0"
            }
            
            outputFrac = "\(outputFrac)\(inputFractionToProcessSplit[0])"
            
            repeatFractionData = checkRecurringFractionalPart(obtainedFraction: outputFrac)
        }
        print("Removing repeating fraction")
        
        outputFrac.removeSubrange(repeatFractionData.repeateIndex..<outputFrac.endIndex)
        outputFrac = ".\(outputFrac)"
        print("Output frac is: ",outputFrac)
        
        
        if noFractionalPart {
            
            return String(Int(outputInt))
            
        } else {
            
            if outputFrac.characters.count > 15{
                let removeRange = outputFrac.index(outputFrac.startIndex, offsetBy: 16 )..<outputFrac.endIndex
                outputFrac.removeSubrange(removeRange)
            }
            return String("\(Int(outputInt))\(outputFrac)")
        }
    }
    
    
    func convertHexToBinary(input: String ) -> String {
        
        let toDecimal = convertHexToDecimal(input: input)
        print(toDecimal)
        return convertDecimalToBinary(input: toDecimal)
    
    }
    
    
    func converDecimalToHex(input: String) -> String {
        
        splitInput(input: input)
        
        let inputIntOfTypeInt = Int(inputInt)
        let outputIntofTypeString = String(inputIntOfTypeInt!, radix: 16, uppercase: true)
       
        var outputFrac = ""
        var inputFrac: String = ".\(Int(inputFraction)!)"
        var repeatFractionData = checkRecurringFractionalPart(obtainedFraction: outputFrac)
        
        var infiniteWait = 50
        while !repeatFractionData.isRepeating && inputFrac != ".0" && infiniteWait != 0  {
            
            var inputFracInDouble = Double(inputFrac)
            
            if inputFracInDouble != 0.0 {
                
                inputFracInDouble = inputFracInDouble! * 16.0
            
                print(inputFracInDouble!)
                let inputFractionToProcessSplit = String(inputFracInDouble!).components(separatedBy: "." )
                
                if inputFractionToProcessSplit.indices.contains(1){
                    inputFrac = ".\(inputFractionToProcessSplit[1])"
                } else{
                    inputFrac = ".0"
                }
                
                
                let hexBitToAppend = digitToHex(hex: inputFractionToProcessSplit[0])
                outputFrac = "\(outputFrac)\(hexBitToAppend)"
                
                repeatFractionData = checkRecurringFractionalPart(obtainedFraction: outputFrac)
            }
            
            infiniteWait -= 1
        }
        print("Removing repeating fraction")
        
        outputFrac.removeSubrange(repeatFractionData.repeateIndex..<outputFrac.endIndex)
        outputFrac = ".\(outputFrac)"
        
        
        if noFractionalPart {
            
            return outputIntofTypeString
            
        } else {
            print("Outputfrac is (D->H): ",outputFrac)
            if outputFrac.characters.count > 15{
                let removeRange = outputFrac.index(outputFrac.startIndex, offsetBy: 16)..<outputFrac.endIndex
                outputFrac.removeSubrange(removeRange)
            }

            
            return "\(outputIntofTypeString)\(outputFrac)"
        }
        
    }
    
    
    func convertBinaryToHex(input: String) -> String {
        
        let toDecimal = converBinaryToDecimal(input: input)
        print("Converted value is: ",toDecimal)
        return converDecimalToHex(input: toDecimal)
        
    }
    
    func checkRecurringFractionalPart(obtainedFraction: String) -> (isRepeating: Bool ,repeateIndex: String.Index ){
        
        
        var fraction = obtainedFraction
        
        if fraction.characters.count >= 15 {
            for size in (4...fraction.characters.count/2).reversed(){
                
                let rangeOfSubString1 = fraction.index(fraction.endIndex, offsetBy: -size)..<fraction.endIndex
                
                let rangeOfSubString2 = fraction.index(fraction.endIndex, offsetBy: -2 * size)..<fraction.index(fraction.endIndex, offsetBy: -size)
                
                print(fraction[rangeOfSubString1],fraction[rangeOfSubString2])
                
                if fraction[rangeOfSubString1] == fraction[rangeOfSubString2] {
                    print("Found repeating pattern")
                    return (true, fraction.index(fraction.endIndex, offsetBy: -size))
                }
            }
            
        }
        return (false, fraction.endIndex)
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
