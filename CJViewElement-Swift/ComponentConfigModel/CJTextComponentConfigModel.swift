//
//  CJTextComponentConfigModel.swift
//  CJViewCreatorSDK
//
//  Created by qian on 2024/12/15.
//

import Foundation

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


// MARK: 组件Layout布局类
public class CJTextLayoutModel: CJBaseLayoutModel {
    public var text: String = ""
    required public init() {
        super.init()
    }
    
    override public init(left: CGFloat,
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
        super.init(left: left, top: top, width: width, height: height, lineLimit: lineLimit, fontSize: fontSize, fontWeight: fontWeight, font: font, foregroundColor: foregroundColor, backgroundColor: backgroundColor, textAlignment: textAlignment, multilineTextAlignment: multilineTextAlignment, minimumScaleFactor: minimumScaleFactor, borderCornerRadius: borderCornerRadius, background: background)
        self.text = ""
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
            debugPrint("❌error:CJTextLayoutModel 解码失败 \(error)")
        }
    }
}



// MARK: 组件Data数据类
public class CJTextDataModel: CJBaseModel {
    public var text: String = ""
    
    // MARK: - Equatable
    public static func == (lhs: CJTextDataModel, rhs: CJTextDataModel) -> Bool {
        return lhs.text == rhs.text
    }
    
    // MARK: Init
    required public init() {
        
    }
    
    init(text: String) {
        self.text = text
    }
    
    // MARK: - Codable
    private enum CodingKeys: String, CodingKey {
        case text
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let text = try container.decodeIfPresent(String.self, forKey: .text) ?? "文本获取失败了"
        
        self.text = text
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(text, forKey: .text)
    }
}
