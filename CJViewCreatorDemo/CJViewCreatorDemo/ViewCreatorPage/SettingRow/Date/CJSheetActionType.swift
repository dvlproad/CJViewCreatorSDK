//
//  BaseViewModel.swift
//  SwiftUIDemos
//
//  Created by qian on 2024/8/9.
//

import Foundation
import SwiftUI

struct CJDatePickerRequest: Identifiable {
    let id: UUID
    let title: String
    let date: Date
    let dateStringIsLunarType: Bool
    let isPickerSupportLunar: Bool
    let onChangeOfDate: (Date) -> Void
    let onChangeOfDateStringIsLunarType: (Bool) -> Void
    let isValidateHandler: ((Date) -> (Bool, String))?
}

enum CJSheetActionType {
    /// 显示actionSheet
    case actionSheet(id: UUID, sheet: AnyView)
    /// 移除actionSheet
    case removeActionSheet(id: UUID)
    /// 请求外部展示日期选择器
    case datePicker(CJDatePickerRequest)
}
