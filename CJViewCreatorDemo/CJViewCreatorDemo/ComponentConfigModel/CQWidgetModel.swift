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
    // 其他会员、广告等属性...
    
    convenience init() {
        let layoutId = "countdown_middle_3_123_children"
        self.init(layoutId)
    }
    
    init(_ layoutId: String) {
        self.anyComponentModel = CJAllComponentConfigModel.getDefaultDataByLayoutId(layoutId)
    }
}

extension CJAllComponentConfigModel {
    var backgroundModel: CJBoxDecorationModel {
        get {
            guard let firstBackgroundComponent = backgroundTextComponents.first else {
                return CJBoxDecorationModel(colorModel: CJTextColorDataModel(solidColorString: "#F8AC9F"))
            }
            
            if let backgroundColor = firstBackgroundComponent.layout.backgroundColor {
                return CJBoxDecorationModel(colorModel: CJTextColorDataModel(solidColorString: backgroundColor))
            }
            
            return firstBackgroundComponent.layout.background
        }
        set {
            if backgroundTextComponents.isEmpty {
                // 如果为空，需要创建一个新的 component
                let newComponent = CJBackgroundComponentConfigModel()
                newComponent.layout.background = newValue
                backgroundTextComponents = [newComponent]
            } else {
                // 更新第一个 component 的 background
                backgroundTextComponents[0].layout.background = newValue
                // 同时清空 backgroundColor，避免优先级问题
                backgroundTextComponents[0].layout.backgroundColor = nil
            }
        }
    }
    
    var borderModel: CJBorderDataModel {
        get {
            guard let firstBorderComponent = borderComponents.first else {
                return TSRowDataUtil.backgroundBorderData().last!
            }
            
            return firstBorderComponent.data
        }
        set {
            if borderComponents.isEmpty {
                let newComponent = CJBorderComponentConfigModel()
                newComponent.data = newValue
                borderComponents = [newComponent]
            } else {
                borderComponents[0].data = newValue
            }
        }
    }
}
