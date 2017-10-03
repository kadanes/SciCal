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
    var ignore: Bool
    init(type: String, position: Int, isSubscript: Bool, superscriptPosition: Int, latexValue: String, normalValue: String, ignore: Bool) {
        
        self.tokenType = type;
        self.position = position;
        self.isSubscript = isSubscript
        self.superscriptPosition = superscriptPosition
        self.latexValue = latexValue
        self.normalValue = normalValue
        self.ignore = ignore
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
    
    func insert(type: String, position: Int, isSubscript: Bool, superscriptPosition: Int,  latexValue: String, ignore: Bool) {
        
        print("Attempting to insert \(latexValue) at position \(position)")
        
        var normalValue:String
        
        switch latexValue {
        case "\\times":
            print("Latix multiply")
            normalValue = " * "
        case "-":
            normalValue = " - "
        case "+":
            normalValue = " + "
        case "\\div":
            print("Latix divide")
            normalValue = " / "
        case "{":
            normalValue = " ( "
        case "}":
            normalValue = " ) "
        case "^{":
            normalValue = " ^ ( "
        default:
            normalValue = latexValue
        }
        
        let newNode = Node(type: type, position: position, isSubscript: isSubscript, superscriptPosition: superscriptPosition, latexValue: latexValue, normalValue: normalValue, ignore: ignore)
//
//        print("Trying to insert at position: ", position)
//        print("New nodes position is: ",newNode.position)
        
        if head == nil {
            
            print("New node is head")
            head = newNode
            tail = newNode
            
            
        } else {
            
            var travelPointer = head
            
            while travelPointer?.next != nil && travelPointer?.position != position {
               
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
                tail?.position += 1
                
            } else if newNode.position == (tail?.position)! + 1 {
                
                print("Inserting value at tail")
                
                travelPointer?.next = newNode
                newNode.previous = travelPointer
                tail = newNode
                newNode.next = nil
                
            } else {
                
                print("Inserting value somewhere inbetween head and tail")
                
                if (travelPointer?.ignore)! {
                    //travelPointer = travelPointer?.next
                    //print(travelPointer?.latexValue)
                    if travelPointer === tail! {
                        travelPointer?.next = newNode
                        newNode.previous = travelPointer
                        print("Travel pointer is tail")
                        tail = newNode
                        
                    } else {
                        
                        travelPointer?.next?.previous = newNode
                        newNode.previous = travelPointer
                        newNode.next = travelPointer?.next
                        travelPointer?.next = newNode
                    }
                    
                    
                } else {
                    
                    travelPointer?.previous?.next = newNode
                    newNode.previous = travelPointer?.previous
                    
                    newNode.next = travelPointer
                    travelPointer?.previous = newNode
                }
                
                //var updatePosition = travelPointer?.next
//                travelPointer?.next?.previous = newNode
//                newNode.next = travelPointer?.next
//                newNode.previous = travelPointer
//                travelPointer?.next = newNode
                
                while travelPointer != nil {
                    
//                     if travelPointer?.latexValue == "{" {
//
//                        travelPointer?.position = (travelPointer?.previous?.position)! + 1
//                    } else if travelPointer?.latexValue == "}" {
//
//                        travelPointer?.position = (travelPointer?.previous?.position)!
//                    } else {
//
//
//                    }
//
                    travelPointer?.position += 1
                    
                    travelPointer = travelPointer?.next
                }
                
//                if tail?.latexValue != "}" {
//
//                    tail?.position = (tail?.position)! + 1
//                } else {
//
//                    tail?.position = (tail?.previous?.position)!
//                }
                //tail?.position += 1
                //print(travelPointer?.position)
                //print(travelPointer?.latexValue,travelPointer?.next?.latexValue)
            }
            }
    
    }
  
    func delete(cursorPosition: Int) -> Bool {
        
        var deleteOneMore = false
        print("\nDeleting at index", cursorPosition)
        
        var position = cursorPosition - 1
        
        if var travelPointer = head {
            
            if position >= 0{
            
            while travelPointer.position != position && travelPointer.next != nil {
                
                travelPointer = travelPointer.next!
            }
                if travelPointer.latexValue == "}" {
                    print("Found } to delete")
                    if travelPointer.previous?.latexValue != "^{" {
                       
                        travelPointer = travelPointer.previous!
                        position -= 1
                    } else if travelPointer.previous?.latexValue == "^{" {
                        
                        deleteOneMore = true
                    }
                } else if travelPointer.latexValue == "^{" {
                    
                    print("Found ^{ to delete")
                    if travelPointer.next?.latexValue == "}" {
                       
                        travelPointer = travelPointer.next!
                        deleteOneMore = true
                    } else {
                        //write code to remove the adjoning }
                    }
                }
                
                
            if position == head?.position {
                
                print("Deleting head")
                
                if head?.next != nil {
                    
                    head = head?.next
                    head?.previous = nil
                    
                    travelPointer = head!
                    
                    while travelPointer.next != nil {
                        
                        travelPointer.position -= 1
                        travelPointer = travelPointer.next!

                    }
                    tail?.position -= 1
                    
                } else {
                    
                    head = nil
                    tail = nil
                }
                
            } else if position == tail?.position {
                
                print("Deleting tail")
                if !deleteOneMore {
                  
                    tail = travelPointer.previous
                    tail?.next = nil
                } else {
                    
                    tail = travelPointer.previous?.previous
                    tail?.next = nil
                }
            } else {
                
                if !deleteOneMore {
                    var updatePosition = travelPointer.next
                    travelPointer.previous?.next = travelPointer.next
                    travelPointer.next?.previous = travelPointer.previous
                    
                    travelPointer = travelPointer.previous!
                    
                    while updatePosition != nil {
                        
                        updatePosition?.position -= 1
                        updatePosition = updatePosition?.next
                    }
                } else {
                    
                    //Needs fixing. To function properly.
                    print(travelPointer.latexValue)
                    var updatePosition = travelPointer.next
                    travelPointer.previous?.previous?.next = travelPointer.next
                    travelPointer.next?.previous = travelPointer.previous?.previous
                    
                    travelPointer = (updatePosition?.previous)!
                    //Fatal error above.
                    
                    while updatePosition != nil {
                        
                        updatePosition?.position -= 2
                        updatePosition = updatePosition?.next
                    }
                }
                
            }
        }
        
    }
        return deleteOneMore
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
                
                print(travelPointer.latexValue)
                
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
        }
        
        if !cursorSet {
            latexString += "\\ "
            cursorString += "\\check{\\ }"
            cursorSet = true
        }
        
        print("\nLatex: ",latexString,"\nNormal String: ",normalString,"\nCursor String:",cursorString,"\n")
        
        return (latexString,normalString,cursorString)
    }
    
    func length() -> Int {
    
        var length = 0
        
        if let travelPointer = tail {
            length = travelPointer.position
        }
        
        return length
    }
    
    func empty() {
        
        head = nil
        tail = nil
        
    }
}
