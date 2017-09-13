//
//  ButtonBorder.swift
//  SciCal
//
//  Created by Parth Tamane on 13/09/17.
//  Copyright © 2017 Parth Tamane. All rights reserved.
//

import UIKit

var border = false
extension UIButton {
    
    @IBInspectable var borderSet: Bool{
        get {
            return border
        } set {
            border = newValue
            
            if border {
                self.backgroundColor = .clear
                self.layer.cornerRadius = 0
                self.layer.borderWidth = 0
                self.layer.borderColor = UIColor.gray.cgColor
            }
        }
    
    }
}
