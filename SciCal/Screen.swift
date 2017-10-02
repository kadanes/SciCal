//
//  Screen.swift
//  SciCal
//
//  Created by Parth Tamane on 02/10/17.
//  Copyright © 2017 Parth Tamane. All rights reserved.
//

import UIKit
import iosMath

class Screen {

    @IBOutlet weak var expressionView: UIView!
    let label =  MTMathUILabel()
    let labelCursor = MTMathUILabel()
     var expressionScrollView : UIScrollView
    var labelLatixSize: CGSize
    var cursorLatixSize: CGSize
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
     init() {
     
        
        //mainScreenStackView.isHidden = true
        
        label.fontSize = 40.0
        labelCursor.fontSize = 40.0
        label.textColor = UIColor.white
        labelCursor.textColor = UIColor.black
        
        labelCursor.latex = "\\check{\\ }"
        label.latex = "\\ "
        
        
        //label.latex =  "x = \\frac{\\frac{-b \\pm \\sqrt{b^2\\ 3-\\ 4ac}}{2a}\\times5\\ 4+10}{\\frac{100}{10}}\\times10000"
        //labelCursor.latex = "x = \\frac{\\frac{-b \\pm \\sqrt{b^2\\check{\\ }3-\\check{\\ }4ac}}{2a}\\times5\\check{\\ }4+10}{\\frac{100}{10}}\\times10000"
        
        labelLatixSize = label.intrinsicContentSize
        cursorLatixSize = labelCursor.intrinsicContentSize
        
        expressionScrollView = UIScrollView(frame: expressionView.bounds)
        
        print("\nWidth:",labelLatixSize.width," Height:",labelLatixSize.width, "\n")
        
        //        expressionScrollView.contentSize = CGSize(width: labelLatixSize.width + 5.0, height: labelLatixSize.height + 5.0 )
        
        expressionScrollView.addSubview(labelCursor)
        
        expressionScrollView.addSubview(label)
        
        updateExpressionFrame()
        
        expressionView.addSubview(expressionScrollView)
        
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
        
        expressionScrollView.contentSize = CGSize(width: labelLatixSize.width + 5.0, height: labelLatixSize.height + 5.0 )
        labelCursor.frame = CGRect(x: 5.0 , y: 5.0, width: cursorLatixSize.width, height: cursorLatixSize.height)
        label.frame = CGRect(x: 5.0, y: 5.0, width: labelLatixSize.width, height: labelLatixSize.height)
        
        //        print("\nWidth:",labelLatixSize.width," Height:",labelLatixSize.width, "\n")
        
        
    }

}
