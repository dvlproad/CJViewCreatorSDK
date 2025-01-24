//
//  CJCalendarDateExtension.swift
//  CJUIKitDemo
//
//  Created by qian on 2024/12/5.
//  Copyright © 2024 dvlproad. All rights reserved.
//
//  时间在日历中的扩展

import Foundation

public extension Date {
    // MARK: 日期选择器-农历：滑动年
    /// 重新定位指定的农历月份在农历中进行年的切换后，该月在新的年里的位置（因为新的月份表里可能随机插入某个闰月）
    /// 场景：在农历日期选择器中进行年的切换可能导致之前选中的月的位置发生变化。
    /// eg：用于修复①之前选中了闰六月，现在切换到其他年时候，可能变成选了七月。②或者之前选了闰六月后的七月，现在可能变成选八月。③之前选了六月，但切换后的年有闰二月，则会变成选择了五月
    /// - Parameters:
    ///   - targetLunarMonthString: 要重新定位的农历月份
    ///   - newLunarMonthStrings: 要定位那年得来的农历月份表里，可通过 `getLunarMonthStringsInSpicialYear` 接口获得农历指定年有的月数
    /// - Returns: 农历月份在农历中进行年的切换后，该月在新的年里的位置，包括位置索引和对应的结果
    static public func relocationLunarMonthInNewYear(targetLunarMonthString: String, newLunarMonthStrings: [String]) -> (monthIndex: Int, monthString: String)? {
        var newLunarMonthIndex: Int?
        let targetLunarMonthString = targetLunarMonthString
        for i in 0 ..< newLunarMonthStrings.count {
            let iLunarMonth = newLunarMonthStrings[i]
            // 兼容找的是普通的月份、找到是闰月
            if iLunarMonth.contains(targetLunarMonthString) || targetLunarMonthString.contains(iLunarMonth) {
                newLunarMonthIndex = i
                if iLunarMonth == targetLunarMonthString {   // 如果是完全相等那就一定是想要的，如闰月
                    newLunarMonthIndex = i
                    break
                }
            }
        }
        
        if newLunarMonthIndex == nil {
            return nil
        }
        let newLunarMonthString = newLunarMonthStrings[newLunarMonthIndex!]
        return (newLunarMonthIndex!, newLunarMonthString)
    }
    
    /// 日期选择器，滑动年重新计算农历指定年有的月数。
    /// 使用场景：日历表滑动时候，判断指定的年有多少个月，避免当前是31号，然后选的那月没有31号，而导致调到下个月。正确的应该是显示那月的末尾
    /// - Parameters:
    ///   - inLunarCalendar: 是否是农历
    ///   - year: 指定的年
    ///   - leapMonthNumber: 那年闰月所在的位置，有闰月的时候值为1-12，没有闰月的时候值为0
    /// - Returns: 农历指定年有的月数
    static public func getLunarMonthStringsInSpicialYear(year: Int, leapMonthNumber: Int) -> [String] {
        var lunarMonthNumberStrings = ["正", "二" ,"三", "四", "五", "六", "七", "八" ,"九", "十", "冬", "腊"]
        if leapMonthNumber > 0 {
            let leapMonthString = "闰\(lunarMonthNumberStrings[leapMonthNumber - 1])"
            lunarMonthNumberStrings.insert(leapMonthString, at: leapMonthNumber)
        }
        return lunarMonthNumberStrings
    }
    
    // MARK: 日期选择器-公历/农历：滑动月或滑动年（2月29号滑动年 / 1月31号滑动月），对月的处理（该月有多少天、）
    /// 获取公历/农历指定年月有的天数。使用场景：日历表滑动时候，判断指定的年月有多少天，避免当前是31号，然后选的那月没有31号，而导致调到下个月。正确的应该是显示那月的末尾
    /// - Parameters:
    ///   - inLunarCalendar: 是否是农历
    ///   - year: 指定的年
    ///   - monthNumberString: 指定的月。为月的数字字符串。格林时候为1-12，中文日历时候为正、二、三、...、腊，不包含月字
    /// - Returns: 公历/农历指定年月有的天数
    static public func getDayStringsInSpicialYearAndMonth(inLunarCalendar: Bool, year: Int, monthNumberString: String) -> [String] {
        var newDateWithMonthFirstDay: Date = Date.fromYearNumber_monthNumberString_dayString(inLunarCalendar: inLunarCalendar, year: year, monthNumberString: monthNumberString, dayFullString: inLunarCalendar ? "初一" : "1日") ?? errorDate()  // dayFullString 不能使用之前的值，因为之前可能是三十号，但新的这个month所在的月可能没有三十号，而导致到时候会跳到下个月去
        
        let monthAndDayTuple = newDateWithMonthFirstDay.currentMonthDayCountTuple(inLunarCalendar: inLunarCalendar)
        let dayCount: Int = monthAndDayTuple?.dayCount ?? 29
        
        if inLunarCalendar {
            let maxDays = ["初一", "初二" ,"初三", "初四", "初五", "初六", "初七", "初八" ,"初九", "初十", "十一", "十二", "十三", "十四" ,"十五", "十六", "十七", "十八", "十九", "二十" ,"廿一", "廿二", "廿三", "廿四", "廿五", "廿六" ,"廿七", "廿八", "廿九", "三十"]
            return Array(maxDays.prefix(dayCount))
        } else {
            return (1...dayCount).map { "\($0)日" }
        }
    }
    
    /// 获取本时间所在的【公历/农历】年份中有多少个月，以及当前月有多少天。请不要使用此方法计算农历有多少个月，因为本方法在农历有闰月的时候计算结果不对。
    /// 场景：日期选择器弹起来的时候，天那一列要有多少个元素
    public func currentMonthDayCountTuple(inLunarCalendar: Bool = false) -> (monthCount: Int, dayCount: Int)? {
        let calendar = Calendar(identifier: inLunarCalendar ? .chinese : .gregorian)
 
        let monthRange = calendar.range(of: .month, in: .year, for: self)
        let monthCount: Int? = monthRange?.count
        if monthCount == nil {
            return nil
        }
        
        let dayRange = calendar.range(of: .day, in: .month, for: self)
        let dayCount: Int? = dayRange?.count
        if dayCount == nil {
            return nil
        }
        
        return (monthCount!, dayCount!)
    }
    
    // MARK: 日期选择器-滑动结束生成时间
    /// 根据在公历/农历日期选择器选中的年月日字符串转成时间Date
    /// - Parameters:
    ///   - inLunarCalendar: 是否是农历
    ///   - year: 指定的年
    ///   - monthNumberString: 指定的月。为月的数字字符串。格林时候为1-12，中文日历时候为正、二、三、...、腊，不包含月字
    ///   - dayFullString: 指定的天。为天的完整字符串。格林时候为1日、2日、...、30日，中文日历时候为初一、初二、初三、...、三十
    /// - Returns: 对应的公历时间
    static public func fromYearNumber_monthNumberString_dayString(inLunarCalendar: Bool, year: Int, monthNumberString: String, dayFullString: String) -> Date? {
        var date: Date?
        if inLunarCalendar {
            let lunarMediumString = "\(year)年\(monthNumberString)月\(dayFullString)"
            date = Date.fromLunarMediumString(lunarMediumString)
        } else {
            let dayNumberString = dayFullString.replacingOccurrences(of: "日", with: "")
            let dayNumber = Int(dayNumberString)
            
            let calendar = Calendar.current
            var components = DateComponents()
            components.year = year
            components.month = (monthNumberString as NSString).integerValue
            components.day = dayNumber
            components.calendar = Calendar(identifier: .gregorian)
            date = calendar.date(from: components)
        }
        return date
    }
    
    /// 将形如 "2025年腊月二十" String 转为 Date
    static public func fromLunarMediumString(_ lunarMediumString: String) -> Date? {
        let calendar = Calendar(identifier: .chinese)

        let chineseFormatter = DateFormatter()
        chineseFormatter.locale = Locale(identifier: "zh_CN")
        chineseFormatter.dateStyle = .medium
        chineseFormatter.calendar = calendar
        
        let date: Date? = chineseFormatter.date(from: lunarMediumString)
        return date
    }
}
