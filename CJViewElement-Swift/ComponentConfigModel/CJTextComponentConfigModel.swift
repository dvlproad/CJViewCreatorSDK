//
//  CJTextComponentConfigModel.swift
//  CJViewCreatorSDK
//
//  Created by qian on 2024/12/15.
//

import Foundation

// MARK: 文本类型枚举
public enum CJTextType: String, CaseIterable, Codable {
    case title = "title"
    case date_yyyyMMdd = "date_yyyyMMdd"
    case date_countdown = "date_countdown"
    case date_unit = "date_unit"
}

// MARK: 组件完整类
public class CJTextComponentConfigModel: CJBaseComponentConfigModel<CJTextDataModel, CJTextLayoutModel> {
    required public init() {
        super.init()
    }
    
    public init(id: String, data: CJTextDataModel, layout: CJTextLayoutModel) {
        super.init(id: id, componentType: .normal_single_text, data: data, layout: layout)
    }
    
    public func updateData(referDate: Date, isForDesktop: Bool = false) {
        self.layout.text = self.data.text
    }
    
    // MARK: - Codable
    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        /*
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
        */
    }
}


// MARK: 组件Layout布局类
public class CJTextLayoutModel: CJBaseLayoutModel {
    public var text: String = ""
    public var lineLimit: Int = 1
    public var fontSize: CGFloat = 0
    public var fontWeight: FontWeight = .bold
    public var font: CJFontDataModel = CJFontDataModel()
    public var foregroundColor: String = "#000000"
    public var textAlignment: CJTextAlignment = .leading
    public var multilineTextAlignment: CJTextAlignment = .leading
    public var minimumScaleFactor: CGFloat = 0
    public var overlay: CJBoxDecorationModel?       // 文字元素可以在上面盖渐变色视图，再mask下，从而形成看起来好像是渐变颜色的效果
    
    required public init() {
        super.init()
    }
    
    public init(left: CGFloat,
                         top: CGFloat,
                         width: CGFloat,
                         height: CGFloat,
                         lineLimit: Int = 1,
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
        super.init(left: left, top: top, width: width, height: height, backgroundColor: backgroundColor, borderCornerRadius: borderCornerRadius, background: background)
        self.text = ""
        self.lineLimit = lineLimit
        self.fontSize = fontSize
        self.fontWeight = fontWeight
        self.font = font
        self.foregroundColor = foregroundColor
        self.textAlignment = textAlignment
        self.multilineTextAlignment = multilineTextAlignment
        self.minimumScaleFactor = minimumScaleFactor
    }
    
    // MARK: - Copy
    public override func copy() -> Self {
        let copy = super.copy() as! Self
        copy.text = text
        copy.lineLimit = lineLimit
        copy.fontSize = fontSize
        copy.fontWeight = fontWeight
        copy.font = font.copy()
        copy.foregroundColor = foregroundColor
        copy.textAlignment = textAlignment
        copy.multilineTextAlignment = multilineTextAlignment
        copy.minimumScaleFactor = minimumScaleFactor
        copy.overlay = overlay?.copy()
        return copy
    }
    
    public func textColorModel() -> CJTextColorDataModel {
        if let overlayColorModel = overlay?.colorModel {
            return overlayColorModel.copy()
        } else {
            return CJTextColorDataModel(solidColorString: foregroundColor)
        }
    }

    // MARK: - Codable
    private enum CodingKeys: String, CodingKey {
        case text
        case lineLimit, fontSize, fontWeight, font
        case foregroundColor, textAlignment, multilineTextAlignment
        case minimumScaleFactor, overlay
    }
    
    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            text = try container.decodeIfPresent(String.self, forKey: .text) ?? ""
            lineLimit = try container.decodeIfPresent(Int.self, forKey: .lineLimit) ?? 1
            fontSize = try container.decodeCGFloatIfPresent(forKey: .fontSize) ?? 0.0
            fontWeight = try container.decodeIfPresent(FontWeight.self, forKey: .fontWeight) ?? .regular
            font = try container.decodeIfPresent(CJFontDataModel.self, forKey: .font) ?? CJFontDataModel()
            foregroundColor = try container.decodeIfPresent(String.self, forKey: .foregroundColor) ?? "#000000"
            let _textAlignment = try container.decodeIfPresent(String.self, forKey: .textAlignment) ?? "leading"
            textAlignment = CJTextAlignment(rawValue: _textAlignment) ?? .leading
            let _multilineTextAlignment = try container.decodeIfPresent(String.self, forKey: .multilineTextAlignment) ?? "leading"
            multilineTextAlignment = CJTextAlignment(rawValue: _multilineTextAlignment) ?? .leading
            minimumScaleFactor = try container.decodeCGFloatIfPresent(forKey: .minimumScaleFactor) ?? 1.0
            overlay = try container.decodeIfPresent(CJBoxDecorationModel.self, forKey: .overlay)
        } catch {
            debugPrint("❌error:CJTextLayoutModel 解码失败 \(error)")
        }
    }
    
    public override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(text, forKey: .text)
        try container.encode(lineLimit, forKey: .lineLimit)
        try container.encode(fontSize, forKey: .fontSize)
        try container.encode(fontWeight, forKey: .fontWeight)
        try container.encode(font, forKey: .font)
        try container.encode(foregroundColor, forKey: .foregroundColor)
        try container.encode(textAlignment, forKey: .textAlignment)
        try container.encode(multilineTextAlignment, forKey: .multilineTextAlignment)
        try container.encode(minimumScaleFactor, forKey: .minimumScaleFactor)
        try container.encode(overlay, forKey: .overlay)
    }
}



// MARK: 组件Data数据类
public class CJTextDataModel: CJBaseModel {
    public var text: String = ""
    public var textType: CJTextType?
    
    // MARK: - Equatable
    public static func == (lhs: CJTextDataModel, rhs: CJTextDataModel) -> Bool {
        return lhs.text == rhs.text && lhs.textType == rhs.textType
    }
    
    // MARK: Init
    required public init() {
        
    }
    
    public init(text: String, textType: CJTextType? = nil) {
        self.text = text
        self.textType = textType
    }
    
    // MARK: - Codable
    private enum CodingKeys: String, CodingKey {
        case text
        case textType
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let text = try container.decodeIfPresent(String.self, forKey: .text) ?? "文本获取失败了"
        
        self.text = text
        self.textType = try container.decodeIfPresent(CJTextType.self, forKey: .textType)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(text, forKey: .text)
        try container.encodeIfPresent(textType, forKey: .textType)
    }
}
