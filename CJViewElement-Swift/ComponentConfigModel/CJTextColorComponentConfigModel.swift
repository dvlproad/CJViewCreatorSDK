//
//  CJTextColorComponentConfigModel.swift
//  CJViewCreatorSDK
//
//  Created by qian on 2024/12/15.
//

import Foundation

// MARK: 组件完整类
public class CJTextColorComponentConfigModel: CJBaseComponentConfigModel<CJTextColorDataModel, CJTextColorLayoutModel> {
    required public init() {
        super.init()
    }
    
    public init(id: String, data: CJTextColorDataModel, layout: CJTextColorLayoutModel) {
        super.init(id: id, componentType: .textColor, data: data, layout: layout)
    }
    
    public func updateData(referDate: Date, isForDesktop: Bool = false) {
//        self.layout.text = self.data.text
    }
    
    // MARK: - Codable
    enum CodingKeys: String, CodingKey {
        case id
        case componentType
        case data
        case layout
    }
    
    required public init(from decoder: Decoder) throws {
//        try super.init(from: decoder)
        super.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        componentType = try container.decode(CJComponentType.self, forKey: .componentType)
        
        do {
            data = try container.decode(CJTextColorDataModel.self, forKey: .data)
            //debugPrint("CJTextDataModel ✅\(data)")
        } catch {
            debugPrint("error:\(error)")
        }
        do {
            layout = try container.decode(CJTextColorLayoutModel.self, forKey: .layout)
            //debugPrint("CJTextLayoutModel ✅\(layout)")
        } catch {
            debugPrint("error:\(error)")
        }
    }
}


// MARK: 组件Layout布局类
public class CJTextColorLayoutModel: CJBaseLayoutModel {
    var text: String = ""
    required public init() {
        super.init()
    }
    
    // MARK: - Codable
    private enum CodingKeys: String, CodingKey {
        case text
    }
    
    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            text = try container.decodeIfPresent(String.self, forKey: .text) ?? ""
        } catch {
            debugPrint("error:CJTextLayoutModel 解码失败 \(error)")
        }
    }
}

