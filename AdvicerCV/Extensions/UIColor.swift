//
//  UIColor.swift
//  AdvicerCV
//
//  Created by Mykhailo Dovhyi on 02.04.2025.
//

import UIKit

extension UIColor {
    public convenience init?(hex:String) {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            self.init(named: "CategoryColor")
            return
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    var toHex: String {
        if let components = self.cgColor.components, components.count >= 3 {
            let red = Int(components[0] * 255.0)
            let green = Int(components[1] * 255.0)
            let blue = Int(components[2] * 255.0)
            
            return String(format: "#%02X%02X%02X", red, green, blue)
        }
        
        return "#000000"
    }
    
    var isLight: Bool {
        var white: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        
        if getWhite(&white, alpha: &alpha) {
            return white > 1
        }
        
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        
        if getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            let luminance = 0.2126 * red + 0.7152 * green + 0.0722 * blue
            return luminance > 0.5
        }
        
        return false
    }
}

