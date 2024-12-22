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
        
        if let overlayView = layoutModel.overlay?.colorModel?.linearGradientColor {
            textView
                .layout(layoutModel, overlayView: overlayView)
        } else {
            textView
                .layout(layoutModel)
        }
    }
}
