//
//  CJBoxDecorationModel.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/12/17.
//

import SwiftUI

public class CJBoxDecorationModel: CJBaseModel {
    public var id: String
    public var colorModel: CJTextColorDataModel?   // 背景颜色
    public var imageModel: CJImageModel?           // 背景图片
    public var borderRadius: CGFloat?
    public var border: CJBorderModel?
    
    // MARK: - Equatable
    static public func == (lhs: CJBoxDecorationModel, rhs: CJBoxDecorationModel) -> Bool {
        return lhs.id == rhs.id && lhs.colorModel == rhs.colorModel && lhs.imageModel == rhs.imageModel && lhs.borderRadius == rhs.borderRadius && lhs.border == rhs.border
    }
    
    // MARK: - Init
    required public init() {
        self.id = ""
    }
    
    public init(id: String = "", colorModel: CJTextColorDataModel? = nil, imageModel: CJImageModel? = nil, borderRadius: CGFloat? = nil, border: CJBorderModel? = nil) {
        self.id = id
        self.colorModel = colorModel
        self.imageModel = imageModel
        self.borderRadius = borderRadius
        self.border = border
    }
    
    // MARK: - Codable
    enum CodingKeys: String, CodingKey {
        case id
        case colorModel
        case imageModel
        case borderRadius
        case border
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decodeIfPresent(String.self, forKey: .id) ?? ""
        let colorModel = try container.decodeIfPresent(CJTextColorDataModel.self, forKey: .colorModel) ?? nil
        let imageModel = try container.decodeIfPresent(CJImageModel.self, forKey: .imageModel) ?? nil
        let borderRadius = try container.decodeCGFloat(forKey: .borderRadius)
        let border = try container.decodeIfPresent(CJBorderModel.self, forKey: .border)
        
        self.id = id
        self.colorModel = colorModel
        self.imageModel = imageModel
        self.borderRadius = borderRadius
        self.border = border
        
        //self.init(id: id, componentType: componentType, data: data, layout: layout)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(colorModel, forKey: .colorModel)
        try container.encode(imageModel, forKey: .imageModel)
        try container.encode(borderRadius, forKey: .borderRadius)
        try container.encode(border, forKey: .border)
    }
    
    // MARK: - Getter
//    func getBackground() -> Background {
//        if let colorModel = colorModel {
//            return colorModel.linearGradientColor
//        } else if let imageModel = imageModel {
//            return imageModel.image
//        }
//        return .none
//    }
}



public class CJBorderModel: CJBaseModel {
    var color: String?          // 边框颜色
    var width: CGFloat?         // 边框图片
    
    // MARK: - Equatable
    public static func == (lhs: CJBorderModel, rhs: CJBorderModel) -> Bool {
        return lhs.color == rhs.color && lhs.width == rhs.width
    }
    
    // MARK: - Init
    required public init() {
        
    }
    
    init(color: String? = nil, width: CGFloat? = nil) {
        self.color = color
        self.width = width
    }
    
    // MARK: - Codable
    enum CodingKeys: String, CodingKey {
        case color
        case width
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let color = try container.decodeIfPresent(String.self, forKey: .color)
        let width = try container.decodeCGFloat(forKey: .width)
        
        self.color = color
        self.width = width
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(color, forKey: .color)
        try container.encode(width, forKey: .width)
    }
    
    // MARK: Getter
    func borderColor() -> Color? {
        var borderColor: Color?
        if color != nil && !color!.isEmpty {
            borderColor = Color(hex: color!)
        }
        return borderColor
    }
}

