//
//  CJViewGRExtension.swift
//  CJViewGRDemo
//
//  Created by qian on 2024/11/27.
//

import SwiftUI

public extension View {
    // 调试用背景修饰符。
    public func redBackground(color: Color = .red, cornerRadius: CGFloat = 0, padding: CGFloat = 0) -> some View {
        self.modifier(
            RedBackgroundModifier(color: color,
                                  cornerRadius: cornerRadius,
                                  padding: padding)
        )
    }
    
    
    // 为视图添加基础手势能力：拖动、双指缩放、双指旋转。
    public func addGR(enableGR: Bool = true,
                      grModel: String = "",
                      showCornerButton: Bool = true,
                      minScale: CGFloat = 0.3,
                      maxScale: CGFloat = 6.0) -> some View {
        addGR(enableGR: enableGR,
              grModel: grModel,
              showCornerButton: showCornerButton,
              onDelete: nil,
              onUpdate: nil,
                      onMinimize: nil,
                      onSelect: nil,
                      onTransformEnded: nil,
                      baseRotation: .zero,
                      minScale: minScale,
                      maxScale: maxScale)
    }

    // 为视图添加完整贴纸编辑能力。showCornerButton 通常由外部选中态控制；
    // onSelect 会在点击、拖动、缩放、旋转和右下角操作柄拖动时触发。
    public func addGR(enableGR: Bool = true,
                      grModel: String = "",
                      showCornerButton: Bool = true,
                      onDelete: (() -> Void)?,
                      onUpdate: (() -> Void)?,
                      onMinimize: (() -> Void)?,
                      onSelect: (() -> Void)? = nil,
                      onTransformEnded: ((CJGRTransformResult) -> Void)? = nil,
                      baseRotation: Angle = .zero,
                      minScale: CGFloat = 0.3,
                      maxScale: CGFloat = 6.0) -> some View {
        self.modifier(
//            CJGRViewModifier(imageModel: grModel)
            CJGRViewModifier(enableGR: enableGR,
                             showCornerButton: showCornerButton,
                             onDelete: onDelete,
                             onUpdate: onUpdate,
                             onMinimize: onMinimize,
                             onSelect: onSelect,
                             onTransformEnded: onTransformEnded,
                             baseRotation: baseRotation,
                             minScale: minScale,
                             maxScale: maxScale)
        )
    }
    
    
    // 为视图添加边框和三个角按钮
    public func addGRButtons(onDelete: @escaping () -> Void,
                      onUpdate: @escaping () -> Void,
                      onMinimize: @escaping () -> Void
    ) -> some View {
        self.modifier(CJGRCornerViewModifier(
            onDelete: onDelete,
            onUpdate: onUpdate,
            onMinimize: onMinimize
        ))
    }
}





// 自定义ViewModifier，接受参数以自定义红色背景视图的样式
public struct RedBackgroundModifier: ViewModifier {
    var color: Color
    var cornerRadius: CGFloat
    var padding: CGFloat

    public func body(content: Content) -> some View {
        content
//            .padding(padding) // 添加内边距
            .background(color) // 应用红色背景
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius)) // 应用圆角
//            .border(Color.green, width: padding)
        
    }
}
