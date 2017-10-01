//
//  linkedList.swift
//  SciCal
//
//  Created by Parth Tamane on 30/09/17.
//  Copyright © 2017 Parth Tamane. All rights reserved.
//

import Foundation

class Node {
    
    var latexValue:String
    var normalValue:String
    var tokenType: String
    var position: Int
    var isSubscript: Bool
    var superscriptPosition: Int
    
    init(type: String, position: Int, isSubscript: Bool, superscriptPosition: Int, latexValue: String, normalValue: String) {
        
        self.tokenType = type;
        self.position = position;
        self.isSubscript = isSubscript
        self.superscriptPosition = superscriptPosition
        self.latexValue = latexValue
        self.normalValue = normalValue
    }
    
    var next: Node?
    weak var previous: Node?
}

class LinkedList {
   
    var head: Node?
    var tail: Node?
    
    var latex = ""
    var normal = ""
    var cursor = ""
    func insert(type: String, position: Int, isSubscript: Bool, superscriptPosition: Int,  latexValue: String) {
        
        var normalValue:String
        
        switch latexValue {
        case "\\times":
            print("Latix multiply")
            normalValue = "*"
        case "-":
            normalValue = "-"
        case "+":
            normalValue = "+"
        case "\\div":
            print("Latix divide")
            normalValue = "/"
        default:
            normalValue = latexValue
        }
        
        let newNode = Node(type: type, position: position, isSubscript: isSubscript, superscriptPosition: superscriptPosition, latexValue: latexValue, normalValue: normalValue)
        
        print("Trying to insert at position: ", position)
        print("New nodes position is: ",newNode.position)
        if head == nil {
            
            print("New node is head")
            head = newNode
            tail = newNode
            
        } else {
            
            var travelPointer = head
            
            while travelPointer?.next != nil && travelPointer?.next?.position != position {
                
                travelPointer = travelPointer?.next
            }
            
            if newNode.position == head?.position {
                
                print("Inserted at start.")

                newNode.next = head
                head?.previous = newNode
                head = newNode
                
                while travelPointer?.next != nil {
                    
                    travelPointer?.position += 1
                    travelPointer = travelPointer?.next
                }
                
            } else if newNode.position == (tail?.position)! + 1 {
                
                print("Inserting value at tail")
                
                travelPointer?.next = newNode
                newNode.previous = travelPointer
                tail = newNode
                newNode.next = nil
                
            } else {
                
                print("Inserting value here")
                
                var updatePosition = travelPointer?.next
                
                while updatePosition != nil {
                    
                    updatePosition?.position += 1
                    updatePosition = updatePosition?.next
                }
                //print(travelPointer?.position)
                //print(travelPointer?.latexValue,travelPointer?.next?.latexValue)
                travelPointer?.next?.previous = newNode
                newNode.next = travelPointer?.next
                newNode.previous = travelPointer
                travelPointer?.next = newNode
            }
            }
        
        let result = displayString(cursorPosition: position )
        latex = result.latex
        normal = result.normal
        cursor = result.cursor
    }
  
    
    func delete(position: Int){
        
        if var travelPointer = head {
            
            while travelPointer.position != position && travelPointer.next != nil {
                
                travelPointer = travelPointer.next!
            }
            
            if travelPointer.position == head?.position {
                
                head = travelPointer.next
                head?.previous = nil
                
                while travelPointer.next != nil {
                    
                    travelPointer.position -= 1
                    travelPointer = travelPointer.next!
                }
            } else if travelPointer.position == tail?.position {
                
                tail = travelPointer.previous
                tail?.next = nil
            } else {
                var updatePosition = travelPointer.next
                travelPointer.previous?.next = travelPointer.next
                travelPointer.next?.previous = travelPointer.previous
                
                travelPointer = travelPointer.previous!
                
                while updatePosition != nil {
                    
                    updatePosition?.position -= 1
                    updatePosition = updatePosition?.next
                }
            }
        }
        
        let result = displayString(cursorPosition: position)
        latex = result.latex
        normal = result.normal
        cursor = result.cursor
    }

    func displayString(cursorPosition: Int) -> (latex: String, normal: String, cursor: String){
        
        var latexString = ""
        var normalString = ""
        var cursorString = ""
        var cursorSet = false
        
        var moreTerms = false
        
        
        if var travelPointer = head {
            moreTerms = true
            while moreTerms {
                
                if (travelPointer.position)  == cursorPosition {
                    latexString += "\\ "
                    cursorString += "\\check{\\ }"
                    cursorSet = true
                }
                
                latexString += travelPointer.latexValue
                normalString += travelPointer.normalValue
                cursorString += travelPointer.latexValue
            
                if travelPointer.next != nil {
                   
                    travelPointer = travelPointer.next!
                } else {
                    moreTerms = false
            }
        }
            if !cursorSet {
                latexString += "\\ "
                cursorString += "\\check{\\ }"
                cursorSet = true
            }
            
            print("\nLatex: ",latexString,"\nNormal String: ",normalString,"\nCursor String:",cursorString)
        }
        
        return (latexString,normalString,cursorString)
    }
    
    func legth() -> Int {
    
        var length = 0
        
        if let travelPointer = tail {
            length = travelPointer.position
        }
        
        return length
    }
}
