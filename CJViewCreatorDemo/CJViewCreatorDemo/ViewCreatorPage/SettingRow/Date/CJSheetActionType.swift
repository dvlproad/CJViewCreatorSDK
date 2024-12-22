//
//  BaseViewModel.swift
//  SwiftUIDemos
//
//  Created by qian on 2024/8/9.
//

import SwiftUI

enum CJSheetActionType {
    /// 显示actionSheet
    case actionSheet(id: UUID, sheet: AnyView)
    /// 移除actionSheet
    case removeActionSheet(id: UUID)
}
