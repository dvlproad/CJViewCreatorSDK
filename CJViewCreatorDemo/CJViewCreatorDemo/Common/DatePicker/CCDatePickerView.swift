//
//  CCDatePickerView.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/12/4.
//
//  修复 LunarDatePickerView 、 CustomDatePickerView
//  农历2025年腊月没有三十号、农历2025有闰六月，从2025年滑到2024年

import Foundation
import SwiftUI
import SnapKit
import CJViewElement_Swift

struct CCDatePickerSwiftUIView: UIViewRepresentable {
    @Binding var selectedDate: Date
    @Binding var isLunarDate: Bool
    var cancelClourse: (() -> Void)?
    var onValueChangeOfDate: ((_ date: Date) -> Void)
    var doneClourse: ((_ selectedDate: Date) -> Void)?
    
    func makeUIView(context: Context) -> CCDatePickerView {
        let pickerView = CCDatePickerView(frame: CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: 311)))
        pickerView.cancelClourse = cancelClourse
        pickerView.doneClourse = doneClourse
        pickerView.onValueChangeOfDate = onValueChangeOfDate
        return pickerView
    }
    
    func updateUIView(_ uiView: CCDatePickerView, context: Context) {
        uiView.updateData(isLunarCalendar: isLunarDate, selectedDate: selectedDate)
        uiView.reloadAllComponents()
    }
}


class CCDatePickerView: UIView {
    private var yearSelectIndex: Int = 0
    private var monthselectIndex: Int = 0
    private var daySelectIndex: Int = 0
    var selectDate: Date = Date()
    var isLunarDate: Bool = false
    var cancelClourse: (() -> Void)?
    var onValueChangeOfDate: ((_ date: Date) -> Void) = { _ in }
    var doneClourse: ((_ selectedDate: Date) -> Void)?
    
    lazy var years: [Int] = {
        return (1901...2100).map { $0 }
    }()
    var months: [String] = []
    var days: [String] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
        self.layout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupViews()
        self.layout()
    }
    
    
    func updateData(isLunarCalendar: Bool, selectedDate: Date) {
        self.isLunarDate = isLunarCalendar
        self.selectDate = selectedDate
        if isLunarCalendar {
            let lunarTuple = selectDate.lunarTuple()
            let year = lunarTuple.lunarYear
            let month = lunarTuple.monthString
            let day = lunarTuple.dayString
            
            self.yearSelectIndex = years.firstIndex(where: { item in
                item == year
            }) ?? 122
            self.months = _getMonthStrings(isLunarDate: isLunarCalendar, years:years, yearSelectIndex: self.yearSelectIndex)
            self.monthselectIndex = self.months.firstIndex(of: month) ?? 2
            self.days = _getDays(isLunarDate: isLunarCalendar, years:years, yearSelectIndex: self.yearSelectIndex, months: self.months, monthselectIndex: self.monthselectIndex)
            self.daySelectIndex = self.days.firstIndex(of: day) ?? 20
        } else {
            let components = Calendar.current.dateComponents([.year, .month ,.day], from: selectDate)
            self.yearSelectIndex = min((components.year ?? 2023) - 1901, 199)
            self.months = _getMonthStrings(isLunarDate: isLunarCalendar, years:years, yearSelectIndex: self.yearSelectIndex)
            self.monthselectIndex = min((components.month ?? 3) - 1, 11)
            self.days = _getDays(isLunarDate: isLunarCalendar, years:years, yearSelectIndex: self.yearSelectIndex, months: self.months, monthselectIndex: self.monthselectIndex)
            self.daySelectIndex = (components.day ?? 29) - 1
        }
        
        self.updateTitle(isLunarCalendar: isLunarCalendar, selectedDate: selectedDate)
    }
    
    private func updateTitle(isLunarCalendar: Bool, selectedDate: Date) {
        var fullDateString: String
        if isLunarCalendar {
            fullDateString = Date.lunarDateString(now: selectedDate)
        } else {
            let components = Calendar.current.dateComponents([.year, .month ,.day], from: selectedDate)
            fullDateString = "\((components.year ?? 2023))年\(components.month ?? 3)月\(components.day ?? 29)日"
        }
        
        let weekDay = selectedDate.weekdayString(type: 1)
        fullDateString = "\(fullDateString) \(weekDay)"
        
        titleLabel.text = fullDateString
    }
    
    func reloadAllComponents() {
        // 数据发生变化，请一定要先 reloadComponent — 更新组件的数据。然后 selectRow — 更新选中的行。
        pickerView.reloadAllComponents()
        pickerView.selectRow(yearSelectIndex, inComponent: 0, animated: false)
        pickerView.selectRow(monthselectIndex, inComponent: 1, animated: false)
        pickerView.selectRow(daySelectIndex, inComponent: 2, animated: false)
    }
    
    func _getMonthStrings(isLunarDate: Bool, years: [Int], yearSelectIndex: Int) -> [String] {
        if isLunarDate {
            let year = years[yearSelectIndex]
            let leapMonthNumber = LunarToSolar.lunarLeapMonth(of: year)
            return Date.getLunarMonthStringsInSpicialYear(year: year, leapMonthNumber: leapMonthNumber)
        }
        return (1...12).map { "\($0)" }
    }
    
    
    func _getDays(isLunarDate: Bool, years: [Int], yearSelectIndex: Int, months: [String], monthselectIndex: Int) -> [String] {
        let year = years[yearSelectIndex]
        let month = months[monthselectIndex]
        
        return Date.getDayStringsInSpicialYearAndMonth(inLunarCalendar: isLunarDate, year: year, monthNumberString: month)
    }


    /// 初始化
    private func setupViews() {
        self.addSubview(cancelButton)
        self.addSubview(confirmButton)
        self.addSubview(pickerView)
        self.addSubview(titleLabel)
        cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(doneAction), for: .touchUpInside)
        
//        setupSelectedDate()
//        pickerView.reloadAllComponents()
    }


    @objc private func cancelAction() {
        self.cancelClourse?()
    }
    
    @objc private func doneAction() {
        self.doneClourse?(self.selectDate)
    }
    
    private func layout() {
        self.cancelButton.snp.makeConstraints { (maker) in
            maker.left.top.equalToSuperview()
            maker.width.equalTo(93)
            maker.height.equalTo(72)
        }

        self.confirmButton.snp.makeConstraints { (maker) in
            maker.right.top.equalToSuperview()
            maker.width.equalTo(93)
            maker.height.equalTo(72)
        }

        self.pickerView.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalToSuperview()
            maker.top.equalToSuperview().offset(113)
            maker.bottom.equalToSuperview().offset(-28)
        }
        
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.top.equalToSuperview().offset(78)
        }
    }
    
    // MARK: Lazy
    lazy var pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        return picker
    }()
    
    /// 取消按钮
    private var cancelButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("取消", for: .normal)
        btn.setTitleColor(UIColor(hex: "#333333", alpha: 1), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return btn
    }()

    /// 确定按钮
    private var confirmButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("确定", for: .normal)
        btn.setTitleColor(UIColor(hex: "#FE4E38", alpha: 1), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return btn
    }()
    
    /// 日期显示
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "#333333", alpha: 1)
        label.font = UIFont(name: "PingFangSC-Regular", size: 16)
        label.textAlignment = .center
        return label
    }()

}

extension CCDatePickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return (UIScreen.main.bounds.width - 35) / 3
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 33.0
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return years.count
        case 1:
            return months.count
        case 2:
            return days.count
        default:
            return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = (view as? UILabel) ?? UILabel()
        label.font = UIFont(name: "PingFangSC-Regular", size: 17)
        label.textColor = UIColor(hex: "#333333")
        label.textAlignment = .center
        label.text = ""
        
        
        var isSelectedRow: Bool = false
        var showText: String = ""
        switch component {
        case 0:
            isSelectedRow = row == yearSelectIndex
            if isLunarDate && row == yearSelectIndex {
                showText = Date.lunarDateString(now: selectDate, justYear: true)
            } else {
                showText = "\(years[row])年"
            }
        case 1:
            isSelectedRow = row == monthselectIndex
            showText = "\(months[row])月"
            
        case 2:
            isSelectedRow = row == daySelectIndex
            showText = "\(days[row])"
            
        default:
            break
        }
        
        label.font = UIFont(name: "PingFangSC-Regular", size: isSelectedRow ? 21 : 17)
        label.text = showText
        
        return label
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            yearSelectIndex = min(row, 199)
        } else if component == 1 {
            monthselectIndex = row
        } else {
            daySelectIndex = row
        }
        
        let year = years[yearSelectIndex]
        // 选完后重定位月
        var month = months[monthselectIndex]
        if isLunarDate {
            let leapMonthNumber = LunarToSolar.lunarLeapMonth(of: year)
            let newYearMonths = Date.getLunarMonthStringsInSpicialYear(year: year, leapMonthNumber: leapMonthNumber)
            self.months = newYearMonths
            let lunarMonthTuple = Date.relocationLunarMonthInNewYear(targetLunarMonthString: month, newLunarMonthStrings: newYearMonths)
            if lunarMonthTuple != nil {
                self.monthselectIndex = lunarMonthTuple!.monthIndex
                month = lunarMonthTuple!.monthString
            }
        }
        // 选完后新日期后,计算新日期年月下所在的日期天数，如果31号换月或换年后没有了应设为该月最后一天
        let newMonthDays = Date.getDayStringsInSpicialYearAndMonth(inLunarCalendar: isLunarDate, year: year, monthNumberString: month)
        self.days = newMonthDays
        self.daySelectIndex = min(daySelectIndex, newMonthDays.count - 1)
        let day = days[daySelectIndex]
        
        self.selectDate = Date.fromYearNumber_monthNumberString_dayString(inLunarCalendar: isLunarDate, year: year, monthNumberString: month, dayFullString: day) ?? Date.errorDate()
        self.updateTitle(isLunarCalendar: self.isLunarDate, selectedDate: self.selectDate)
        
        
        self.onValueChangeOfDate(selectDate)
        
        
        if component == 0 {
            pickerView.reloadComponent(1) // 只有执行 reload 了该component的count才会更新为该年应有的月份
            pickerView.reloadComponent(2)
            pickerView.selectRow(monthselectIndex, inComponent: 1, animated: false)
            pickerView.selectRow(daySelectIndex, inComponent: 2, animated: false)

        } else if component == 1 {
            pickerView.reloadComponent(2)
            pickerView.selectRow(self.daySelectIndex, inComponent: 2, animated: false)
            
        } else {
            
        }
    }
}

