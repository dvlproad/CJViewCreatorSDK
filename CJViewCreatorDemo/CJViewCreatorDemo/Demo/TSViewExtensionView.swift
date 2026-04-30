//
//  TSViewExtensionView.swift
//  CJViewCreatorDemo
//
//  Created on 2026/04/30.
//

import SwiftUI
import CJViewElement_Swift

struct TSViewExtensionView: View {
    @State private var showAlert: Bool = false
    
    var body: some View {
        List {
            // MARK: - withLeadingTitle
            Section(header: Text("加前视图 withLeadingTitle")) {
                Text("我是内容")
                    .withLeadingTitle("我是标题可点击", titleWidth: 120, titleFont: .system(size: 14.0, weight: .regular)) {
                        showAlert = true
                    }
                    .background(Color.red.opacity(0.2))
                    .alert("标题被点击", isPresented: $showAlert) {
                        Button("确定", role: .cancel) { }
                    }
            }
            
            // MARK: - withCornerRadius
            Section(header: Text("加圆角 withCornerRadius")) {
                Text("圆角边框")
                    .withCornerRadius(10.0, horizontalPadding: 10.0)
                    .padding(.vertical, 10)
                    .frame(height: 44)
                
                Text("无水平内边距")
                    .withCornerRadius(8.0)
                    .padding(.vertical, 10)
                    .frame(height: 44)
            }
            
            
            // MARK: - withLeadingTitle
            Section(header: Text("加圆角和前视图")) {
                Text("对内容视图加边框")
                    .frame(height: 40)
                    .withCornerRadius(20.0, horizontalPadding: 10.0)
                    .withLevelOneLeadingTitle("标题", titleWidth: 80)
                    .background(Color.green.opacity(0.2))
                
                Text("对整行加边框")
                    .withLevelOneLeadingTitle("标题", titleWidth: 80)
                    .withCornerRadius(30.0, horizontalPadding: 0.0)
                    .background(Color.green.opacity(0.2))
                    .frame(height: 60)
                
                Text("hello")
                .frame(height: 40)
                .withCornerRadius(10.0, horizontalPadding: 10.0)
                .withLevelOneLeadingTitle("文字", titleWidth: 40)
                .padding(.horizontal, 20)
                .background(Color.red.opacity(0.4))
    
            }
            .background(Color.blue.opacity(0.2))
        }
        .navigationTitle("View 扩展测试")
    }
}
