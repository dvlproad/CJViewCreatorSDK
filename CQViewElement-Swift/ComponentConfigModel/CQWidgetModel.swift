//
//  CQWidgetModel.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/9/21.
//
import SwiftUI
import WidgetKit
import CJViewElement_Swift

public class CQWidgetModel {
    public var anyComponentModel: CJAllComponentConfigModel = CJAllComponentConfigModel()
    // 其他会员、广告等属性...
    
    public init(_ layoutId: String) {
        self.anyComponentModel = CQWidgetModel.getDefaultDataByLayoutId(layoutId)
    }
    
    static func getDefaultDataByLayoutId(_ layoutId: String) -> CJAllComponentConfigModel {
        //let jsonFileName: String = "countdown_middle_3_123_children"
        let jsonFileName = layoutId
        
        /*
        if let jsonString = TSRowDataUtil.loadJSONFromFile(jsonFileName: "ts_text_data_model") {
            do {
                let dataModel: CJTextDataModel = try JSONDecoder().decode(CJTextDataModel.self, from: jsonString.data)
                debugPrint("CJTextDataModel ✅\n\(dataModel)")
            } catch {
                debugPrint("CJTextDataModel error: \(error))")
            }
        }
        
        if let jsonString = TSRowDataUtil.loadJSONFromFile(jsonFileName: "ts_text_layout_model") {
            do {
                let layoutModel: CJTextLayoutModel = try JSONDecoder().decode(CJTextLayoutModel.self, from: jsonString.data)
                debugPrint("CJTextLayoutModel ✅\n\(layoutModel)")
            } catch {
                debugPrint("CJTextLayoutModel error: \(error)")
            }
        }
        */
        
        guard let jsonString = TSRowDataUtil.loadJSONFromFile(jsonFileName: jsonFileName) else { return CJAllComponentConfigModel() }
        let model: CJAllComponentConfigModel = CJAllComponentConfigModel.fromJson(jsonString)
  
        return model
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
