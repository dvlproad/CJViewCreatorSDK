//
//  PositionSizeInputView.swift
//  CJViewCreatorDemo
//
//  Created on 2026/04/30.
//

import SwiftUI

public struct PositionSizeInputView: View {
    @Binding var left: CGFloat
    @Binding var top: CGFloat
    @Binding var width: CGFloat
    @Binding var height: CGFloat
    var onChange: (() -> Void)? = nil
    
    public init(
        left: Binding<CGFloat>,
        top: Binding<CGFloat>,
        width: Binding<CGFloat>,
        height: Binding<CGFloat>,
        onChange: (() -> Void)? = nil
    ) {
        self._left = left
        self._top = top
        self._width = width
        self._height = height
        self.onChange = onChange
    }
    
    public var body: some View {
        VStack(spacing: 4) {
            // 第一行：left 和 width
            HStack(spacing: 20) {
                PropertyInputRow(title: "left", value: $left, onChange: onChange)
                PropertyInputRow(title: "width", value: $width, onChange: onChange)
            }
            
            // 第二行：top 和 height
            HStack(spacing: 20) {
                PropertyInputRow(title: "top", value: $top, onChange: onChange)
                PropertyInputRow(title: "height", value: $height, onChange: onChange)
            }
        }
    }
}

private struct PropertyInputRow: View {
    let title: String
    @Binding var value: CGFloat
    var step: CGFloat = 1.0
    var onChange: (() -> Void)? = nil
    
    var body: some View {
        HStack(spacing: 4) {
            Text(title)
                .font(.system(size: 15, weight: .medium))
                .fixedSize(horizontal: true, vertical: false)
            
            Button(action: { value -= step; onChange?() }) {
                Text("－")
                    .font(.system(size: 18, weight: .medium))
                    .frame(width: 36, height: 36)
                    .background(Color.gray.opacity(0.15))
                    .cornerRadius(6)
            }
            .buttonStyle(BorderlessButtonStyle())
            
            TextField("", value: $value, formatter: {
                let f = NumberFormatter()
                f.numberStyle = .decimal
                f.maximumFractionDigits = 2
                return f
            }())
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .keyboardType(.decimalPad)
            .frame(width: 48, height: 36)
            
            Button(action: { value += step; onChange?() }) {
                Text("＋")
                    .font(.system(size: 18, weight: .medium))
                    .frame(width: 36, height: 36)
                    .background(Color.gray.opacity(0.15))
                    .cornerRadius(6)
            }
            .buttonStyle(BorderlessButtonStyle())
        }
        .frame(maxWidth: .infinity)
        .onChange(of: value) { _ in onChange?() }
    }
}

#Preview {
    PositionSizeInputView(
        left: .constant(0),
        top: .constant(0),
        width: .constant(100),
        height: .constant(100)
    )
}
