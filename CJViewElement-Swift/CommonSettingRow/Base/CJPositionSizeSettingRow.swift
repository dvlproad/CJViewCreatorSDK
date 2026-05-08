//
//  CJPositionSizeSettingRow.swift
//  CJViewElement-Swift
//
//  Created on 2026/04/30.
//

import SwiftUI

public struct CJPositionSizeSettingRow<LayoutType: CJBaseLayoutModel>: View {
    let title: String
    let originalLayout: LayoutType   // let 保证不会被意外修改
    @State var currentLayout: LayoutType
    var onChange: ((LayoutType) -> Void)?
    
    public init(
        title: String = "位置与尺寸",
        originalLayout: LayoutType,
        currentLayout: LayoutType,
        onChange: ((LayoutType) -> Void)? = nil
    ) {
        self.title = title
        // 保存 originalLayout 的独立副本（深拷贝）
        self.originalLayout = originalLayout.copy() as! LayoutType
        // currentLayout 也初始化为副本，避免和外部共享引用
        self._currentLayout = State(initialValue: currentLayout.copy() as! LayoutType)
        self.onChange = onChange
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            CJSettingTitleRow(
                title: title,
                showRecoverIcon: .constant(true),
                onTapRecover: {
                    // 恢复时从 originalLayout 重新拷贝，确保是全新对象
                    currentLayout = originalLayout.copy() as! LayoutType
                    onChange?(currentLayout)
                }
            )
            .padding(.leading, 21)
            .padding(.top, 0)
            .padding(.bottom, 4)
            
            CJLayoutInputView(
                left: Binding(get: { currentLayout.left }, set: { currentLayout.left = $0 }),
                top: Binding(get: { currentLayout.top }, set: { currentLayout.top = $0 }),
                width: Binding(get: { currentLayout.width }, set: { currentLayout.width = $0 }),
                height: Binding(get: { currentLayout.height }, set: { currentLayout.height = $0 }),
                scale: Binding(get: { currentLayout.scale }, set: { currentLayout.scale = $0 }),
                rotationDegrees: Binding(get: { currentLayout.rotationDegrees }, set: { currentLayout.rotationDegrees = $0 }),
                onChange: {
                    onChange?(currentLayout)
                }
            )
            .padding(.horizontal, 10)
            .padding(.bottom, 4)
        }
    }
}

#Preview {
    CJPositionSizeSettingRow(
        originalLayout: CJBaseLayoutModel(left: 10, top: 20, width: 200, height: 100),
        currentLayout: CJBaseLayoutModel(left: 10, top: 20, width: 200, height: 100),
        onChange: { layout in
            print("layout changed: \(layout)")
        }
    )
}
