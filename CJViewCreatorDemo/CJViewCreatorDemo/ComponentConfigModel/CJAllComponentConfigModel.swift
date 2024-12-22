//
//  CJAllComponentConfigModel.swift
//  CJViewCreatorSDK
//
//  Created by qian on 2024/12/12.
//

import Foundation
import AppIntents
import WidgetKit
import CJViewElement_Swift

//// 定义类型擦除包装器
//struct AnyEquatableComponent: Equatable, CJBaseComponentConfigModelProtocol {
//    typealias DataType = <#type#>
//    
//    typealias LayoutType = <#type#>
//    
//    var componentType: CJComponentType
//    
//    private let _isEqual: (any CJBaseComponentConfigModelProtocol, any CJBaseComponentConfigModelProtocol) -> Bool
//    
//    init<T: CJBaseComponentConfigModelProtocol & Equatable>(_ component: T) {
//        // 保存比较逻辑
//        self._isEqual = { lhs, rhs in
//            guard let lhs = lhs as? T, let rhs = rhs as? T else { return false }
//            return lhs == rhs // 使用具体类型的 == 比较
//        }
//    }
//    
//    static func == (lhs: AnyEquatableComponent, rhs: AnyEquatableComponent) -> Bool {
//        return lhs._isEqual(lhs, rhs)
//    }
//}


class CJAllComponentConfigModel: CJBaseModel {
    var id: String = ""
    var components: [any CJBaseComponentConfigModelProtocol] = []
    
    // MARK: - Equatable
    static func == (lhs: CJAllComponentConfigModel, rhs: CJAllComponentConfigModel) -> Bool {
        guard lhs.id == rhs.id else { return false }
        
        guard lhs.components.count == rhs.components.count else { return false }
        for index in 0 ..< (lhs.components.count) {
            let lhsComponent = lhs.components[index]
            let rhsComponent = rhs.components[index]
            if lhsComponent.componentType != rhsComponent.componentType {
                return false
            }
//            if lhsComponent.data != rhsComponent.data {
//                return false
//            }
//            if lhsComponent.layout != rhsComponent.layout {
//                return false
//            }
            switch lhsComponent.componentType {
            case .normal_single_text:
                if (lhsComponent as? CJTextComponentConfigModel) != (rhsComponent as? CJTextComponentConfigModel) {
                    return false
                }
            case .commemoration:
                if (lhsComponent as? CJCommemorationComponentConfigModel) != (rhsComponent as? CJCommemorationComponentConfigModel) {
                    return false
                }
            case .background:
                if (lhsComponent as? CJBackgroundComponentConfigModel) != (rhsComponent as? CJBackgroundComponentConfigModel) {
                    return false
                }
            case .font:
                if (lhsComponent as? CJFontComponentConfigModel) != (rhsComponent as? CJFontComponentConfigModel) {
                    return false
                }
            case .textColor:
                if (lhsComponent as? CJTextColorComponentConfigModel) != (rhsComponent as? CJTextColorComponentConfigModel) {
                    return false
                }
            case .border:
                if (lhsComponent as? CJBorderComponentConfigModel) != (rhsComponent as? CJBorderComponentConfigModel) {
                    return false
                }
            case .unknown:
                if (lhsComponent as? CJUnknownComponentConfigModel) != (rhsComponent as? CJUnknownComponentConfigModel) {
                    return false
                }
            }
//            guard lhs.components[index] == rhs.components[index] else { return false }
        }
        return true
    }
    
    // MARK: - Init
    required init() {
        
    }
    
    
    static func getDefaultDataByLayoutId(_ layoutId: String) -> CJAllComponentConfigModel {
        //let jsonFileName: String = "countdown_middle_3_123_diffcom"
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
    
    
    // 组件包装器，使用 enum 来区分不同类型的组件
    enum ComponentWrapper: Codable {
        case text(CJTextComponentConfigModel)
        
        // 解码
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let textComponent = try? container.decode(CJTextComponentConfigModel.self) {
                self = .text(textComponent)
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unknown component type")
            }
        }
        
        // 编码
        func encode(to encoder: Encoder) throws {
            switch self {
            case .text(let textComponent):
                try textComponent.encode(to: encoder)
            }
        }
    }
    // MARK: 组件内部各工具分离提取
    /// 提取纪念日组件供纪念日工具条处理
    var commemorationComponents: [CJCommemorationComponentConfigModel] = []
    var singleTextComponents: [CJTextComponentConfigModel] = []
    var backgroundTextComponents: [CJBackgroundComponentConfigModel] = []
//    var fontTextComponents: [CJFontComponentConfigModel] = []
//    var textColorComponents: [CJTextColorComponentConfigModel] = []
    var existTextElement: Bool = false
    var borderComponents: [CJBorderComponentConfigModel] = []
    func spiltComponents(){
        commemorationComponents.removeAll()
        singleTextComponents.removeAll()
        backgroundTextComponents.removeAll()
//        fontTextComponents.removeAll()
//        textColorComponents.removeAll()
        borderComponents.removeAll()
        let components = self.components
        for index in 0 ..< (components.count) {
            let component = components[index]
            if component.componentType == .commemoration,
               let commemComponent = component as? CJCommemorationComponentConfigModel {
//                commemComponent.updateData(referDate: Date(), isForDesktop: false)
                commemorationComponents.append(commemComponent)
            } else if component.componentType == .normal_single_text,
                      let realComponent = component as? CJTextComponentConfigModel {
//                realComponent.updateData(referDate: Date(), isForDesktop: false)
                singleTextComponents.append(realComponent)
            } else if component.componentType == .background,
                      let realComponent = component as? CJBackgroundComponentConfigModel {
                backgroundTextComponents.append(realComponent)
//            } else if component.componentType == .font,
//                      let realComponent = component as? CJFontComponentConfigModel {
//                fontTextComponents.append(realComponent)
//            } else if component.componentType == .textColor,
//                      let realComponent = component as? CJTextColorComponentConfigModel {
//                textColorComponents.append(realComponent)
            } else if component.componentType == .border,
                      let realComponent = component as? CJBorderComponentConfigModel {
                borderComponents.append(realComponent)
            }
        }
        
        existTextElement = !commemorationComponents.isEmpty || !singleTextComponents.isEmpty
    }
    
    // MARK: 获取组件中所有独立组件中可用于显示的视图供预览图处理
    func getAllLayoutModels() -> [CJTextLayoutModel] {
        var models: [CJTextLayoutModel] = []
        let count = self.components.count
        for i in 0..<count {
            let component: any CJBaseComponentConfigModelProtocol = self.components[i]
            if component.componentType == .normal_single_text && component is CJTextComponentConfigModel {
                let textDateModel: CJTextComponentConfigModel = component as! CJTextComponentConfigModel
                let layoutModel = textDateModel.layout
                models.append(layoutModel)
            } else if component.componentType == .commemoration && component is CJCommemorationComponentConfigModel {
                let textDateModel: CJCommemorationComponentConfigModel = component as! CJCommemorationComponentConfigModel
                let layoutModel = textDateModel.layout
                models.append(layoutModel.titleLayoutModel)
                models.append(layoutModel.dateLayoutModel)
                models.append(layoutModel.countdownLayoutModel)
                models.append(layoutModel.dayUnitLayoutModel)
            }
        }
        return models
    }
    
    static func fromJson(_ jsonString: String) -> CJAllComponentConfigModel {
        guard let jsonData = jsonString.data(using: .utf8) else { return CJAllComponentConfigModel() }
        
        let decoder = JSONDecoder()
        do {
            // 尝试解码 JSON 数据
            let model = try decoder.decode(CJAllComponentConfigModel.self, from: jsonData)
//            let model: CJAllComponentConfigModel = CJAllComponentConfigModel.deserialize(from: jsonString) ?? CJAllComponentConfigModel()
            for index in 0 ..< (model.components.count) {
                let component = model.components[index]
                if component.componentType == .commemoration {
                    let component = component as? CJCommemorationComponentConfigModel
                    component?.updateData(referDate: Date(), isForDesktop: false)
                } else if component.componentType == .normal_single_text {
                    let component = component as? CJTextComponentConfigModel
                    component?.updateData(referDate: Date(), isForDesktop: false)
                }
            }
            
            model.spiltComponents()
            
            return model
            
        } catch {
            debugPrint("CJAllComponentConfigModel 解码失败:\(error)")
            return CJAllComponentConfigModel()
        }
    }
    
    // MARK: - Codable
    private enum CodingKeys: String, CodingKey {
        case id
        case components
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        
//        self.components = try container.decode([any CJBaseComponentConfigModelProtocol].self, forKey: .components)
        var componentsContainer = try container.nestedUnkeyedContainer(forKey: .components)
        var components: [any CJBaseComponentConfigModelProtocol] = []

//        var decodedComponents: [CJBaseModel] = []

//        var nestedComponents = try container.nestedUnkeyedContainer(forKey: .components)
//        while !nestedComponents.isAtEnd {
//            if let component = try? nestedComponents.decode(CJTextComponentConfigModel.self) {
//                components.append(component)
//            } else if let component = try? nestedComponents.decode(CJCommemorationComponentConfigModel.self) {
//                components.append(component)
//            } else {
//                throw DecodingError.dataCorruptedError(in: nestedComponents, debugDescription: "Unknown component type.")
//            }
//        }
        
        while !componentsContainer.isAtEnd {
            do {
                let tempContainer = try componentsContainer.nestedContainer(keyedBy: CJTextComponentConfigModel.CodingKeys.self)
                let id: String = try tempContainer.decode(String.self, forKey: .id)
                let type: CJComponentType = try tempContainer.decode(CJComponentType.self, forKey: .componentType)
                
                switch type {
                case .normal_single_text:
                    //let tempContainer = try componentsContainer.nestedContainer(keyedBy: CJTextComponentConfigModel.CodingKeys.self)
                    let data: CJTextDataModel = try tempContainer.decode(CJTextDataModel.self, forKey: .data)
                    let layout: CJTextLayoutModel = try tempContainer.decode(CJTextLayoutModel.self, forKey: .layout)
                    let component = CJTextComponentConfigModel(id: id, data: data, layout: layout)
                    components.append(component)
                case .commemoration:
                    //let tempContainer = try componentsContainer.nestedContainer(keyedBy: CJCommemorationComponentConfigModel.CodingKeys.self)
                    let data: CJCommemorationDataModel = try tempContainer.decode(CJCommemorationDataModel.self, forKey: .data)
                    let layout: CJCommemorationLayoutModel = try tempContainer.decode(CJCommemorationLayoutModel.self, forKey: .layout)
                    let component = CJCommemorationComponentConfigModel(id: id, componentType: type, data: data, layout: layout)
                    
                    components.append(component)
                case .background:
                    //let tempContainer = try componentsContainer.nestedContainer(keyedBy: CJBackgroundComponentConfigModel.CodingKeys.self)
                    let data: CJBackgroundDataModel = try tempContainer.decode(CJBackgroundDataModel.self, forKey: .data)
                    let layout: CJBackgroundLayoutModel = try tempContainer.decode(CJBackgroundLayoutModel.self, forKey: .layout)
                    let component = CJBackgroundComponentConfigModel(id: id, data: data, layout: layout)
                    components.append(component)
                case .font:
                    //let tempContainer = try componentsContainer.nestedContainer(keyedBy: CJBackgroundComponentConfigModel.CodingKeys.self)
                    let data: CJFontDataModel = try tempContainer.decode(CJFontDataModel.self, forKey: .data)
                    let layout: CJFontLayoutModel = try tempContainer.decode(CJFontLayoutModel.self, forKey: .layout)
                    let component = CJFontComponentConfigModel(id: id, data: data, layout: layout)
                    components.append(component)
                case .textColor:
                    //let tempContainer = try componentsContainer.nestedContainer(keyedBy: CJBackgroundComponentConfigModel.CodingKeys.self)
                    let data: CJTextColorDataModel = try tempContainer.decode(CJTextColorDataModel.self, forKey: .data)
                    let layout: CJTextColorLayoutModel = try tempContainer.decode(CJTextColorLayoutModel.self, forKey: .layout)
                    let component = CJTextColorComponentConfigModel(id: id, data: data, layout: layout)
                    components.append(component)
                case .border:
                    //let tempContainer = try componentsContainer.nestedContainer(keyedBy: CJBackgroundComponentConfigModel.CodingKeys.self)
                    let data: CJBorderDataModel = try tempContainer.decode(CJBorderDataModel.self, forKey: .data)
                    let layout: CJBorderLayoutModel = try tempContainer.decode(CJBorderLayoutModel.self, forKey: .layout)
                    let component = CJBorderComponentConfigModel(id: id, data: data, layout: layout)
                    components.append(component)
                case .unknown:
                    //let tempContainer = try componentsContainer.nestedContainer(keyedBy: CJTextComponentConfigModel.CodingKeys.self)
                    let data: CJTextDataModel = try tempContainer.decode(CJTextDataModel.self, forKey: .data)
                    let layout: CJTextLayoutModel = try tempContainer.decode(CJTextLayoutModel.self, forKey: .layout)
                    let component = CJTextComponentConfigModel(id: id, data: data, layout: layout)
                    components.append(component)
                }
                
                /*
                switch type {
                case .normal_single_text:
                    let component = try componentsContainer.decode(CJTextComponentConfigModel.self)
                    components.append(component)
                case .unknown:
                    let component = try componentsContainer.decode(CJTextComponentConfigModel.self)
                    components.append(component)
                case .commemoration:
                    let component = try componentsContainer.decode(CJCommemorationComponentConfigModel.self)
                    components.append(component)
                }
                */
            } catch {
                print("❌Error decoding component: \(error)")
            }
        }

        self.components = components
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)

        var componentsContainer = container.nestedUnkeyedContainer(forKey: .components)
        for component in components {
            do {
                switch component.componentType {
                case .normal_single_text:
                    try componentsContainer.encode(component as! CJTextComponentConfigModel)
                case .commemoration:
                    try componentsContainer.encode(component as! CJCommemorationComponentConfigModel)
                case .background:
                    try componentsContainer.encode(component as! CJBackgroundComponentConfigModel)
                case .font:
                    try componentsContainer.encode(component as! CJFontComponentConfigModel)
                case .textColor:
                    try componentsContainer.encode(component as! CJTextColorComponentConfigModel)
                case .border:
                    try componentsContainer.encode(component as! CJBorderComponentConfigModel)
                case .unknown:
                    try componentsContainer.encode(component as! CJUnknownComponentConfigModel)
                }
            } catch {
                print("Error encoding component: \(error)")
            }
        }
    }

    
}
