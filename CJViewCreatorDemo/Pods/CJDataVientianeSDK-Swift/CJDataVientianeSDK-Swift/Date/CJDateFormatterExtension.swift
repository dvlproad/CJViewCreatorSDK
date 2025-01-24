//
//  CJDateFormatterExtension.swift
//  CJUIKitDemo
//
//  Created by qian on 2024/12/4.
//  Copyright © 2024 dvlproad. All rights reserved.
//

import Foundation

// MARK: 时间 TimeString 的 Date 与 String 互相转换
/// 时间字符串的格式类型
public enum DateTimeStringType {
    case en_24  // 标准的24小时制
    case en_12  // 英文的12小时制
    case cn_12  // 中文版12小时制
}
public extension Date {
    /// 提供一个错误的时间，便于排查
    static func errorDate() -> Date  {
        let errorDateComponents = DateComponents(year: 2999, month: 12, day: 27)
        let date: Date = Calendar.current.date(from: errorDateComponents) ?? Date()
        return date
    }
    
    /// 判断系统当前是12小时制，还是24小时制。使用场景：辅助日志输出
    static func is12HourSystem() -> Bool {
        // 方法1：
        let timeFormat: String? = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: Locale.current)
        // 方法2：
        //let dateFormatter = DateFormatter()
        //dateFormatter.dateStyle = .none
        //dateFormatter.timeStyle = .short
        //let timeFormat: String? = dateFormatter.dateFormat
        
        let is12HourFormat = timeFormat?.contains("a") == true  // 检查是否包含 AM/PM 标识符
        return is12HourFormat
    }
    
    /// 从时间字符串中恢复日期（需判断时间字符串格式，注意：即使Date转字符串的时候，在12小时制下也是使用 yyyy-MM-dd HH:mm:ss ，且结果也会变成 yyyy-MM-dd hh:mm:ss a 或 yyyy-MM-dd ahh:mm:ss 格式的字符串）
    static public func fromTimeString(_ timeString: String) -> Date? {
        var dateFormat: String = "yyyy-MM-dd HH:mm:ss"
        var locale: Locale = Locale(identifier: "en_US")  // 使用固定的Locale，避免受到设备语言设置影响
        let type = Date.getTimeStringType(timeString: timeString)
        if type == .cn_12 {
            dateFormat = "yyyy-MM-dd ahh:mm:ss"
            locale = Locale(identifier: "zh_CN")  // 使用中文 locale 以确保正确解析 "上午" 和 "下午"
        } else if type == .en_12 {
            dateFormat = "yyyy-MM-dd hh:mm:ss a"
        }
        
        let dateFormatter24 = DateFormatter()
        dateFormatter24.locale = locale
        dateFormatter24.timeZone = TimeZone.current  // 使用当前设备的时区
        dateFormatter24.dateFormat = dateFormat

        let date: Date? = dateFormatter24.date(from: timeString)
        return date
    }
    
    /// 判断一个时间字符串是12小时制还是24小时制。使用场景：正确判断出来后才能使用正确format去格式化
    /// 目前只针对日期转字符串使用的是 yyyy-MM-dd HH:mm:ss 格式，如果是24小时制的时间字符串则仍使用 yyyy-MM-dd HH:mm:ss ，否则如果是12小时制的时间则当为英文时应使用 yyyy-MM-dd hh:mm:ss a 而中文的12小时制应使用 yyyy-MM-dd ahh:mm:ss
    static public func getTimeStringType(timeString: String) -> DateTimeStringType {
        // 使用正则表达式检查是否包含 "AM" 或 "PM"
        let ampmPattern = "(AM|PM|am|pm|上午|下午)"
        let regex = try! NSRegularExpression(pattern: ampmPattern, options: [])
        let range = NSRange(location: 0, length: timeString.utf16.count)
        let match = regex.firstMatch(in: timeString, options: [], range: range)
        if match != nil {
            if timeString.contains("上午") || timeString.contains("下午") {
                return DateTimeStringType.cn_12
            } else {
                return DateTimeStringType.en_12
            }
        }
        return DateTimeStringType.en_24
    }
    
    static public func getTimeFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        //dateFormatter.locale = Locale.current
        //dateFormatter.locale = Locale(identifier: "en_US")  // zh_CN  en_US  zh_Hans_CN en_US_POSIX 修复iOS 16.5 以上12小时制/24小时制 HH/hh引起的时间计算错误
        dateFormatter.locale = Locale.autoupdatingCurrent
        dateFormatter.calendar = Calendar.init(identifier: .gregorian)
        
        dateFormatter.timeZone = .current
        
        return dateFormatter
    }
    
    /// 格式转换
    public func toTimeString() -> String {
        let dateFormatter = Date.getTimeFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
    
    /// 日期字符串，格式为2024/5/20
    static func getYYMMDDDateString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let dateString = formatter.string(from: date)
        return dateString
        //        let components = Calendar.current.dateComponents([.year, .month ,.day], from: date)
        //        return "\((components.year ?? 2023))/\(components.month ?? 3)/\(components.day ?? 29)"
    }
}
