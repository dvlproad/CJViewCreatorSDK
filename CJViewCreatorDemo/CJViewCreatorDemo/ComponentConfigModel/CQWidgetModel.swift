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
    var backgroundModel: CJBoxDecorationModel
    var borderModel: CJBorderDataModel
    
    convenience init() {
        let layoutId = "countdown_middle_3_123_children"
        self.init(layoutId)
    }
    
    init(_ layoutId: String) {
        self.anyComponentModel = CJAllComponentConfigModel.getDefaultDataByLayoutId(layoutId)
        self.backgroundModel = anyComponentModel.defaultBackground
        self.borderModel = anyComponentModel.defaultBorder
    }
}

extension CJAllComponentConfigModel {
    var defaultBackground: CJBoxDecorationModel {
        guard let firstBackgroundComponent = backgroundTextComponents.first else {
            return CJBoxDecorationModel(colorModel: CJTextColorDataModel(solidColorString: "#F8AC9F"))
        }
        
        if let backgroundColor = firstBackgroundComponent.layout.backgroundColor {
            return CJBoxDecorationModel(colorModel: CJTextColorDataModel(solidColorString: backgroundColor))
        }
        
        return firstBackgroundComponent.layout.background
    }
    
    var defaultBorder: CJBorderDataModel {
        guard let firstBorderComponent = borderComponents.first else {
            return TSRowDataUtil.backgroundBorderData().last!
        }
        
        return firstBorderComponent.data
    }
}
