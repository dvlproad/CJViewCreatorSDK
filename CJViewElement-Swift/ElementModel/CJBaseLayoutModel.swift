//
//  CJBaseLayoutModel.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/12/15.
//

import Foundation

public class CJBaseLayoutModel: CJBaseModel {
    public var left: CGFloat
    public var top: CGFloat
    public var width: CGFloat
    public var height: CGFloat
    public var backgroundColor: String?
    public var borderCornerRadius: CGFloat = 0
    
    public var background: CJBoxDecorationModel
    
    // MARK: - Equatable
    public static func == (lhs: CJBaseLayoutModel, rhs: CJBaseLayoutModel) -> Bool {
        return lhs.left == rhs.left && lhs.top == rhs.top && lhs.width == rhs.width && lhs.height == rhs.height && lhs.backgroundColor == rhs.backgroundColor && lhs.background == rhs.background && lhs.borderCornerRadius == rhs.borderCornerRadius
    }
    
    // MARK: - Init
    required public init() {
        self.left = 0
        self.top = 0
        self.width = 0
        self.height = 0
        self.background = CJBoxDecorationModel()
    }
    
    init(left: CGFloat,
         top: CGFloat,
         width: CGFloat,
         height: CGFloat,
         backgroundColor: String? = nil,
         borderCornerRadius: CGFloat = 0,
         background: CJBoxDecorationModel = CJBoxDecorationModel()
    ) {
        self.left = left
        self.top = top
        self.width = width
        self.height = height
        self.backgroundColor = backgroundColor
        self.borderCornerRadius = borderCornerRadius
        self.background = background
    }
    
    // MARK: - Copy
    func copy() -> Self {
        let copy = type(of: self).init()
        copy.left = left
        copy.top = top
        copy.width = width
        copy.height = height
        copy.backgroundColor = backgroundColor
        copy.borderCornerRadius = borderCornerRadius
        copy.background = background
        return copy
    }
    
    // MARK: - Codable
    enum CodingKeys: String, CodingKey {
        case left = "left" // JSON 中的 "left" 映射到类的 "x"
        case top, width, height
        case backgroundColor
        case background
        case borderCornerRadius
    }
    
    // 解码方法
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        left = try container.decodeCGFloatIfPresent(forKey: .left) ?? 0.0
        top = try container.decodeCGFloatIfPresent(forKey: .top) ?? 0.0
        width = try container.decodeCGFloatIfPresent(forKey: .width) ?? 0.0
        height = try container.decodeCGFloatIfPresent(forKey: .height) ?? 0.0
        backgroundColor = try container.decodeIfPresent(String.self, forKey: .backgroundColor)
        borderCornerRadius = try container.decodeCGFloatIfPresent(forKey: .borderCornerRadius) ?? 0
        background = try container.decodeIfPresent(CJBoxDecorationModel.self, forKey: .background) ?? CJBoxDecorationModel()
    }
    
    // 编码方法
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(left, forKey: .left)
        try container.encode(top, forKey: .top)
        try container.encode(width, forKey: .width)
        try container.encode(height, forKey: .height)
        try container.encode(backgroundColor, forKey: .backgroundColor)
        try container.encode(borderCornerRadius, forKey: .borderCornerRadius)
        try container.encode(background, forKey: .background)
    }
}
