//
//  UIColor+Extension.swift
//  RemindWhere
//
//  Created by Adriano Soares on 22/04/15.
//  Copyright (c) 2015 Bepid. All rights reserved.
//

import Foundation

extension UIColor{
  func toString() -> String {
    var components = CGColorGetComponents(self.CGColor);
    var colorString  = components[0].description + ";"
        colorString += components[1].description + ";"
        colorString += components[2].description + ";"
        colorString += components[3].description
  
    return colorString;
  }
  
  class func colorWithString (string: String) -> UIColor {
    var components = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).componentsSeparatedByString(";")
    var r: Double = (components[0] as NSString).doubleValue
    var g: Double = (components[1] as NSString).doubleValue
    var b: Double = (components[2] as NSString).doubleValue
    var a: Double = (components[3] as NSString).doubleValue
    
    return UIColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: CGFloat(a))
  }
}