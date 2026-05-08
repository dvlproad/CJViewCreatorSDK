//
//  CJTextsView.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/11/27.
//

import Foundation
import SwiftUI
import WidgetKit
import CJViewElement_Swift
import CJViewGR_Swift

struct CJTextsView: View {
    @Binding var anyComponentModel: CJAllComponentConfigModel
//    @Binding var textModels: [TextsModel]
//    @State private var textModels: [CJTextLayoutModel] = []
    @Binding var dealUpdateUI: Int  // 工具区修改模型后，通知预览区重新读取文本模型。
    @Binding var toolUpdateUI: Int  // 预览区手势修改模型后，通知工具区重新读取位置与尺寸。
    @State private var textModels: [CJTextComponentConfigModel] = []  // 使用 @State 保存 textModels
    @State private var previewLayoutUpdateUI: Int = 0

    var body: some View {
        GeometryReader(content: { geometry in
            // 获取动态的 textModels
            let updatedTextModels = self.textModels // 这会是一个动态更新的副本
            
            // 在 ForEach 中使用 index 来获取绑定
            ForEach(0..<updatedTextModels.count, id: \.self) { index in
                let textModel = updatedTextModels[index]
                CJPreviewTextElementView(text: $textModels[index].data.text,
                                         layoutModel: $textModels[index].layout,
                                         isEditing: textModel.isEditing,
                                         onTransformEnded: { transform in
                    applyTransform(transform, toTextAt: index)
                })
                .zIndex(textModel.isEditing ? 1 : 0) // 如果多个元素重叠，正在编辑的那个排到上层，避免边框或手势被其他文本挡住。
                .id("preview-text-\(index)-\(textModel.id)-\(previewLayoutUpdateUI)")
            }
        })
        .onAppear {
            // 在视图出现时更新 textModels，确保它从 anyComponentModel 获取数据
            self.textModels = self.anyComponentModel.getAllLayoutModels()
        }
        .onChange(of: anyComponentModel) { oldValue, newValue in
            // 如果 anyComponentModel 改变，也要更新 textModels
            self.textModels = newValue.getAllLayoutModels()
            self.previewLayoutUpdateUI += 1
        }
        .onChange(of: dealUpdateUI) { oldValue, newValue in
            // 工具区修改 layout 后，预览区需要重新读取模型，并强制当前文本子树按新的 class 内部属性重新布局。
            // 这里只刷新预览内部，不反向更新 toolUpdateUI，避免形成工具区 -> 预览区 -> 工具区的回声循环。
            self.textModels = self.anyComponentModel.getAllLayoutModels()
            self.previewLayoutUpdateUI += 1
        }
    }

    private func applyTransform(_ transform: CJGRTransformResult, toTextAt index: Int) {
        guard textModels.indices.contains(index) else {
            return
        }
        // simultaneous gesture 结束时可能额外抛出 scale=1、rotation=0、translation=0 的空回调。
        // 空回调如果也触发预览/工具区刷新，放手瞬间会出现轻微抖动。
        guard transform.hasVisibleChange else {
            return
        }

        let layout = textModels[index].layout

        // 拖动结束后，把 addGR 内部的临时位移落到 layout.left/top。
        // addGR 会在回调后清掉内部位移，避免 layout 更新后出现双重偏移。
        layout.left += transform.translation.width
        layout.top += transform.translation.height

        // 缩放结束后，把临时 scale 烘焙到 layout.width/height。
        // scaleEffect 默认围绕中心缩放，所以更新尺寸时同步调整 left/top，保持中心点不跳。
        if transform.scale != 1 {
            let oldWidth = layout.width
            let oldHeight = layout.height
            let newWidth = max(1, oldWidth * transform.scale)
            let newHeight = max(1, oldHeight * transform.scale)

            layout.left -= (newWidth - oldWidth) / 2
            layout.top -= (newHeight - oldHeight) / 2
            layout.width = newWidth
            layout.height = newHeight
            layout.scale *= transform.scale
        }

        // 旋转也属于元素布局的一部分，写入 base layout，避免手势结束后旋转状态丢失。
        let rotationDegrees = CGFloat(transform.rotation.degrees)
        if rotationDegrees != 0 {
            layout.rotationDegrees += rotationDegrees
        }

        var updatedTextModels = textModels
        updatedTextModels[index] = textModels[index]
        textModels = updatedTextModels

        // layout 是 class 内部属性，直接修改不会自动触发当前 CJTextView 重新按新 left/top 布局。
        // 所以预览内部也要轻量刷新当前文本子树，否则 addGR 清掉临时位移后，视觉上会回到旧位置。
        previewLayoutUpdateUI += 1

        // 这里只通知工具区的布局设置区域刷新，不反向触发预览区全量刷新，避免形成“预览 -> 工具 -> 预览”的回声循环。
        toolUpdateUI += 1
    }
    
    // 将 textModels 改为计算属性
//    private var textModels: [CJTextLayoutModel] {
//        let allTextModels: [CJTextLayoutModel] = anyComponentModel.getAllLayoutModels()
//        
//        return allTextModels
//    }
}

private struct CJPreviewTextElementView: View {
    @Binding var text: String
    @Binding var layoutModel: CJTextLayoutModel
    let isEditing: Bool
    let onTransformEnded: (CJGRTransformResult) -> Void

    var body: some View {
        Group {
            if isEditing {
                // 预览编辑态才允许使用 decorateContent。
                // rotationDegrees 交给 addGR 的 baseRotation，保证内容和编辑边框一起旋转。
                CJTextView(text: $text, layoutModel: $layoutModel) { content in
                    content.addGR(
                        showCornerButton: true,
                        onDelete: {
                            
                        },
                        onUpdate: {
                            
                        },
                        onMinimize: nil,
                        onSelect: {
                            
                        },
                        onTransformEnded: onTransformEnded,
                        baseRotation: .degrees(layoutModel.rotationDegrees),
                        minScale: 0.4,
                        maxScale: 4.0
                    )
                }
            } else {
                // 普通态必须走不带 decorateContent 的初始化，让 layout 自己应用持久 rotationDegrees。
                // 这样预览业务层不会误把 content 修饰器传给普通态，避免旋转责任混乱。
                CJTextView(text: $text, layoutModel: $layoutModel)
            }
        }
    }
}

private extension CJGRTransformResult {
    var hasVisibleChange: Bool {
        abs(translation.width) > 0.01 ||
        abs(translation.height) > 0.01 ||
        abs(scale - 1) > 0.001 ||
        abs(rotation.degrees) > 0.01
    }
}

/*
// MARK: 预览 CJTextsView
struct CJTextsView_Previews: PreviewProvider {
    static var previews: some View {
        let family: WidgetFamily = .systemMedium
        var width: CGFloat = 166.0
        if family == .systemMedium {
            width = 333.0
        }
        
        let model = CQWidgetModel()

        let textModels: [CJTextLayoutModel]? = TSRowDataUtil.getTextModels(thingCount: 3, family: family)
        model.text.texts = textModels ?? [CJTextLayoutModel()]
        

        return CJTextsView()
            .environmentObject(model)
            .frame(width: width, height: 166)
            .backgroundColor(Color(hex: "#B1B6E5"))
    }
}
*/
