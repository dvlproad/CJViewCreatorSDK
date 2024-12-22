//
//  TSContentView.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/12/16.
//

import Foundation

import SwiftUI

struct TSContentView: View {
    @State private var isDatePickerVisible = false
    @State private var selectedDate = Date()
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Text("当前选择的日期：\(selectedDate, formatter: DateFormatter.shortDateFormatter)")
                
                Button("弹出日期选择器") {
                    isDatePickerVisible = true
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            
            // 透明背景与日期选择器视图
            if isDatePickerVisible {
                TransparentDatePickerView(isVisible: $isDatePickerVisible, selectedDate: $selectedDate)
                    .colorScheme(.light) // 强制浅色模式
            }
        }
        .animation(.easeInOut, value: isDatePickerVisible)
    }
}

extension DateFormatter {
    static var shortDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
}


struct TransparentDatePickerView: View {
    @Binding var isVisible: Bool
    @Binding var selectedDate: Date

    var body: some View {
        ZStack {
            // 半透明背景
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    isVisible = false // 点击背景关闭
                }

            // 日期选择器内容
            VStack {
                Spacer()

                VStack(spacing: 0) {
                    HStack {
                        Button("取消") {
                            isVisible = false
                        }
                        Spacer()
                        Text("选择日期")
                            .font(.headline)
                        Spacer()
                        Button("确定") {
                            isVisible = false
                        }
                    }
                    .padding()
                    .background(Color.white)

                    Divider()

                    DatePicker(
                        "",
                        selection: $selectedDate,
                        displayedComponents: [.date]
                    )
                    .datePickerStyle(WheelDatePickerStyle())
                    .labelsHidden()
                    .frame(height: 216)
                    .background(Color.white)
                    .cornerRadius(16)
                }
                .background(Color.white)
                .cornerRadius(16)
                .shadow(radius: 8)
                .padding()
            }
            .transition(.move(edge: .bottom))
        }
    }
}
