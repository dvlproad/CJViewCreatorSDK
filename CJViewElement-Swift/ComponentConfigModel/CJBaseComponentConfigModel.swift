//
//  CJBaseComponentConfigModel.swift
//  CJViewCreatorSDK
//
//  Created by qian on 2024/12/15.
//
import SwiftUI

public enum CJComponentType: String, Codable {
    case unknown            // 未知
    case commemoration      // 纪念日
    case normal_single_text // 单行文本
    case background         // 背景颜色
    case font               // 字体
    case textColor          // 字体颜色
    case border             // 边框
}


public protocol CJBaseComponentConfigModelProtocol: CJBaseModel {
    associatedtype DataType: CJBaseModel
    associatedtype LayoutType: CJBaseModel
    
    var componentType: CJComponentType { get set }
    var data: DataType { get set }
    var layout: LayoutType { get set }
    
//    func updateData(referDate: Date, isForDesktop: Bool)
}

open class CJBaseComponentConfigModel<DataType: CJBaseModel, LayoutType: CJBaseModel> : CJBaseComponentConfigModelProtocol {
//    func updateData(referDate: Date, isForDesktop: Bool = false) {
//        
//    }
    
//    var id: String = ""
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
    
    public var id: String = ""
    public var componentType: CJComponentType = .unknown
    public var data: DataType
    public var layout: LayoutType
//    var overlay: CJBoxDecorationModel?       // 文字元素可以在上面盖渐变色视图，再mask下，从而形成看起来好像是渐变颜色的效果
//    var background: CJBoxDecorationModel?
    
    // MARK: - Equatable
    public static func == (lhs: CJBaseComponentConfigModel, rhs: CJBaseComponentConfigModel) -> Bool {
        return lhs.id == rhs.id && lhs.componentType == rhs.componentType && lhs.data == rhs.data && lhs.layout == rhs.layout
    }
    
    // MARK: - Init
    required public init() {
//        fatalError("Subclasses must implement required init()")
        self.layout = LayoutType()
        self.data = DataType()
    }
    
    
    public init(id: String, componentType: CJComponentType, data: DataType, layout: LayoutType) {
        self.id = id
        self.componentType = componentType
        self.data = data
        self.layout = layout
    }
    
    // MARK: - Codable
    public enum CodingKeys: String, CodingKey {
        case id
        case componentType
        case data
        case layout
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(String.self, forKey: .id)
        let componentType = try container.decode(CJComponentType.self, forKey: .componentType)
        let data = try container.decode(DataType.self, forKey: .data)
        let layout = try container.decode(LayoutType.self, forKey: .layout)
        
        self.id = id
        self.componentType = componentType
        self.data = data
        self.layout = layout
        //self.init(id: id, componentType: componentType, data: data, layout: layout)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(componentType, forKey: .componentType)
        try container.encodeIfPresent(data, forKey: .data)
        try container.encodeIfPresent(layout, forKey: .layout)
    }
}

// 🚑 overlay > background > border > cornerRadius > position
// 🚑1、不能在 overlay 之前设置 background , 否则会多一层背景色
// 🚑2、不能在 background 之前设置 position , 否则背景颜色位置不准
// 🚑3、cornerRadius 必须在 background 之后，否则圆角无效
// 🚑4、cornerRadius 必须放在 border 之后, 否则圆角失效了
// 🚑5、不能在 overlay 之前设置 position , 否则位置不准
public extension View {
    public func background(backgroundColor: Color, background: CJBoxDecorationModel) -> some View {
        //🚑:当 SwiftUI 中的视图设置了 cornerRadius 并且同时设置了边框（border），有时会导致圆角的四个角显示出缺口。原因是 border 会遵循视图的边框，而 cornerRadius 仅作用于视图本身，但不会自动适配到边框的内缩区域。
//        return self.frame(width: layout.width, height: layout.height, alignment: layout.textAlignment.toAlignment)
//            .foregroundColor(foregroundColor)
//            .background(backgroundColor)
//            .border(layout.background.border?.borderColor() != nil  ? layout.background.border!.borderColor()! : Color.clear, width: layout.background.border?.width ?? 0)
//            .cornerRadius(layout.background.borderRadius ?? 0)
//            .position(x: layout.left + layout.width / 2, y: layout.top + layout.height / 2)
        return self
            .background(
                    RoundedRectangle(cornerRadius: background.borderRadius ?? 0)
                        .fill(backgroundColor)
                        .overlay(
                            RoundedRectangle(cornerRadius: background.borderRadius ?? 0)
                                .stroke(background.border?.borderColor() ?? Color.clear, lineWidth: background.border?.width ?? 0)
                        )
                )
    }
    
    public func layout(_ layout: CJBaseLayoutModel) -> some View {
        var foregroundColor: Color = Color(hex: layout.foregroundColor)
        var backgroundColor: Color = Color.clear
        if layout.backgroundColor != nil && !layout.backgroundColor!.isEmpty {
            backgroundColor = Color(hex: layout.backgroundColor!)
        }
        
        let backgroundImage: UIImage? = layout.background.imageModel?.image
        
        
        //🚑:当 SwiftUI 中的视图设置了 cornerRadius 并且同时设置了边框（border），有时会导致圆角的四个角显示出缺口。原因是 border 会遵循视图的边框，而 cornerRadius 仅作用于视图本身，但不会自动适配到边框的内缩区域。
//        return self.frame(width: layout.width, height: layout.height, alignment: layout.textAlignment.toAlignment)
//            .foregroundColor(foregroundColor)
//            .background(backgroundColor)
//            .border(layout.background.border?.borderColor() != nil  ? layout.background.border!.borderColor()! : Color.clear, width: layout.background.border?.width ?? 0)
//            .cornerRadius(layout.background.borderRadius ?? 0)
//            .position(x: layout.left + layout.width / 2, y: layout.top + layout.height / 2)
        return self.frame(width: layout.width, height: layout.height, alignment: layout.textAlignment.toAlignment)
            .foregroundColor(foregroundColor)
//            .background(
//                    RoundedRectangle(cornerRadius: layout.background.borderRadius ?? 0)
//                        .fill(backgroundColor)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: layout.background.borderRadius ?? 0)
//                                .stroke(layout.background.border?.borderColor() ?? Color.clear, lineWidth: layout.background.border?.width ?? 0)
//                        )
//                )
            .background(backgroundColor: backgroundColor, background: layout.background)
            .position(x: layout.left + layout.width / 2, y: layout.top + layout.height / 2)
    }
    
    public func layout(_ layout: CJBaseLayoutModel, overlayView: LinearGradient) -> some View {
        var backgroundColor: Color = Color.clear
        if layout.backgroundColor != nil {
            backgroundColor = Color(hex: layout.backgroundColor!)
        }
        
        let backgroundImage: UIImage? = layout.background.imageModel?.image
        
        
        // 提取布局属性
        let textFrame = CGRect(x: layout.left,
                               y: layout.top,
                               width: layout.width,
                               height: layout.height)

        let baseText = self
            .font(.custom(layout.font.name, fixedSize: layout.fontSize))
            .frame(width: textFrame.width, height: textFrame.height, alignment: layout.textAlignment.toAlignment)
//            .foregroundColor(Color(hex: layout.foregroundColor))
            .cornerRadius(layout.borderCornerRadius)

        
        // 文本及其叠加效果
        return baseText
            .foregroundColor(nil) // 文字无色
            .overlay(
                overlayView
                    .frame(width: textFrame.width, height: textFrame.height)
                    .mask(baseText.foregroundColor(.black)) // 使用同样的 Text 做遮罩
            )
            .background(backgroundColor: backgroundColor, background: layout.background)
            .position(x: textFrame.midX, y: textFrame.midY)
    }
    
    //    func property(_ property: CJBasePropertyModel) -> some View {
    public func property(_ property: CJBaseLayoutModel) -> some View {
        var font: Font
        if property.font.name.count == 0 {
            font = .system(size: property.fontSize, weight: property.fontWeight.toFontWeight)
        } else {
            font = .custom(property.font.name, fixedSize: property.fontSize)
        }
        
        return self
            .font(font)
            .lineLimit(property.lineLimit)
    }
}
