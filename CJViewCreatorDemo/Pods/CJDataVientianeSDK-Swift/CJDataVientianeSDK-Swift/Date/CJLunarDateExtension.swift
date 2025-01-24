//
//  CJLunarDateExtension.swift
//  CJUIKitDemo
//
//  Created by qian on 2024/12/3.
//  Copyright © 2024 dvlproad. All rights reserved.
//

import Foundation


// MARK: 闰年、闰月判断
extension Date {
    /// 判断公历年份是否是闰年
    public func isGregorianLeapYear(year: Int) -> Bool {
        return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)
    }

    /// 判断本时间所在的农历月份是否为闰月（兼容 iOS 17 以下）
    /// 判断该年是否为含有闰月的年，即判断该年是否有13个月的方法暂未提供
    public func isLunarLeapMonth() -> Bool {
        guard #available(iOS 17, *) else {
            return _isLunarLeapMonthManual(for: self)
        }
        
        let chineseCalendar = Calendar(identifier: .chinese)
        let components = chineseCalendar.dateComponents([.isLeapMonth], from: self)
        return components.isLeapMonth ?? false
        
    }
    
    /// 判断该月是否为农历的闰月（iOS 17 以下的手动实现）
    private func _isLunarLeapMonthManual(for date: Date) -> Bool {
        guard #available(iOS 17, *) else {
            return false
        }
        
        let chineseCalendar = Calendar(identifier: .chinese)
        let components = chineseCalendar.dateComponents([.month, .isLeapMonth], from: date)
        if let isLeapMonth = components.isLeapMonth {
            return isLeapMonth
        }
        
        // 手动判断农历闰月，检查是否是超过 12 的月份
        let gregorianCalendar = Calendar(identifier: .gregorian)
        let year = gregorianCalendar.component(.year, from: date)
        if _isLunarYearLeap(year: year) {
            return components.month ?? 0 > 12 // 闰月通常是 13 月以上的月份
        }
        return false
    }
    
    /// 手动判断农历年份是否包含闰月
    private func _isLunarYearLeap(year: Int) -> Bool {
        let chineseCalendar = Calendar(identifier: .chinese)
        if let startOfYear = chineseCalendar.date(from: DateComponents(year: year - 1, month: 11, day: 1)),
           let startOfNextYear = chineseCalendar.date(from: DateComponents(year: year, month: 11, day: 1)) {
            let months = chineseCalendar.dateComponents([.month], from: startOfYear, to: startOfNextYear).month ?? 0
            return months > 12 // 农历年有 13 个月
        }
        return false
    }
}

// MARK: 闰年、闰月信息输出
extension Date {
    /// 仅供农历使用：从指定日期之后的未来40天内找出与自己相等的那天（支持只判断日，或者要求月日都相等，如六月初一，下个月要闰六月初一）。如果那月没有指定日，如没有三十，则返回末尾
    /// 注意，此计算结果及时当前日期刚好是每年纪念日，也不会返回今天，而是返回今天之后的下一个
    /// 注意这里只找下个月，eg如果是两个月后则不会显示
    /// - Parameters:
    ///   - fromDate: 从什么时间开始查找与本时间相等的日期
    ///   - isMonthMustEqual: 是否月一定要相等（查找每年几月几号需要设为true，查找每月几号需要设为false）
    /// - Returns: 查找到的日期
    public func findNextEqualLunarDateFromDate(_ fromDate: Date, isMonthMustEqual: Bool) -> Date? {
        guard #available(iOS 17, *) else {
            return nil
        }
        
        var futureNextDate: Date?
        let calendar = Calendar(identifier: .chinese)
        // 获取当前日期和指定比较日期的农历信息
        let targetDateComponents = calendar.dateComponents([.year, .month, .day, .weekday], from: self)
        let targetDateMonth: Int = targetDateComponents.month ?? 0
        let targetDateDay: Int = targetDateComponents.day ?? 0
        let afterDateComponents = calendar.dateComponents([.year, .month, .day, .weekday], from: fromDate)
        let afterDateMonth: Int = afterDateComponents.month ?? 0
        let afterDateDay: Int = afterDateComponents.day ?? 0
        
        if isMonthMustEqual {
            // 如果要计算的位置所在月份已经超过了指定的月份，那不可能在下月找到，只能在明年了
            if afterDateMonth > targetDateMonth {
                return nil
            }
            
            if afterDateMonth < targetDateMonth {
                print("警告：请从当前月开始查找，再找查这里没必要多写算法")
                return nil
            }
        }
        
        // 如果当前日期已经超过目标日期，但当前日期又不是闰月，那也没必要计算，肯定为空
        if afterDateDay > targetDateDay {
            guard fromDate.isNextLunarMonthEqualToCurrentMonth() else {
                return nil
            }
        }
        
        for iAdd in 1..<40 {
            let tempDate = fromDate.addingTimeInterval(TimeInterval(iAdd * 24 * 60 * 60)) // 加1天
            
            let tempComponents = calendar.dateComponents([.year, .month, .day, .weekday], from: tempDate)
            let tempDateMonth: Int = tempComponents.month ?? 0
            let tempDateDay: Int = tempComponents.day ?? 0
            
            if isMonthMustEqual {
                if tempDateMonth == afterDateMonth {
                    if tempDateDay == targetDateDay {
                        futureNextDate = tempDate
                        break
                    }
                } else if tempDateMonth > afterDateMonth { // 已跨越
                    futureNextDate = tempDate.addingTimeInterval(TimeInterval(-1 * 24 * 60 * 60)) // 减去1天
                    break
                }
            } else {
                if tempDateDay == targetDateDay {
                    futureNextDate = tempDate
                    break
                } else if tempDateMonth > afterDateMonth { // 已跨越
                    futureNextDate = tempDate.addingTimeInterval(TimeInterval(-1 * 24 * 60 * 60)) // 减去1天
                    break
                }
            }
        }
        
        if futureNextDate == nil {
            print("所得结果不在当前日期后，却由未在未来一个月内找到与之相对应的日期，可见发生错误")
            return nil
        }
        
        return futureNextDate
    }
    
    
    /// 仅供农历使用：当前时间为公历时间，计算判断其下一个月的月份是否与本月相等。即下个月是否是闰月
    /// 使用场景：常用来判断每年几月几号的下一个纪念日是否需要换年
    public func isNextLunarMonthEqualToCurrentMonth() -> Bool {
        guard #available(iOS 17, *) else {
            return false
        }
        
        let lunarCalendar = Calendar(identifier: .chinese)
        // 获取下一个月的日期
        guard let nextMonthDate = lunarCalendar.date(byAdding: .month, value: 1, to: self) else { // 按农历加一个月，虽然当前是公历时间
            print("无法计算下一个月的日期")
            return false
        }
        
        // 创建农历日历，获取当前月及下个月的相关信息
        let currentComponents = lunarCalendar.dateComponents([.year, .month, .isLeapMonth], from: self)
        guard let currentMonth = currentComponents.month else {
            print("无法获取当前日期的农历信息")
            return false
        }
        let nextComponents = lunarCalendar.dateComponents([.year, .month, .isLeapMonth], from: nextMonthDate)
        guard let nextMonth = nextComponents.month else {
            print("无法获取下一个月的农历信息")
            return false
        }
        
        
        // 判断当前月与下个月是否相等（包含闰月的考虑）
        return currentMonth == nextMonth
    }

    
    public func getThisYearLunarLeapMonthTuple() -> (lunarLeapMonth: Int, lunarLeapMonthCNName:String)? {
        let greCalendar = Calendar(identifier: .gregorian)
        let components = greCalendar.dateComponents([.year, .month], from: self)
        if let year = components.year {
            return Date.getLunarLeapMonthTupleInYear(year)
        }
        
        return nil
    }
    
    static func getLunarLeapMonthTupleInYear(_ year: Int) -> (lunarLeapMonth: Int, lunarLeapMonthCNName:String)? {
        guard #available(iOS 17, *) else {
            return nil
        }
        
        let monthCNString = ["正", "二", "三", "四", "五", "六", "七", "八", "九", "十", "冬", "腊"]
        
        // 创建农历日历
        let lunarCalendar = Calendar(identifier: .chinese)
        
        // 获取农历年份的起始日期
        let greCalendar = Calendar(identifier: .gregorian)
        let startComponents = DateComponents(year: year, month: 1, day: 1)
        guard let startDate = greCalendar.date(from: startComponents) else {
            print("无法生成起始日期")
            return nil
        }
        
        // 获取农历年份的结束日期
        let endComponents = DateComponents(year: year + 1, month: 1, day: 1)
        guard let endDate = greCalendar.date(from: endComponents) else {
            print("无法生成结束日期")
            return nil
        }
        
        // 遍历该农历年份的所有月份
        var date = startDate
        while date < endDate {
            let components = lunarCalendar.dateComponents([.year, .month, .isLeapMonth], from: date)
            if let month = components.month {
                if components.isLeapMonth == true {
                    // 重要：如果是在农历里面找，并且该纪念月刚好是闰月则应该加上"闰"字
                    let lunarMonthName = monthCNString[month - 1]
                    let lunarLeapMonthCNName = "闰" + lunarMonthName + "月"
                    //print("\(month) \(lunarLeapMonthCNName)")
                    return (month, lunarLeapMonthCNName) // 返回闰月的month
                } else {
                    let lunarMonthName = monthCNString[month - 1]
                    //print("\(month) 普通\(lunarMonthName)月")
                }
            }
            
            // 前进到下一个月
            if let nextDate = lunarCalendar.date(byAdding: .month, value: 1, to: date) {
                date = nextDate
            } else {
                break
            }
        }
        
        return nil
    }
}
