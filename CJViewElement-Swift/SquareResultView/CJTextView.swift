//
//  CJTextsView.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/12/15.
//

import SwiftUI

public struct CJTextView: View {
    @Binding var text: String
    @Binding var layoutModel: CJTextLayoutModel
    // 用来把编辑态能力插入到 layout 的正确阶段。
    // 注意：它不是普通的外层修饰。layout 内部会先生成 width/height 后的内容盒子，
    // 再调用 decorateContent，最后才做 left/top 偏移。
    // 这样 `.addGR(...)` 的边框可以贴合真实内容边界，同时不会被 offset 影响位置。
    private let decorateContent: ((AnyView) -> AnyView)?
    
    // 普通展示不需要额外装饰，直接走默认 layout 流程。
    public init(text: Binding<String>, layoutModel: Binding<CJTextLayoutModel>) {
        self._text = text
        self._layoutModel = layoutModel
        self.decorateContent = nil
    }

    // 编辑态展示可以在这里插入 `.addGR(...)` 等能力。
    // 这个闭包会被传给 View.layout(...)，插入点在“内容盒子之后、位置偏移之前”。
    public init<DecoratedContent: View>(
        text: Binding<String>,
        layoutModel: Binding<CJTextLayoutModel>,
        @ViewBuilder decorateContent: @escaping (AnyView) -> DecoratedContent
    ) {
        self._text = text
        self._layoutModel = layoutModel
        self.decorateContent = { content in
            AnyView(decorateContent(content))
        }
    }
    
    public var body: some View {
        let textView = Text(text)
            .property(layoutModel)
//            .overlay(content: {
////                        CJGRCornerView(zoom: 2)
//                Rectangle()
//                    .stroke(Color.black, lineWidth: text == "纪念1" ? 2 * 2 : 0)  // 添加蓝色的边框
//                    .padding(-2 * 2)
//            })
        
        if let overlayView = layoutModel.overlay?.colorModel?.linearGradientColor {
            if let decorateContent {
                textView
                    // 渐变文本也要通过 layout 的装饰闭包插入编辑态能力，避免边框尺寸或位置不准。
                    .layout(layoutModel, overlayView: overlayView, decorateContent: decorateContent)
            } else {
                textView
                    .layout(layoutModel, overlayView: overlayView)
            }
        } else {
            if let decorateContent {
                textView
                    // 普通文本同样把装饰交给 layout 内部处理，而不是在 CJTextView 外层直接叠加。
                    .layout(layoutModel, decorateContent: decorateContent)
            } else {
                textView
                    .layout(layoutModel)
            }
        }
    }
}
