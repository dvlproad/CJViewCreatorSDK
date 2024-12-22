//
//  CJBorderComponentConfigModel.swift
//  CJViewCreatorSDK
//
//  Created by qian on 2024/12/13.
//

import Foundation

// MARK: 组件完整类
public class CJBorderComponentConfigModel: CJBaseComponentConfigModel<CJBorderDataModel, CJBorderLayoutModel> {
    required init() {
        super.init()
    }
    
    public init(id: String, data: CJBorderDataModel, layout: CJBorderLayoutModel) {
        super.init(id: id, componentType: .border, data: data, layout: layout)
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
            data = try container.decode(CJBorderDataModel.self, forKey: .data)
            //debugPrint("CJTextDataModel ✅\(data)")
        } catch {
            debugPrint("error:\(error)")
        }
        do {
            layout = try container.decode(CJBorderLayoutModel.self, forKey: .layout)
            //debugPrint("CJTextLayoutModel ✅\(layout)")
        } catch {
            debugPrint("error:\(error)")
        }
    }
}


// MARK: 组件Layout布局类
public class CJBorderLayoutModel: CJBaseLayoutModel {
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



// MARK: 组件Data数据类
public class CJBorderDataModel: CJBaseModel {
    public var id: String
    public var imageName: String
    
    // MARK: - Equatable
    public static func == (lhs: CJBorderDataModel, rhs: CJBorderDataModel) -> Bool {
        return lhs.id == rhs.id && lhs.imageName == rhs.imageName
    }
    
    // MARK: Init
    required public init() {
        self.id = "9999"
        self.imageName = ""
    }
    
    public init(id: String = "", imageName: String) {
        self.id = id.isEmpty ? imageName : id
        self.imageName = imageName
    }
    
    // MARK: - Codable
    private enum CodingKeys: String, CodingKey {
        case id
        case imageName
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id) ?? "id获取失败了"
        imageName = try container.decodeIfPresent(String.self, forKey: .imageName) ?? "id获取失败了"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(imageName, forKey: .imageName)
    }
}
