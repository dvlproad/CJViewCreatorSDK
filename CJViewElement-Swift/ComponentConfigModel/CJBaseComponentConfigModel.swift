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
//    associatedtype ChildComponentType: CJBaseComponentConfigModelProtocol
    
    var componentType: CJComponentType { get set }
    var data: DataType { get set }
    var layout: LayoutType { get set }
//    var childComponents: [ChildComponentType]? { get set }
    var childComponents: [any CJBaseComponentConfigModelProtocol]? { get set }
    
    // MARK: isEqual 方法
    /// 判断两个组件是否相等 childComponents 的比较：
    //    •    因为 childComponents 是 [any CJBaseComponentConfigModelProtocol]? 类型，协议本身不支持直接比较，因此我们需要提供自定义比较逻辑。
    //    •    在协议中增加 isEqual(to:) 方法用于比较不同实现类型的实例。
    func isEqual(to other: any CJBaseComponentConfigModelProtocol) -> Bool
//    func updateData(referDate: Date, isForDesktop: Bool)
}

extension CJBaseComponentConfigModel: CJBaseModel {
    // MARK: - Equatable
    public static func == (lhs: CJBaseComponentConfigModel<DataType, LayoutType>,
                           rhs: CJBaseComponentConfigModel<DataType, LayoutType>) -> Bool
    {
        // 比较基本属性
        guard lhs.componentType == rhs.componentType,
              lhs.data == rhs.data,
              lhs.layout == rhs.layout,
              lhs.isEditing == rhs.isEditing else {
            return false
        }

        // 比较 childComponents
        if let lhsChildren = lhs.childComponents, let rhsChildren = rhs.childComponents {
            // 确保子组件数量相同
            guard lhsChildren.count == rhsChildren.count else { return false }

            // 对每个子组件进行比较
            for (lhsChild, rhsChild) in zip(lhsChildren, rhsChildren) {
                if !lhsChild.isEqual(to: rhsChild) {
                    return false
                }
            }
            return true
        } else {
            // 如果一个有子组件另一个没有，则不相等
            return lhs.childComponents == nil && rhs.childComponents == nil
        }
    }
}

open class CJBaseComponentConfigModel<DataType: CJBaseModel, LayoutType: CJBaseModel>: CJBaseComponentConfigModelProtocol {
    
    
    public var id: String = ""
    public var componentType: CJComponentType = .unknown
    public var data: DataType
    public var layout: LayoutType
//    public var childComponents: [CJBaseComponentConfigModel]? = nil
    public var childComponents: [any CJBaseComponentConfigModelProtocol]?
//    var overlay: CJBoxDecorationModel?       // 文字元素可以在上面盖渐变色视图，再mask下，从而形成看起来好像是渐变颜色的效果
//    var background: CJBoxDecorationModel?
    public var isEditing: Bool = false          // 是否正在编辑中，编辑中的时候多个边框标记出来，以更好辨认
    
    
    // MARK: - Init
    required public init() {
//        fatalError("Subclasses must implement required init()")
        self.layout = LayoutType()
        self.data = DataType()
    }
    
    
    public init(id: String, componentType: CJComponentType, data: DataType, layout: LayoutType, childComponents: [any CJBaseComponentConfigModelProtocol]? = nil) {
        self.id = id
        self.componentType = componentType
        self.data = data
        self.layout = layout
        self.childComponents = childComponents
    }
    
    // MARK: isEqual 方法
    public func isEqual(to other: any CJBaseComponentConfigModelProtocol) -> Bool {
        guard let otherModel = other as? CJBaseComponentConfigModel<DataType, LayoutType> else {
            return false
        }
        return self == otherModel
    }
    
    // MARK: - Codable
    public enum CodingKeys: String, CodingKey {
        case id
        case componentType
        case data
        case layout
        case childComponents = "components"
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(String.self, forKey: .id)
        let componentType = try container.decode(CJComponentType.self, forKey: .componentType)
        
        var data: DataType
        do {
            data = try container.decode(DataType.self, forKey: .data)
            //debugPrint("✅Success:底层对 \(DataType.self) 解析成功 \(data)")
        } catch {
            debugPrint("❌Error:底层对 \(DataType.self) 解析错误 \(error)")
            data = DataType()
        }
        
        var layout: LayoutType
        do {
            layout = try container.decode(LayoutType.self, forKey: .layout)
            //debugPrint("✅Success:底层对 \(LayoutType.self) 解析成功 \(layout)")
        } catch {
            debugPrint("❌Error:底层对 \(LayoutType.self) 解析错误 \(error)")
            layout = LayoutType()
        }
        
        var childComponents: [any CJBaseComponentConfigModelProtocol]?
        do {
            // 动态解码 childComponents
            let childDataArray = try container.decodeIfPresent([DynamicCodableComponent].self, forKey: .childComponents)
            if childDataArray != nil {
                childComponents = childDataArray!.compactMap { $0.base }
            }
            //debugPrint("✅Success:底层动态解码 childComponents 成功, \(childComponents)")
        } catch {
            debugPrint("❌Error: 底层动态解码 childComponents 失败, \(error)")
        }
        
        self.id = id
        self.componentType = componentType
        self.data = data
        self.layout = layout
        self.childComponents = childComponents
        //self.init(id: id, componentType: componentType, data: data, layout: layout)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(componentType, forKey: .componentType)
        try container.encodeIfPresent(data, forKey: .data)
        try container.encodeIfPresent(layout, forKey: .layout)
        
        // 动态编码 childComponents
        if let childComponents = childComponents {
            let encodedComponents = childComponents.map { DynamicCodableComponent($0) }
            try container.encode(encodedComponents, forKey: .childComponents)
        }
    }
    
    
    
}

// MARK: - 动态类型支持
/// 注册解码器的类型表
private var registeredComponentTypes: [String: any CJBaseComponentConfigModelProtocol.Type] = [:]

/// 注册类型
public func registerComponentType(_ type: any CJBaseComponentConfigModelProtocol.Type, forKey key: String) {
    registeredComponentTypes[key] = type
}
/// 动态解码包装
public struct DynamicCodableComponent: Codable {
    public let base: (any CJBaseComponentConfigModelProtocol)?

    init(_ base: any CJBaseComponentConfigModelProtocol) {
        self.base = base
    }

    // MARK: - Codable
    enum CodingKeys: String, CodingKey {
        case componentType
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let typeKey = try container.decode(String.self, forKey: .componentType)

        guard let type = registeredComponentTypes[typeKey] else {
            throw DecodingError.dataCorruptedError(forKey: .componentType,
                                                   in: container,
                                                   debugDescription: "Unknown type key: \(typeKey)")
        }
        var base = try type.init(from: decoder)
        base = base as (any CJBaseComponentConfigModelProtocol)
        self.base = base
    }

    public func encode(to encoder: Encoder) throws {
        guard let base = base else { return }
        var container = encoder.container(keyedBy: CodingKeys.self)
        let typeKey = String(describing: type(of: base))
        try container.encode(typeKey, forKey: .componentType)
        try base.encode(to: encoder)
    }

    
}

// 重要知识点：
// position: 会改变视图的实际布局坐标。即视图的坐标系以其 position 设置的位置为中心。
// offset: 相对于视图原始位置进行偏移。偏移不会改变视图的布局框架或坐标系，只是视觉上的移动。
//如果需要动态调整位置且避免坐标系改变，优先使用 offset。避免使用 position，特别是当你需要在之后叠加其他修饰符（如 overlay）时。这不仅可以保持视图行为的可控性，还能减少潜在的视觉和布局问题。
//    •    如果可以通过父容器布局控制位置，考虑 ZStack 或其他容器的对齐属性。
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
//            .position(x: layout.left + layout.width / 2, y: layout.top + layout.height / 2)
            .offset(x: layout.left, y: layout.top) // 使用偏移动态调整位置
//            .overlay(content: {
//                Rectangle()
//                    .stroke(Color.black, lineWidth: layout.left == 23 ? 1 : 0)  // 添加蓝色的边框
//                    .padding(-1)
//                    .offset(x: layout.left, y: layout.top) // 如果必须在 offset 后设置 overlay，需要手动调整 overlay 的偏移量
//            })
            
        
        
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
//            .position(x: textFrame.midX, y: textFrame.midY)
            .offset(x: textFrame.minX, y: textFrame.minY) // 使用偏移动态调整位置
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
