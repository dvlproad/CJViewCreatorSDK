//
//  CJColorExtension.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/12/22.
//

import Foundation
import UIKit
import SwiftUI

public extension UIColor {
    /// 返回随机颜色
    static var randomColor: UIColor {
        let red = CGFloat(arc4random() % 256 ) / 255.0
        let green = CGFloat(arc4random() % 256) / 255.0
        let blue = CGFloat(arc4random() % 256) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
//    convenience init(hex string: String, alpha: CGFloat = 1) {
//        self = UIColor.cjColor(withHexString: string, alpha: alpha)
//    }
    convenience public init(hex string: String, alpha: CGFloat = 1) {
        var hex = string.hasPrefix("#") ? String(string.dropFirst()) : string
        guard hex.count == 3 || hex.count == 6 || hex.count == 8 else {
            self.init(white: 1.0, alpha: 0.0)
            return
        }
        
        var a: CGFloat = alpha
        
        if hex.count == 8 {
            let alphaHex = hex.subStringTo(index: 1)
            guard let alphaCode = Int(alphaHex, radix: 16) else {
                self.init(white: 1.0, alpha: 0.0)
                return
            }
            a = CGFloat((alphaCode) & 0xFF) / 255.0
            
            hex = hex.subStringFrom(index: 2)
        }
        
        if hex.count == 3 {
            for (index, char) in hex.enumerated() {
                hex.insert(char, at: hex.index(hex.startIndex, offsetBy: index * 2))
            }
        }
        
        guard let intCode = Int(hex, radix: 16) else {
            self.init(white: 1.0, alpha: 0.0)
            return
        }
        
        self.init(
            red: CGFloat((intCode >> 16) & 0xFF) / 255.0,
            green: CGFloat((intCode >> 8) & 0xFF) / 255.0,
            blue: CGFloat((intCode) & 0xFF) / 255.0, alpha: a)
    }
}


public extension Color {
    static var randomColor: Color {
        let red = Double(arc4random() % 256 ) / 255.0
        let green = Double(arc4random() % 256) / 255.0
        let blue = Double(arc4random() % 256) / 255.0
        return Color(red: red, green: green, blue: blue)
    }
    
    public init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    public func toHex(includeAlpha: Bool = false) -> String? {
        // 将Color转换为UIColor
        let uiColor = UIColor(self)
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        // 尝试获取颜色的RGBA值
        guard uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            // 如果无法获取，返回nil
            return nil
        }
        if(red > 1){
            red = 1
        }else if(red < 0){
            red = 0
        }
        if(green > 1){
            green = 1
        }else if(green < 0){
            green = 0
        }
        if(blue > 1){
            blue = 1
        }else if(blue < 0){
            blue = 0
        }
        print("\(red)==\(green)")
        // 根据是否包含透明度来决定格式化字符串
        if includeAlpha {
            // 将RGBA值转换为十六进制字符串，包括透明度
            return String(format: "#%02X%02X%02X%02X", Int(red * 255), Int(green * 255), Int(blue * 255), Int(alpha * 255))
        } else {
            // 将RGB值转换为十六进制字符串
            return String(format: "#%02X%02X%02X", Int(red * 255), Int(green * 255), Int(blue * 255))
        }
    }
}

func hexStringToUIColor(hex: String) -> UIColor {
    var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if cString.hasPrefix("#") {
        cString.remove(at: cString.startIndex)
    }
    
    if cString.count != 6 {
        return UIColor.gray // 返回默认颜色，如果不符合十六进制颜色格式
    }
    
    var rgbValue: UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}
