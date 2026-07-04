//
//  TSSettingTitleRowView.swift
//  CJViewCreatorDemo
//
//  Created on 2026/07/04.
//

import SwiftUI
import CJViewElement_Swift

struct TSSettingTitleRowView: View {
    let originalColor = CJTextColorDataModel(solidColorString: "#F8AC9F")
    @State private var currentColor: CJTextColorDataModel

    init() {
        self.currentColor = originalColor.copy()
    }

    var body: some View {
        List {
            Section(header: Text("点击切换颜色")) {
                CJSettingTitleRow(
                    title: "背景颜色",
                    showRecoverIcon: .constant(currentColor != originalColor),
                    onTapRecover: {
                        currentColor = originalColor.copy()
                    }
                )

                HStack(spacing: 12) {
                    Circle()
                        .fill(Color(hex: "#F8AC9F"))
                        .frame(width: 30, height: 30)
                        .overlay(RoundedRectangle(cornerRadius: 15).stroke(currentColor.colorStrings[0] == "#F8AC9F" ? Color.blue : Color.clear, lineWidth: 2))
                        .onTapGesture { currentColor = CJTextColorDataModel(solidColorString: "#F8AC9F") }

                    Circle()
                        .fill(Color(hex: "#4A90D9"))
                        .frame(width: 30, height: 30)
                        .overlay(RoundedRectangle(cornerRadius: 15).stroke(currentColor.colorStrings[0] == "#4A90D9" ? Color.blue : Color.clear, lineWidth: 2))
                        .onTapGesture { currentColor = CJTextColorDataModel(solidColorString: "#4A90D9") }

                    Circle()
                        .fill(Color(hex: "#7ED321"))
                        .frame(width: 30, height: 30)
                        .overlay(RoundedRectangle(cornerRadius: 15).stroke(currentColor.colorStrings[0] == "#7ED321" ? Color.blue : Color.clear, lineWidth: 2))
                        .onTapGesture { currentColor = CJTextColorDataModel(solidColorString: "#7ED321") }

                    Spacer()

                    Text("当前值: \(currentColor == originalColor ? "初始" : "已修改")")
                        .font(.caption)
                        .foregroundColor(currentColor == originalColor ? .gray : .orange)
                }
                .padding(.horizontal, 10)
            }
        }
        .navigationTitle("CJSettingTitleRow 测试")
    }
}
