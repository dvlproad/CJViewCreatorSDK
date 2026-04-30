//
//  PositionSizeTestView.swift
//  CJViewCreatorDemo
//
//  Created on 2026/04/30.
//

import SwiftUI
import CJViewElement_Swift

struct PositionSizeTestView: View {
    @State private var left: CGFloat = 10
    @State private var top: CGFloat = 20
    @State private var width: CGFloat = 200
    @State private var height: CGFloat = 100
    
    var body: some View {
        VStack(spacing: 20) {
            PositionSizeInputView(
                left: $left,
                top: $top,
                width: $width,
                height: $height
            )
            .withCornerRadius(10.0, horizontalPadding: 10.0)
            .padding(.horizontal, 10)
            
            // 预览区域
            Text("预览视图")
                .frame(width: width, height: height)
                .background(Color.blue.opacity(0.3))
                .position(x: left + width / 2, y: top + height / 2)
                .border(Color.blue, width: 1)
            
            // 当前值显示
            VStack(alignment: .leading, spacing: 8) {
                Text("当前值：")
                    .font(.headline)
                Text("left: \(Int(left))")
                Text("top: \(Int(top))")
                Text("width: \(Int(width))")
                Text("height: \(Int(height))")
            }
            .font(.caption)
            .foregroundColor(.gray)
            .padding()
            
            Spacer()
        }
        .navigationTitle("PositionSizeInputView 测试")
    }
}
