//
//  CJTitleValueRow.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/12/15.
//

import SwiftUI

// 扩展 View 类型，添加 title 头部
public extension View {
    func withLeadingTitle(_ title: String, titleWidth: CGFloat? = nil, onTapTitle: (() -> Void)? = nil) -> some View {
        HStack(alignment: .center, spacing: 0) {
            GeometryReader { geometry in
                Text(title)
                    .foregroundColor(Color(hex: "#333333"))
                    .font(.system(size: 15.5, weight: .medium))
                    .frame(height: geometry.size.height)
                    .onTapGesture {
                        onTapTitle?()
                    }
            }
            .frame(width: titleWidth)

            self // 将原始视图放在 title 后面
        }
    }
    
    func withTailingTitle(_ title: String, titleWidth: CGFloat? = nil, onTapTitle: (() -> Void)? = nil) -> some View {
        HStack(alignment: .center, spacing: 0) {
            self // 将原始视图放在 title 前面
            
            GeometryReader { geometry in
                Text(title)
                    .foregroundColor(Color(hex: "#FE4E38"))
                    .font(.system(size: 14, weight: .medium))
                    .frame(height: geometry.size.height)
                    .onTapGesture {
                        onTapTitle?()
                    }
            }
            .frame(width: titleWidth)
        }
    }
    
    
    func withCornerRadius(_ cornerRadius: CGFloat, horizontalPadding: CGFloat = 0.0) -> some View {
        self
            .padding(.horizontal, horizontalPadding)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(Color(hex: "#EEEEEE").opacity(1), lineWidth: 1)
            )
    }
    
    
}
