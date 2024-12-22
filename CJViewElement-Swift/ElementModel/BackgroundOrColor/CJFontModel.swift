//
//  CJFontModel.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/12/19.
//

import Foundation
import SwiftUI

// MARK: 组件Data数据类
public class CJFontDataModel: CJBaseModel {
    public var id: String = ""
    public var name: String = ""
    public var egImage: String = ""    // 字体的图片示例
    
    // MARK: - Equatable
    static public func == (lhs: CJFontDataModel, rhs: CJFontDataModel) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.egImage == rhs.egImage
    }
    
    // MARK: Init
    required public init() {
        
    }
    
    public init(id: String = "", name: String, egImage: String) {
        self.id = id.isEmpty ? name : id
        self.name = name
        self.egImage = egImage
    }
    
    // MARK: - Codable
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case egImage
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id) ?? "文本获取失败了"
        let name = try container.decodeIfPresent(String.self, forKey: .name) ?? "文本获取失败了"
        let egImage = try container.decodeIfPresent(String.self, forKey: .egImage) ?? "文本获取失败了"
        self.name = name
        self.egImage = egImage
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(egImage, forKey: .egImage)
    }
}



public enum FontWeight: String, Codable {
    case bold
    case regular
    case light
    case medium
    case unknown
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        self = FontWeight(rawValue: value) ?? .unknown
    }
    
    public var toFontWeight: Font.Weight {
        switch self {
        case .regular:
            return .regular
        case .bold:
            return .bold
        case .medium:
            return .medium
        case .light:
            return .light
        case .unknown:
            return .regular
        }
    }
}

public enum CJTextAlignment: String, Codable {
    case leading
    case center
    case trailing
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        self = CJTextAlignment(rawValue: value) ?? .leading
    }
    
    public var toAlignment: Alignment {
        switch self {
        case .leading:
            return .leading
        case .center:
            return .center
        case .trailing:
            return .trailing
        }
    }

}
