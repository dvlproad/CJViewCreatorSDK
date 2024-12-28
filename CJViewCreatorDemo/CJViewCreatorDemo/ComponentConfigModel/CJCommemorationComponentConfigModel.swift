//
//  CJCommemorationComponentConfigModel.swift
//  CJViewCreatorSDK
//
//  Created by qian on 2024/11/25.
//
//  含日期的数据模型（eg：纪念日为文本+日期模型）

import Foundation
import WidgetKit
import CJDataVientianeSDK_Swift
import CJViewElement_Swift

// MARK: 组件完整类
public class CJCommemorationComponentConfigModel: CJBaseComponentConfigModel<CJCommemorationDataModel, CJCommemorationLayoutModel> {
    required init() {
        super.init()
    }
    
    convenience public init(title: String, date: Date, cycleType: CJCommemorationCycleType, shouldContainToday: Bool, family: WidgetFamily, index: Int = 0) {
        var titleLayoutModel = CJTextLayoutModel()
        var dateLayoutModel = CJTextLayoutModel()
        var countdownLayoutModel = CJTextLayoutModel()
        var dayUnitLayoutModel = CJTextLayoutModel()
//        let layoutModels = TSRowDataUtil.getLayoutModels(thingCount: index+1, family: family)
//        if layoutModels?.count ?? 0 >= 4 {
//            titleLayoutModel = layoutModels![0]
//            dateLayoutModel = layoutModels![1]
//            countdownLayoutModel = layoutModels![2]
//            dayUnitLayoutModel = layoutModels![3]
//        }
//        
        
        self.init(title: title, date: date, cycleType: cycleType, shouldContainToday: shouldContainToday, titleLayoutModel: titleLayoutModel, dateLayoutModel: dateLayoutModel, countdownLayoutModel: countdownLayoutModel, dayUnitLayoutModel:dayUnitLayoutModel)
    }
    
    public init(title: String, date: Date, cycleType: CJCommemorationCycleType, shouldContainToday: Bool, titleLayoutModel: CJTextLayoutModel, dateLayoutModel: CJTextLayoutModel, countdownLayoutModel: CJTextLayoutModel, dayUnitLayoutModel: CJTextLayoutModel) {
        let data = CJCommemorationDataModel(title:title, date: date, cycleType: cycleType, shouldContainToday: shouldContainToday)
        
        let layout = CJCommemorationLayoutModel()
        layout.titleLayoutModel = titleLayoutModel
        layout.dateLayoutModel = dateLayoutModel
        layout.countdownLayoutModel = countdownLayoutModel
        layout.dayUnitLayoutModel = dayUnitLayoutModel
        
        super.init(id: "", componentType: .commemoration, data: data, layout: layout)
        self.updateData(referDate: date)
    }
    
//    override public init(id: String, componentType: CJComponentType, data: CJCommemorationDataModel, layout: CJCommemorationLayoutModel, childComponents: [any CJBaseComponentConfigModelProtocol]? = nil) {
//        super.init(id: id, componentType: componentType, data: data, layout: layout)
//    }
    
    // MARK: - Codable
    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        /*
        super.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        componentType = try container.decode(CJComponentType.self, forKey: .componentType)
        
        do {
            data = try container.decode(CJCommemorationDataModel.self, forKey: .data)
            //debugPrint("CJCommemorationDataModel ✅\(data)")
        } catch {
            debugPrint("error:\(error)")
        }
        do {
            layout = try container.decode(CJCommemorationLayoutModel.self, forKey: .layout)
            //debugPrint("CJCommemorationLayoutModel ✅\(layout)")
        } catch {
            debugPrint("error:\(error)")
        }
        
        do {
            // 动态解码 childComponents
            let childDataArray = try container.decodeIfPresent([DynamicCodableComponent].self, forKey: .childComponents)
            if childDataArray != nil {
                childComponents = childDataArray!.compactMap { $0.base }
            }
            //debugPrint("CJCommemorationLayoutModel ✅\(layout)")
        } catch {
            debugPrint("❌Error: 动态解码 childComponents 失败, \(error)")
        }
        */
    }
    
    public func updateData(referDate: Date, isForDesktop: Bool = false) {
        self.layout.titleLayoutModel.text = self.data.title

        let dateString = self.data.getNextRepeatDateString(referDate: referDate)
        self.layout.dateLayoutModel.text = dateString
   
        let countdownDaysString = self.data.stringForPreviewCountdownDays(referDate: referDate)
        if isForDesktop {
            //let referDateString = referDate.format()
            //print("桌面时间线 referDate:\(referDateString) \(countdownDaysString)")
        }
        self.layout.countdownLayoutModel.text = countdownDaysString
        
        self.layout.dayUnitLayoutModel.text = "天"
    }
}


// MARK: 组件Layout布局类
public class CJCommemorationLayoutModel: CJBaseModel {
    var titleLayoutModel: CJTextLayoutModel = CJTextLayoutModel()
    var dateLayoutModel: CJTextLayoutModel = CJTextLayoutModel()
    var countdownLayoutModel: CJTextLayoutModel = CJTextLayoutModel()
    var dayUnitLayoutModel: CJTextLayoutModel = CJTextLayoutModel()
    
    // MARK: - Equatable
    static public func == (lhs: CJCommemorationLayoutModel, rhs: CJCommemorationLayoutModel) -> Bool {
        return lhs.titleLayoutModel == rhs.titleLayoutModel
            && lhs.dateLayoutModel == rhs.dateLayoutModel
            && lhs.countdownLayoutModel == rhs.countdownLayoutModel
            && lhs.dayUnitLayoutModel == rhs.dayUnitLayoutModel
    }
    
    // MARK: - init
    required public init() {
        
    }
    
    // MARK: - Codable
    private enum CodingKeys: String, CodingKey {
        case titleLayoutModel
        case dateLayoutModel
        case countdownLayoutModel
        case dayUnitLayoutModel
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.titleLayoutModel = try container.decode(CJTextLayoutModel.self, forKey: .titleLayoutModel)
        self.dateLayoutModel = try container.decode(CJTextLayoutModel.self, forKey: .dateLayoutModel)
        self.countdownLayoutModel = try container.decode(CJTextLayoutModel.self, forKey: .countdownLayoutModel)
        self.dayUnitLayoutModel = try container.decode(CJTextLayoutModel.self, forKey: .dayUnitLayoutModel)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(titleLayoutModel, forKey: .titleLayoutModel)
        try container.encodeIfPresent(dateLayoutModel, forKey: .dateLayoutModel)
        try container.encodeIfPresent(countdownLayoutModel, forKey: .countdownLayoutModel)
        try container.encodeIfPresent(dayUnitLayoutModel, forKey: .dayUnitLayoutModel)
    }

    
}

// MARK: 组件Data数据类
public class CJCommemorationDataModel: CJCommemorationDateModel {
//    var layoutModels: [CJTextLayoutModel]
    
    var title: String
    
    required public init() {
        self.title = ""
        super.init()
    }
    
    public init(title: String, date: Date, cycleType: CJCommemorationCycleType, shouldContainToday: Bool) {
        self.title = title

        super.init(date: date, cycleType: cycleType, shouldContainToday: shouldContainToday)
    }
    
    // MARK: - Codable
    private enum CodingKeys: String, CodingKey {
        case title
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        
        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
    }
}

public class CJCommemorationDateModel: CJDateModel {
    var cycleType: CJCommemorationCycleType   // 按什么周期过纪念日（每周、每月、每年、不重复）
    var includeTodayIsOn: Bool                // 是否包含当天
    // MARK: Get
    var includeTodayChangeEnable : Bool {
        return self.cycleType != .none
    }
    
    required public init() {
        self.cycleType = .none
        self.includeTodayIsOn = true
        
        super.init()
    }
    
    fileprivate init(date: Date, isLunarStringType: Bool = false, cycleType: CJCommemorationCycleType, shouldContainToday: Bool) {
        self.cycleType = cycleType
        self.includeTodayIsOn = shouldContainToday
        
        super.init(date: date, isLunarStringType: isLunarStringType)
    }
    
    // MARK: - Codable
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.cycleType = try container.decode(CJCommemorationCycleType.self, forKey: .cycleType)
        self.includeTodayIsOn = try container.decodeIfPresent(Bool.self, forKey: .includeTodayIsOn) ?? false
        
        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(cycleType, forKey: .cycleType)
    }

    private enum CodingKeys: String, CodingKey {
        case cycleType
        case includeTodayIsOn
    }
    
    /// 下一个循环的日期
    func getNextRepeatDate(referDate: Date) -> Date {
        let tCalendar = Calendar(identifier: dateStringIsLunarType ? .chinese : .gregorian)
        let nextRepateDate = date.closestCommemorationDate(commemorationCycleType: cycleType, afterDate: referDate, shouldFlyback: true, calendar: tCalendar) ?? Date()
        return nextRepateDate
    }
    
    /// 【下一个循环日期预览视图】所在行的展示字符串：日期
    func getNextRepeatDateString(referDate: Date) -> String {
        let nextRepateDate = getNextRepeatDate(referDate: referDate)
        
        var dateString: String
        if dateStringIsLunarType {
            let lunarTuple = nextRepateDate.lunarTuple()
            dateString = "\(lunarTuple.lunarYear)\(lunarTuple.stemBranch).\(lunarTuple.monthString)月.\(lunarTuple.dayString)"   // 2024甲辰年.腊月.十二
        } else {
            dateString = nextRepateDate.format("yyyy/MM/dd")
        }
        
        return dateString
    }
    
    
    /// 是否显示包含今天的那个设置（如果选中的日期是今天及今后的则不显示）
    var shouldShowContainTodaySetting: Bool {
        let days = date.daysBetween(endDate: Date())
        return days < 0
    }
    
    /// 【下一个循环日期预览视图】所在行的展示字符串：天数
    func stringForPreviewCountdownDays(referDate: Date) -> String {
        let nextRepateDate = getNextRepeatDate(referDate: referDate)
        
        var days = nextRepateDate.daysBetween(endDate: referDate)
        if self.shouldShowContainTodaySetting && !includeTodayChangeEnable && includeTodayIsOn  {
            if days == 0 {
                days = 1
            } else if days >= 0 {
                days += 1
            } else {
                days -= 1
            }
        }
        
        return String(abs(days))
    }
    
    /// 【目标日】所在行的展示字符串
    func stringForDateChooseRow() -> String {
        return getSelectedDateString(fullShowWeekDay: true)
    }
    
    /// 【日期列表】所在行的展示字符串
    func stringForDateCollectionView() -> String {
        return getSelectedDateString(fullShowWeekDay: false)
    }
    
    fileprivate func getSelectedDateString(fullShowWeekDay: Bool) -> String {
        var dateString: String = date.commemorationDateString(cycleType: cycleType, showInLunarType: dateStringIsLunarType)
        if cycleType == .none && fullShowWeekDay {
            let weekDay = date.weekdayString()
            dateString += " \(weekDay)"
        }

        return dateString
    }
}



public class CJDateModel: CJBaseModel {
    var date: Date                  // 日期
    var dateStringIsLunarType: Bool // 日期展示是否要用农历形式


    static public func == (lhs: CJDateModel, rhs: CJDateModel) -> Bool {
        return lhs.date == rhs.date && lhs.dateStringIsLunarType == rhs.dateStringIsLunarType
    }
    
    
    required public init() {
        self.date = Date()
        self.dateStringIsLunarType = false
    }
    
    fileprivate init(date: Date, isLunarStringType: Bool = false) {
        self.date = date
        self.dateStringIsLunarType = isLunarStringType
    }
    
    // MARK: - Codable
    private enum CodingKeys: String, CodingKey {
        case date
        case dateStringIsLunarType
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            let dateString = try container.decode(String.self, forKey: .date)
            date = Date.dateFromString(dateString, format: "yyyy-MM-dd") ?? Date.errorDate()
            //debugPrint("CJDateModel ✅\(data)")
        } catch {
            debugPrint("❌CJDateModel解码失败:\(error)")
            date = Date.errorDate()
        }
 
        self.dateStringIsLunarType = try container.decodeIfPresent(Bool.self, forKey: .dateStringIsLunarType) ?? false
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(date, forKey: .date)
        try container.encodeIfPresent(dateStringIsLunarType, forKey: .dateStringIsLunarType)
    }
}

