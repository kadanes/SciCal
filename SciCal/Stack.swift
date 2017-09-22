//
//  Stack.swift
//  SciCal
//
//  Created by Parth Tamane on 22/09/17.
//  Copyright © 2017 Parth Tamane. All rights reserved.
//

import Foundation

class Stack {
    var stackArray = [String]()
    
    func push(stringToPush: String){
        self.stackArray.append(stringToPush)
    }
    
    func pop() -> String {
        if self.stackArray.last != nil {
            let stringToReturn = self.stackArray.last
            self.stackArray.removeLast()
            return stringToReturn!
        } else {
            return "0"
        }
    }
    
    func peek() -> String {
        
        if self.stackArray.last != nil {
            let stringToReturn = self.stackArray.last
            return stringToReturn!
        } else {
            return "0"
        }
    }
    
    func empty() -> Bool {
     
        return self.stackArray.isEmpty
    }
}
