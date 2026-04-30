//
//  TSTextInputView.swift
//  CJViewCreatorDemo
//
//  Created on 2026/04/30.
//

import SwiftUI
import CJViewElement_Swift

struct TSTextInputView: View {
    @State private var singleLineText: String = ""
    @State private var multiLineText: String = ""
    @State private var disabledText: String = "不可编辑"
    @State private var centerText: String = ""
    @State private var trailingText: String = ""
    @State private var longText: String = "这是一段很长的初始文本，用来测试文字超出边界时的表现情况，看看是否会正确显示省略或者滚动"
    
    var body: some View {
        List {
            Section(header: Text("单行输入 (lineLimit: 1)")) {
                CJTextInputView(
                    text: $singleLineText,
                    placeHolder: "请输入单行文本",
                    lineLimit: 1,
                    textDidChange: { print("单行文本变化: \($0)") }
                )
                .frame(height: 40)
                .withCornerRadius(10.0, horizontalPadding: 10.0)
                .padding(.horizontal, 10)
                
                Text("当前内容: \(singleLineText.isEmpty ? "(空)" : singleLineText)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Section(header: Text("多行输入 (lineLimit: 5)")) {
                CJTextInputView(
                    text: $multiLineText,
                    placeHolder: "请输入多行文本",
                    lineLimit: 5,
                    textDidChange: { print("多行文本变化: \($0)") }
                )
                .frame(height: 100)
                .withCornerRadius(10.0, horizontalPadding: 10.0)
                .padding(.horizontal, 10)
                
                Text("当前内容: \(multiLineText.isEmpty ? "(空)" : multiLineText)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Section(header: Text("不可编辑")) {
                CJTextInputView(
                    text: $disabledText,
                    placeHolder: "不可编辑",
                    isEditable: false,
                    lineLimit: 1,
                    textDidChange: { _ in }
                )
                .frame(height: 40)
                .withCornerRadius(10.0, horizontalPadding: 10.0)
                .padding(.horizontal, 10)
            }
            
            Section(header: Text("居中对齐")) {
                CJTextInputView(
                    text: $centerText,
                    placeHolder: "居中对齐输入",
                    multilineTextAlignment: .center,
                    lineLimit: 1,
                    textDidChange: { print("居中文本: \($0)") }
                )
                .frame(height: 40)
                .withCornerRadius(10.0, horizontalPadding: 10.0)
                .padding(.horizontal, 10)
            }
            
            Section(header: Text("右对齐")) {
                CJTextInputView(
                    text: $trailingText,
                    placeHolder: "右对齐输入",
                    multilineTextAlignment: .trailing,
                    lineLimit: 1,
                    textDidChange: { print("右对齐文本: \($0)") }
                )
                .frame(height: 40)
                .withCornerRadius(10.0, horizontalPadding: 10.0)
                .padding(.horizontal, 10)
            }
            
            Section(header: Text("长文本测试")) {
                CJTextInputView(
                    text: $longText,
                    placeHolder: "长文本测试",
                    lineLimit: 3,
                    textDidChange: { print("长文本变化: \($0)") }
                )
                .frame(height: 80)
                .withCornerRadius(10.0, horizontalPadding: 10.0)
                .padding(.horizontal, 10)
            }
            
            Section(header: Text("清空按钮测试")) {
                CJTextInputView(
                    text: .constant("点击右侧关闭按钮清空"),
                    placeHolder: "有内容时显示关闭按钮",
                    lineLimit: 1,
                    textDidChange: { _ in }
                )
                .frame(height: 40)
                .withCornerRadius(10.0, horizontalPadding: 10.0)
                .padding(.horizontal, 10)
            }
        }
        .navigationTitle("CJTextInputView 测试")
    }
}
