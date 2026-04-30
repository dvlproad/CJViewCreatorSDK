//
//  PositionSizeInputView.swift
//  CJViewCreatorDemo
//
//  Created on 2026/04/30.
//

import SwiftUI

struct PositionSizeInputView: View {
    @Binding var left: CGFloat
    @Binding var top: CGFloat
    @Binding var width: CGFloat
    @Binding var height: CGFloat
    
    var body: some View {
        VStack(spacing: 20) {
            // 第一行：left 和 width
            HStack(spacing: 20) {
                PropertyInputRow(title: "left", value: $left)
                PropertyInputRow(title: "width", value: $width)
            }
            
            // 第二行：top 和 height
            HStack(spacing: 20) {
                PropertyInputRow(title: "top", value: $top)
                PropertyInputRow(title: "height", value: $height)
            }
        }
        .padding()
    }
}

private struct PropertyInputRow: View {
    let title: String
    @Binding var value: CGFloat
    
    var body: some View {
        HStack(spacing: 8) {
            Text(title)
                .font(.system(size: 15, weight: .medium))
                .frame(width: 40, alignment: .leading)
            
            TextField("", value: $value, formatter: {
                let f = NumberFormatter()
                f.numberStyle = .decimal
                f.maximumFractionDigits = 2
                return f
            }())
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .keyboardType(.decimalPad)
            .frame(height: 36)
        }
        .frame(maxWidth: .infinity)
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
