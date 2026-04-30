//
//  CJPositionSizeSettingRow.swift
//  CJViewElement-Swift
//
//  Created on 2026/04/30.
//

import SwiftUI

public struct CJPositionSizeSettingRow: View {
    var title: String
    @Binding var left: CGFloat
    @Binding var top: CGFloat
    @Binding var width: CGFloat
    @Binding var height: CGFloat
    var onChange: (() -> Void)?
    
    public init(
        title: String = "位置与尺寸",
        left: Binding<CGFloat>,
        top: Binding<CGFloat>,
        width: Binding<CGFloat>,
        height: Binding<CGFloat>,
        onChange: (() -> Void)? = nil
    ) {
        self.title = title
        self._left = left
        self._top = top
        self._width = width
        self._height = height
        self.onChange = onChange
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .foregroundColor(Color(hex: "#333333"))
                .font(.system(size: 15.5, weight: .medium))
                .padding(.leading, 21)
                .padding(.top, 0)
                .padding(.bottom, 4)
            
            PositionSizeInputView(left: $left, top: $top, width: $width, height: $height, onChange: onChange)
                .padding(.horizontal, 10)
                .padding(.bottom, 4)
        }
    }
}

#Preview {
    CJPositionSizeSettingRow(
        left: .constant(10),
        top: .constant(20),
        width: .constant(200),
        height: .constant(100)
    )
}
