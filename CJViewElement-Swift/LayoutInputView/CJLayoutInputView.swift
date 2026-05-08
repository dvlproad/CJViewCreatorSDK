//
//  CJLayoutInputView.swift
//  CJViewCreatorDemo
//
//  Created on 2026/04/30.
//

import SwiftUI

public struct CJLayoutInputView: View {
    @Binding var left: CGFloat
    @Binding var top: CGFloat
    @Binding var width: CGFloat
    @Binding var height: CGFloat
    @Binding var scale: CGFloat
    @Binding var rotationDegrees: CGFloat
    var onChange: (() -> Void)? = nil
    
    public init(
        left: Binding<CGFloat>,
        top: Binding<CGFloat>,
        width: Binding<CGFloat>,
        height: Binding<CGFloat>,
        scale: Binding<CGFloat> = .constant(1),
        rotationDegrees: Binding<CGFloat> = .constant(0),
        onChange: (() -> Void)? = nil
    ) {
        self._left = left
        self._top = top
        self._width = width
        self._height = height
        self._scale = scale
        self._rotationDegrees = rotationDegrees
        self.onChange = onChange
    }
    
    public var body: some View {
        VStack(spacing: 4) {
            // 第一行：left 和 width
            HStack(spacing: 20) {
                CJLayoutPropertyInputView(title: "left", value: $left, onChange: onChange)
                CJLayoutPropertyInputView(title: "width", value: $width, onChange: onChange)
            }
            
            // 第二行：top 和 height
            HStack(spacing: 20) {
                CJLayoutPropertyInputView(title: "top", value: $top, onChange: onChange)
                CJLayoutPropertyInputView(title: "height", value: $height, onChange: onChange)
            }

            // 第三行：缩放倍数和旋转角度
            HStack(spacing: 20) {
                CJLayoutPropertyInputView(title: "scale", value: $scale, step: 0.1, fractionDigits: 2, valueRange: 0.01...100, onChange: onChange)
                CJLayoutPropertyInputView(title: "rotation", value: $rotationDegrees, step: 1, fractionDigits: 0, onChange: onChange)
            }
        }
    }
}

private struct CJLayoutPropertyInputView: View {
    let title: String
    @Binding var value: CGFloat
    var step: CGFloat = 1.0
    var fractionDigits: Int = 0
    var valueRange: ClosedRange<CGFloat>?
    var onChange: (() -> Void)? = nil

    private var displayValue: Binding<CGFloat> {
        Binding(
            get: {
                formattedValue(value)
            },
            set: { newValue in
                commitValue(newValue)
            }
        )
    }
    
    var body: some View {
        HStack(spacing: 4) {
            Text(title)
                .font(.system(size: 15, weight: .medium))
                .fixedSize(horizontal: true, vertical: false)
            
            Button(action: { commitValue(value - step) }) {
                Text("－")
                    .font(.system(size: 18, weight: .medium))
                    .frame(width: 36, height: 36)
                    .background(Color.gray.opacity(0.15))
                    .cornerRadius(6)
            }
            .buttonStyle(BorderlessButtonStyle())
            
            TextField("", value: displayValue, formatter: {
                let f = NumberFormatter()
                f.numberStyle = .decimal
                // 位置与尺寸、旋转按整数展示；缩放倍数保留小数。
                f.minimumFractionDigits = 0
                f.maximumFractionDigits = fractionDigits
                return f
            }())
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .keyboardType(.decimalPad)
            .frame(width: 48, height: 36)
            
            Button(action: { commitValue(value + step) }) {
                Text("＋")
                    .font(.system(size: 18, weight: .medium))
                    .frame(width: 36, height: 36)
                    .background(Color.gray.opacity(0.15))
                    .cornerRadius(6)
            }
            .buttonStyle(BorderlessButtonStyle())
        }
        .frame(maxWidth: .infinity)
    }

    private func commitValue(_ rawValue: CGFloat) {
        // value 最终会写到 layout class 的内部属性上，@State 持有的 layout 引用本身不会变化。
        // 因此不能只依赖 .onChange(of:) 侦测变更，按钮和输入框提交时必须主动通知外层刷新预览。
        value = formattedValue(rawValue)
        onChange?()
    }

    private func formattedValue(_ rawValue: CGFloat) -> CGFloat {
        let multiplier = CGFloat(pow(10.0, Double(fractionDigits)))
        let roundedValue = (rawValue * multiplier).rounded() / multiplier
        if let valueRange {
            return min(max(roundedValue, valueRange.lowerBound), valueRange.upperBound)
        }
        return roundedValue
    }
}

#Preview {
    CJLayoutInputView(
        left: .constant(0),
        top: .constant(0),
        width: .constant(100),
        height: .constant(100)
    )
}
