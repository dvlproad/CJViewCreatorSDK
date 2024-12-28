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
    
    public init(text: Binding<String>, layoutModel: Binding<CJTextLayoutModel>) {
        self._text = text
        self._layoutModel = layoutModel
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
            textView
                .layout(layoutModel, overlayView: overlayView)
        } else {
            textView
                .layout(layoutModel)
        }
    }
}
