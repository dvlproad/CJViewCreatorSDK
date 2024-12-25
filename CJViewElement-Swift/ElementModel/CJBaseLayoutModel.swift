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
    public var lineLimit: Int
    public var fontSize: CGFloat
    public var fontWeight: FontWeight
    public var font: CJFontDataModel
    public var foregroundColor: String
    public var backgroundColor: String?
    public var textAlignment: CJTextAlignment
    public var multilineTextAlignment: CJTextAlignment
    public var minimumScaleFactor: CGFloat
    public var borderCornerRadius: CGFloat = 0
    
    public var overlay: CJBoxDecorationModel?       // 文字元素可以在上面盖渐变色视图，再mask下，从而形成看起来好像是渐变颜色的效果
    public var background: CJBoxDecorationModel
    
    // MARK: - Equatable
    public static func == (lhs: CJBaseLayoutModel, rhs: CJBaseLayoutModel) -> Bool {
        return lhs.left == rhs.left && lhs.top == rhs.top && lhs.width == rhs.width && lhs.height == rhs.height && lhs.lineLimit == rhs.lineLimit && lhs.fontSize == rhs.fontSize && lhs.font == rhs.font && lhs.fontWeight == rhs.fontWeight && lhs.foregroundColor == rhs.foregroundColor && lhs.backgroundColor == rhs.backgroundColor && lhs.overlay == rhs.overlay && lhs.background == rhs.background
    }
    
    // MARK: - Init
    required public init() {
        self.left = 0
        self.top = 0
        self.width = 0
        self.height = 0
        self.lineLimit = 0
        self.fontSize = 0
        self.fontWeight = .bold
        self.foregroundColor = "#000000"
        self.font = CJFontDataModel()
//        self.backgroundColor = "#FFFFFF"
        self.textAlignment = .leading
        self.multilineTextAlignment = .leading
        self.minimumScaleFactor = 0
        self.borderCornerRadius = 0
        
        self.background = CJBoxDecorationModel()
    }
    
    
    // 初始化
    init(left: CGFloat,
         top: CGFloat,
         width: CGFloat,
         height: CGFloat,
         lineLimit: Int,
         fontSize: CGFloat,
         fontWeight: FontWeight,
         font: CJFontDataModel,
         foregroundColor: String,
         backgroundColor: String,
         textAlignment: CJTextAlignment,
         multilineTextAlignment: CJTextAlignment,
         minimumScaleFactor: CGFloat,
         borderCornerRadius: CGFloat,
         background: CJBoxDecorationModel
    ) {
        self.left = left
        self.top = top
        self.width = width
        self.height = height
        self.lineLimit = lineLimit
        self.fontSize = fontSize
        self.fontWeight = fontWeight
        self.font = font
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
        self.textAlignment = textAlignment
        self.multilineTextAlignment = multilineTextAlignment
        self.minimumScaleFactor = minimumScaleFactor
        self.borderCornerRadius = borderCornerRadius
        self.background = background
    }
    
    
    // 自定义编码键
    enum CodingKeys: String, CodingKey {
        case left = "left" // JSON 中的 "left" 映射到类的 "x"
        case top, width, height, lineLimit
        case fontSize, fontWeight, font
        case foregroundColor, backgroundColor, overlay, background
        case textAlignment, multilineTextAlignment, minimumScaleFactor
        case borderCornerRadius
    }
    
    // 解码方法
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        left = try container.decodeCGFloatIfPresent(forKey: .left) ?? 0.0
        top = try container.decodeCGFloatIfPresent(forKey: .top) ?? 0.0
        width = try container.decodeCGFloatIfPresent(forKey: .width) ?? 0.0
        height = try container.decodeCGFloatIfPresent(forKey: .height) ?? 0.0
        lineLimit = try container.decodeIfPresent(Int.self, forKey: .lineLimit) ?? 1
        fontSize = try container.decodeCGFloatIfPresent(forKey: .fontSize) ?? 0.0
        fontWeight = try container.decodeIfPresent(FontWeight.self, forKey: .fontWeight) ?? .regular
        do {
            font = try container.decodeIfPresent(CJFontDataModel.self, forKey: .font) ?? CJFontDataModel()
        } catch {
            font = CJFontDataModel()
            debugPrint("Error:CJFontDataModel转化失败\(error)")
        }
        foregroundColor = try container.decodeIfPresent(String.self, forKey: .foregroundColor) ?? "#000000"
        backgroundColor = try container.decodeIfPresent(String.self, forKey: .backgroundColor)
        let _textAlignment = try container.decodeIfPresent(String.self, forKey: .textAlignment) ?? "leading"
        textAlignment = CJTextAlignment(rawValue: _textAlignment) ?? .leading
        let _multilineTextAlignment = try container.decodeIfPresent(String.self, forKey: .multilineTextAlignment) ?? "leading"
        multilineTextAlignment = CJTextAlignment(rawValue: _multilineTextAlignment) ?? .leading
        minimumScaleFactor = try container.decodeCGFloatIfPresent(forKey: .minimumScaleFactor) ?? 1.0
        borderCornerRadius = try container.decodeCGFloatIfPresent(forKey: .borderCornerRadius) ?? 0
        
        overlay = try container.decodeIfPresent(CJBoxDecorationModel.self, forKey: .overlay)
        background = try container.decodeIfPresent(CJBoxDecorationModel.self, forKey: .background) ?? CJBoxDecorationModel()
    }
    
    

    
    // 编码方法
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(left, forKey: .left)
        try container.encode(top, forKey: .top)
        try container.encode(width, forKey: .width)
        try container.encode(height, forKey: .height)
        try container.encode(lineLimit, forKey: .lineLimit)
        try container.encode(fontSize, forKey: .fontSize)
        try container.encode(fontWeight, forKey: .fontWeight)
        try container.encode(font, forKey: .font)
        try container.encode(foregroundColor, forKey: .foregroundColor)
        try container.encode(backgroundColor, forKey: .backgroundColor)
        try container.encode(textAlignment, forKey: .textAlignment)
        try container.encode(multilineTextAlignment, forKey: .multilineTextAlignment)
        try container.encode(minimumScaleFactor, forKey: .minimumScaleFactor)
        try container.encode(borderCornerRadius, forKey: .borderCornerRadius)
        
        try container.encode(overlay, forKey: .overlay)
        try container.encode(background, forKey: .background)
    }
    
    
}
