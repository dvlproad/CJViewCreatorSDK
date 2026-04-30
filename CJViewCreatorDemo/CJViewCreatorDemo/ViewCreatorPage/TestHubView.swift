//
//  TestHubView.swift
//  CJViewCreatorDemo
//
//  Created on 2026/04/30.
//

import SwiftUI

struct TestHubView: View {
    var body: some View {
        List {
            NavigationLink(destination: TSViewExtensionView()) {
                Label("View 扩展测试", systemImage: "square.stack.3d.up.fill")
            }
            
            NavigationLink(destination: TSTextInputView()) {
                Label("CJTextInputView 测试", systemImage: "text.cursor")
            }
            
            NavigationLink(destination: PositionSizeTestView()) {
                Label("PositionSizeInputView 测试", systemImage: "arrow.up.left.and.arrow.down.right")
            }
        }
        .navigationTitle("测试汇总")
    }
}

#Preview {
    NavigationView {
        TestHubView()
    }
}
