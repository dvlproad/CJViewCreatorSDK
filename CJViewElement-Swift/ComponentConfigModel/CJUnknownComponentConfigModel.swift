//
//  CJUnknownComponentConfigModel.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/12/22.
//

import Foundation

// MARK: 组件完整类
public class CJUnknownComponentConfigModel: CJBaseComponentConfigModel<CJTextDataModel, CJTextLayoutModel> {
    required public init() {
        super.init()
    }
    
    public init(id: String, data: CJTextDataModel, layout: CJTextLayoutModel) {
        super.init(id: id, componentType: .unknown, data: data, layout: layout)
    }
    
    public func updateData(referDate: Date, isForDesktop: Bool = false) {
        self.layout.text = self.data.text
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
            data = try container.decode(CJTextDataModel.self, forKey: .data)
            //debugPrint("CJTextDataModel ✅\(data)")
        } catch {
            debugPrint("error:\(error)")
        }
        do {
            layout = try container.decode(CJTextLayoutModel.self, forKey: .layout)
            //debugPrint("CJTextLayoutModel ✅\(layout)")
        } catch {
            debugPrint("error:\(error)")
        }
    }
}


