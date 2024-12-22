//
//  CQWidgetModel.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/9/21.
//
import SwiftUI
import WidgetKit
import CJViewElement_Swift

class CQWidgetModel {
    var anyComponentModel: CJAllComponentConfigModel = CJAllComponentConfigModel()
    var backgroundModel: CJBoxDecorationModel = CJBoxDecorationModel(colorModel: CJTextColorDataModel(solidColorString: "#F8AC9F"))
    var borderModel: CJBorderDataModel = CJBorderDataModel()
    
    init() {
        let layoutId = "countdown_middle_3_123_diffcom"
        self.anyComponentModel = CJAllComponentConfigModel.getDefaultDataByLayoutId(layoutId)
    }
    
    init(_ layoutId: String) {
        self.anyComponentModel = CJAllComponentConfigModel.getDefaultDataByLayoutId(layoutId)
    }
    
}
