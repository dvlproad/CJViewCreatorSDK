//
//  CJTitleValueRow.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/12/15.
//

import SwiftUI

public struct CJPrefixTitleValueRow<ValueView>: View where ValueView: View  {
    public var title: String
    public var titleWidth: CGFloat? // 如果非空，则会固定title视图的宽度
    public var onTapTitle: (() -> Void)?
    
    public var valueViewCreater: () -> ValueView


    public init(title: String,
                titleWidth: CGFloat? = nil,
                onTapTitle: (() -> Void)? = nil,
                @ViewBuilder valueViewCreater: @escaping () -> ValueView
    ) {
        self.title = title
        self.titleWidth = titleWidth
        self.onTapTitle = onTapTitle
        self.valueViewCreater = valueViewCreater
    }
    
    
    public var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Text(title)
                .foregroundColor(Color(hex: "#333333"))
                .font(.system(size: 15.5, weight: .medium))
                .frame(width: titleWidth, height: 30)
                .onTapGesture {
                    onTapTitle?()
                }
            
            Spacer()
            
            valueView
        }
    }
    
    private var valueView: ValueView {
        valueViewCreater()
    }
}


// 扩展 View 类型，添加 title 头部
public extension View {
    public func withLevelOneLeadingTitle(_ title: String, titleWidth: CGFloat? = nil, spacing: CGFloat = 0.0, onTapTitle: (() -> Void)? = nil) -> some View {
        return withLeadingTitle(title, titleWidth: titleWidth, titleFont: .system(size: 15.5, weight: .medium), spacing: spacing, onTapTitle: onTapTitle)
    }
    
    public func withLevelTwoLeadingTitle(_ title: String, titleWidth: CGFloat? = nil, spacing: CGFloat = 0.0, onTapTitle: (() -> Void)? = nil) -> some View {
        return withLeadingTitle(title, titleWidth: titleWidth, titleFont: .system(size: 14.0, weight: .regular), spacing: spacing, onTapTitle: onTapTitle)
    }
    
    public func withLevelTwoTailingTitle(_ title: String, titleWidth: CGFloat? = nil, spacing: CGFloat = 0.0, onTapTitle: (() -> Void)? = nil) -> some View {
        return withTailingTitle(title, titleWidth: titleWidth, titleFont: .system(size: 14.0, weight: .regular), spacing: spacing, onTapTitle: onTapTitle)
    }
    
    public func withLeadingTitle(_ title: String, titleWidth: CGFloat? = nil, titleFont: Font, spacing: CGFloat = 0.0, onTapTitle: (() -> Void)? = nil) -> some View {
        GeometryReader { geometry in
            HStack(alignment: .center, spacing: 0) {
                Text(title)
                    .foregroundColor(Color(hex: "#333333"))
                    .font(titleFont)
                    .frame(width: titleWidth, height: geometry.size.height)
                    .onTapGesture {
                        onTapTitle?()
                    }
                    //.background(Color.randomColor)
                
                Spacer(minLength: 0).frame(width:spacing)
                
                self // 将原始视图放在 title 后面
                    //.background(Color.randomColor)
            }
        }
    }
    
    public func withTailingTitle(_ title: String, titleWidth: CGFloat? = nil, titleFont: Font, spacing: CGFloat = 0.0, onTapTitle: (() -> Void)? = nil) -> some View {
        GeometryReader { geometry in
            HStack(alignment: .center, spacing: 0) {
                self // 将原始视图放在 title 前面
                
                Spacer(minLength: 0).frame(width:spacing)
                
                Text(title)
                    .foregroundColor(Color(hex: "#FE4E38"))
                    .font(titleFont)
                    .frame(width: titleWidth, height: geometry.size.height)
                    .onTapGesture {
                        onTapTitle?()
                    }
            }
        }
    }
    
    public func withTailingValue(_ value: Binding<String?>?, spacing: CGFloat? = nil, onTapValue: (() -> Void)? = nil) -> some View {
        // 为下面代码在外层再加 GeometryReader { geometry in 会导致竖直不居中
        HStack(alignment: .center, spacing: 0) {
            self // 将原始视图放在 value 前面
            
            if let spacing = spacing {
                Spacer(minLength: 0).frame(width:spacing)
            } else {
                Spacer()
            }
            
            if let value = value, let valueString = value.wrappedValue {
                HStack(alignment: .center, spacing: 0) {
                    Text(valueString)
                        .font(.system(size: 13.5, weight: .regular))
                        .foregroundColor(Color(hex: "#999999"))
                    Image("arrow_right")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 6, height: 10, alignment: .center)
                        .padding(.leading, 10)
                }
                .onTapGesture {
                    onTapValue?()
                }
            }
        }
    }
    
    
    
    
    public func withCornerRadius(_ cornerRadius: CGFloat, horizontalPadding: CGFloat = 0.0) -> some View {
        self
            .padding(.horizontal, horizontalPadding)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(Color(hex: "#EEEEEE").opacity(1), lineWidth: 1)
            )
    }
    
    
}
