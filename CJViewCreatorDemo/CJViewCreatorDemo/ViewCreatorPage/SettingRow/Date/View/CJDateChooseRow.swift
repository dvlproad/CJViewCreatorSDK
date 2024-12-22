//
//  CJDateChooseRow.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/12/22.
//

import Foundation
import SwiftUI
import CQDemoKit

struct CJDateChooseRow: View {
    //@Binding var shouldUpdateUI: Bool
    @EnvironmentObject var uiUpdateObserver: UIUpdateModel
    
    var title: String
    @Binding var date: Date
    @Binding var dateStringIsLunarType: Bool // 日期展示是否要用农历形式
    var dateFormaterHandle: ((Date) -> String)
    
    var isPickerSupportLunar: Bool          // 是否支持农历日期选择
    var onChangeOfDate: ((Date) -> ())
    var onChangeOfDateStringIsLunarType: ((_ isLunar: Bool) -> ())
    var isValidateHandler: ((Date) -> (Bool, String))?
    var actionClosure: ((CJSheetActionType) -> Void)
    
    @State var isPresentedDatePicker = false
    
    var body: some View {
        let dateString = dateFormaterHandle(date)
        //let dateString = String("\(date)")
        HStack {
            Text(title).foregroundColor(Color(hex: "#333333"))
                .font(.system(size: 15.5, weight: .medium))
            Spacer()
            Text(dateString).foregroundColor(Color(hex: "#666666"))
                .font(.system(size: 13.5, weight: .regular))
            
            Image(.arrowRight)
                .resizable()
                .frame(width: 6, height: 10.5)
            
        }
        .padding(.horizontal, 21)
        .contentShape(Rectangle())
        .frame(height: 42)
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            
            isPresentedDatePicker = true
            CJUIKitToastUtil.showMessage("请完善选择日期的弹窗操作")
        }
//        .withGlobalOverlay() // 添加全局的 DatePickerOverlay
    }
}

// MARK: - 预览 CJDateChooseRow
struct CJDateChooseRow_Previews: PreviewProvider {
    static var previews: some View {
        var commemorationDate = Date.getLatestSpecifiedDate(month: 1, day: 1)
        var dateStringIsLunarType = true
        
        CJDateChooseRow(title: "测试选择目标日", date: .constant(commemorationDate), dateStringIsLunarType: .constant(dateStringIsLunarType), dateFormaterHandle: { date in
//            var dateString: String = date.commemorationDateString(cycleType: .year, showInLunarType: true)
//            return dateString
            return Date.getYYMMDDDateString(date: date)
        }, isPickerSupportLunar: true, onChangeOfDate: { date in
            commemorationDate = date
        }, onChangeOfDateStringIsLunarType: { isLunar in
            dateStringIsLunarType = isLunar
        }, isValidateHandler: { date in
            return (true, "")
        }, actionClosure: { actionType in
            
        }).onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}
