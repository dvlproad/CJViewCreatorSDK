//
//  CJFontComponentConfigModel.swift
//  CJViewCreatorSDK
//
//  Created by qian on 2024/12/13.
//

import Foundation

// MARK: 组件完整类
public class CJFontComponentConfigModel: CJBaseComponentConfigModel<CJFontDataModel, CJFontLayoutModel> {
    required public init() {
        super.init()
    }
    
    public init(id: String, data: CJFontDataModel, layout: CJFontLayoutModel) {
        super.init(id: id, componentType: .font, data: data, layout: layout)
    }
    
    public func updateData(referDate: Date, isForDesktop: Bool = false) {
        self.layout.text = self.data.name
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
            data = try container.decode(CJFontDataModel.self, forKey: .data)
            //debugPrint("CJTextDataModel ✅\(data)")
        } catch {
            debugPrint("error:\(error)")
        }
        do {
            layout = try container.decode(CJFontLayoutModel.self, forKey: .layout)
            //debugPrint("CJTextLayoutModel ✅\(layout)")
        } catch {
            debugPrint("error:\(error)")
        }
    }
}


// MARK: 组件Layout布局类
public class CJFontLayoutModel: CJBaseLayoutModel {
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
            debugPrint("❌Error:CJTextLayoutModel 解码失败 \(error)")
        }
    }
}