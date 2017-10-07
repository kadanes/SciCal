//
//  ExpressionEvaluator..swift
//  SciCal
//
//  Created by Parth Tamane on 22/09/17.
//  Copyright © 2017 Parth Tamane. All rights reserved.
//

import Foundation

class ExpressionEvaluator {
    
    let operandStack = Stack()
    let operatorStack = Stack()
    
    let infix: String
    //let operationMode: Int
    //let internalMode: Int
    let mode: Int
    
    init(infix: String, mode: Int) {
        self.infix = infix
        self.mode = mode
        
        print("Infix string receieved is: ")
        for chars in infix {
            print(chars)
        }
    }
    
    func evaluateExpression() -> String {
        
       let tokenArray = infix.components(separatedBy: " ")
                
        for token in tokenArray {
            
            print(operandStack.stackArray)
            
            if token == "*" || token == "/" || token == "+" || token == "-" || token == "^" {
                
                while precidence(incommingToken: token, stackTopToken: operatorStack.peek())  && !operatorStack.empty(){
                    
                    let answer = operate(operation: operatorStack.pop(), rightOperand: operandStack.pop(), leftOperand: operandStack.pop())
                    
                    operandStack.push(stringToPush: answer)
        
                   print("1 Pushed: ", answer)
                }
                
                operatorStack.push(stringToPush: token)
                
            } else if token == "(" {
               
                
                operatorStack.push(stringToPush: token)
            } else if token == ")" {
                

                while operatorStack.peek() != "(" {
                   
                    
                    let answer = operate(operation: operatorStack.pop(), rightOperand: operandStack.pop(), leftOperand: operandStack.pop())
                    
                    operandStack.push(stringToPush: answer)
                    print("2 Pushed: ", answer)

                }
                
                
                operatorStack.pop()
                
            } else if token == "!" {
                
                var answer = operandStack.pop()
                
                answer = factorial(factorialOf: answer)
                
                operandStack.push(stringToPush: answer)
                
            } else if token == " " || token == "" {
            
                print("Blank token")
            } else {
             
                operandStack.push(stringToPush: token)
                print("3 Pushed: ", token)

            }
        }
        
        while !operatorStack.empty() {
            
            let answer = operate(operation: operatorStack.pop(), rightOperand: operandStack.pop(), leftOperand: operandStack.pop())
            
            operandStack.push(stringToPush: answer)
            
            print(answer)
        }
        
        let answerString = operandStack.pop()
        
        if let answer = Double(answerString) {
            
            if answer != floor(answer) {
                
                return "\(answer)"
            } else {
                
                let integerAnswer = Int(answer)
                return "\(integerAnswer)"
            }
            
        }
        
        return "0"
    }
    
    
    
    func operate( operation: String, rightOperand: String?, leftOperand: String?) -> String {
        
        
        if let leftOpreandString = leftOperand , let rightOperandString = rightOperand {
            
            if let leftOperandDouble = Double(leftOpreandString), let rightOperandDouble = Double(rightOperandString) {
                
                switch operation {
                case "*":
                    
                    
                    return String( leftOperandDouble * rightOperandDouble )
                    
                case "/":
                    
                    return String( leftOperandDouble / rightOperandDouble )
                case "+":
                    
                    return String( leftOperandDouble + rightOperandDouble )

                case "-":
                    
                    return String( leftOperandDouble - rightOperandDouble )

                case "^":
                    return String( pow(leftOperandDouble, rightOperandDouble) )

                default:
                    
                    return ""
                }
            }
           
        }
        
        return "Math Error!"
    }
    
    func factorial(factorialOf: String ) -> String {
        
        
        print("Factorial of :",factorialOf)
        
        if let factorialLimitCheck = Double(factorialOf) {
          
            var factorial = 1
            
            if floor(factorialLimitCheck) == factorialLimitCheck && factorialLimitCheck <= 17 {
                
                var factorialLimit = Int(factorialLimitCheck)
                  
                    while factorialLimit != 0 {
                        
                        factorial *= factorialLimit
                        factorialLimit -= 1
                }
                    
                return "\(factorial)"
            
            }
        }
    
        return ""
    }
    
    func precidence( incommingToken: String, stackTopToken: String ) -> Bool {
        
        
        if incommingToken == "*" || incommingToken == "/" {
            
            if stackTopToken == "*" || stackTopToken == "/" {
                
              return true
            } else if stackTopToken == "+" || stackTopToken == "-" || stackTopToken == "(" {
                
                return false
            }
        } else if incommingToken == "+" || incommingToken == "-" {
            if stackTopToken == "*" || stackTopToken == "/" || stackTopToken == "+" || stackTopToken == "-" {
                
                return true
            } else if  stackTopToken == "(" {
                
                return false
            }
        } else if incommingToken == "^" {
            
            return false
        }
        
        return false
    }
}
