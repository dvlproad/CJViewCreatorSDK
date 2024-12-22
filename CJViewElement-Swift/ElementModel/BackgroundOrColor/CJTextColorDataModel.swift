//
//  CJTextColorDataModel.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/12/17.
//
//  颜色（文字颜色、背景颜色）

import Foundation
import SwiftUI

public enum CJUnitPoint: String, Codable {
    case top
    case bottom
    case topLeading
    case bottomTrailing
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        self = CJUnitPoint(rawValue: value) ?? .top
    }
    
    public var toUnitPointt: UnitPoint {
        switch self {
        case .top:
            return .top
        case .bottom:
            return .bottom
        case .topLeading:
            return .topLeading
        case .bottomTrailing:
            return .bottomTrailing
        }
    }
}


// MARK: 组件Data数据类
public class CJTextColorDataModel: CJBaseModel, Equatable {
    public var id: String
    public var startPoint: CJUnitPoint = .top
    public var endPoint: CJUnitPoint = .bottom
    public var colorStrings: [String] = []
  
    var index:Int = -1
    
    // MARK: - Equatable
    public static func == (lhs: CJTextColorDataModel, rhs: CJTextColorDataModel) -> Bool {
        return lhs.id == rhs.id && lhs.startPoint == rhs.startPoint && lhs.endPoint == rhs.endPoint && lhs.colorStrings.joined(separator: ",") == rhs.colorStrings.joined(separator: ",")
    }
    
    // MARK: Init
    required public init() {
        id = ""
    }
    
    /// 只有一个颜色，是实体
    convenience public init(id: String = "", solidColorString: String) {
        self.init(id: id, startPoint: .top, endPoint: .bottom, colorStrings: [solidColorString, solidColorString])
        self.id = id
    }
    
    convenience public init(id: String = "", topColorString: String, bottomColorString: String) {
        self.init(id: id, startPoint: .top, endPoint: .bottom, colorStrings: [topColorString, bottomColorString])
        self.id = id
    }
    convenience public init(id: String = "", topLeadingColorString: String, bottomTrailingColorString: String) {
        self.init(id: id, startPoint: .topLeading, endPoint: .bottomTrailing, colorStrings: [topLeadingColorString, bottomTrailingColorString])
        self.id = id
    }
    
    /// 基础方法（可渐变色，颜色一致即为实体颜色）
    convenience public init(id: String = "", startPoint: CJUnitPoint, endPoint: CJUnitPoint, colorStrings: [String]) {
        self.init()
        self.id = id.isEmpty ? colorStrings.joined(separator: ",") : id
        self.startPoint = startPoint
        self.endPoint = endPoint
        self.colorStrings = colorStrings
        self.index = index
    }
    
    // MARK: - Codable
    private enum CodingKeys: String, CodingKey {
        case id
        case startPoint
        case endPoint
        case colorStrings
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id) ?? ""
        
        startPoint = try container.decodeIfPresent(CJUnitPoint.self, forKey: .startPoint) ?? .top
        endPoint = try container.decodeIfPresent(CJUnitPoint.self, forKey: .endPoint) ?? .bottom
        
        colorStrings = try container.decodeIfPresent([String].self, forKey: .colorStrings) ?? []
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(startPoint.rawValue, forKey: .startPoint)
        try container.encode(endPoint.rawValue, forKey: .endPoint)
        try container.encode(colorStrings, forKey: .colorStrings)
    }
    
    // MARK: - Getter
    public var linearGradientColor: LinearGradient {
        var colors:[Color] = []
        for colorString in colorStrings {
            colors.append(Color(hex: colorString))
        }
        
        return LinearGradient(gradient: Gradient(colors: colors),
                              startPoint: startPoint.toUnitPointt,
                              endPoint: endPoint.toUnitPointt)
    }
}

