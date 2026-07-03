//
//  BaseViewModel.swift
//  SwiftUIDemos
//
//  Created by qian on 2024/8/9.
//

import Foundation
import SwiftUI

public struct CJDatePickerRequest: Identifiable {
    public let id: UUID
    public let title: String
    public let date: Date
    public let dateStringIsLunarType: Bool
    public let isPickerSupportLunar: Bool
    public let onChangeOfDate: (Date) -> Void
    public let onChangeOfDateStringIsLunarType: (Bool) -> Void
    public let isValidateHandler: ((Date) -> (Bool, String))?

    public init(
        id: UUID,
        title: String,
        date: Date,
        dateStringIsLunarType: Bool,
        isPickerSupportLunar: Bool,
        onChangeOfDate: @escaping (Date) -> Void,
        onChangeOfDateStringIsLunarType: @escaping (Bool) -> Void,
        isValidateHandler: ((Date) -> (Bool, String))?
    ) {
        self.id = id
        self.title = title
        self.date = date
        self.dateStringIsLunarType = dateStringIsLunarType
        self.isPickerSupportLunar = isPickerSupportLunar
        self.onChangeOfDate = onChangeOfDate
        self.onChangeOfDateStringIsLunarType = onChangeOfDateStringIsLunarType
        self.isValidateHandler = isValidateHandler
    }
}

public enum CJSheetActionType {
    /// 显示actionSheet
    case actionSheet(id: UUID, sheet: AnyView)
    /// 移除actionSheet
    case removeActionSheet(id: UUID)
    /// 请求外部展示日期选择器
    case datePicker(CJDatePickerRequest)
}
