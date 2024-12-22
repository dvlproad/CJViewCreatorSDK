//
//  CJDateExtension.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/9/3.
//

import Foundation

extension Date {
    static func lunarDateString(now: Date,
                                dateStyle: DateFormatter.Style = .long,
                                justYear: Bool = false) -> String {

        let chineseFormatter = DateFormatter()
        chineseFormatter.locale = Locale(identifier: "zh_CN")
        chineseFormatter.dateStyle = dateStyle
        chineseFormatter.calendar = Calendar(identifier: .chinese)
        
        let dateString = chineseFormatter.string(from: now)

        if justYear, let range = dateString.range(of: "年") {
            // 返回 "年" 字符之前的部分
            return String(dateString[..<range.lowerBound])
        }
        return dateString
    }
    
    /// 获取生肖
    func getZodiac() -> String {
        let dateString = Date.lunarDateString(now: self)
                
        let year = (String(dateString.prefix(4)) as NSString).integerValue
        let zodiacSigns = ["鼠", "牛", "虎", "兔", "龙", "蛇",
                           "马", "羊", "猴", "鸡", "狗", "猪"]
        let baseYear = 1900 // 基准年是鼠年
        let index = (year - baseYear) % 12
        return zodiacSigns[(index + 12) % 12] // 防止负数取模
    }
    
    /// 获取星座
    func getZodiacSign() -> String {
        var calendar = Calendar.current
        calendar.timeZone = .current
        let month = calendar.component(.month, from: self)
        let day = calendar.component(.day, from: self)
        
        switch (month, day) {
        case (1, 20...31), (2, 1...18): return "水瓶座"
        case (2, 19...29), (3, 1...20): return "双鱼座"
        case (3, 21...31), (4, 1...19): return "白羊座"
        case (4, 20...30), (5, 1...20): return "金牛座"
        case (5, 21...31), (6, 1...20): return "双子座"
        case (6, 21...30), (7, 1...22): return "巨蟹座"
        case (7, 23...31), (8, 1...22): return "狮子座"
        case (8, 23...31), (9, 1...22): return "处女座"
        case (9, 23...30), (10, 1...22): return "天秤座"
        case (10, 23...31), (11, 1...21): return "天蝎座"
        case (11, 22...30), (12, 1...21): return "射手座"
        case (12, 22...31), (1, 1...19): return "摩羯座"
        default: return "无效日期"
        }
    }
}
