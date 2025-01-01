//
//  CJTextsView.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/12/15.
//

import SwiftUI

extension String {
    /// 截取字符串的前 n 个字符
    func prefix(_ length: Int) -> String {
        guard length > 0 else { return "" } // 如果长度为 0 或负数，返回空字符串
        guard length < self.count else { return self } // 如果长度超过字符串长度，返回完整字符串
        let endIndex = self.index(self.startIndex, offsetBy: length)
        return String(self[self.startIndex..<endIndex])
    }
    
    /// 截取字符串的后 n 个字符
    func suffix(_ length: Int) -> String {
        guard length > 0 else { return "" }
        guard length < self.count else { return self }
        let startIndex = self.index(self.endIndex, offsetBy: -length)
        return String(self[startIndex..<self.endIndex])
    }
}

public struct CJVEVerticalTextView: View {
    @Binding var text: String
    @Binding var maxLines: Int  // 竖直对联的时候经常需要限制字数，避免越输越长
    @Binding var layoutModel: CJTextLayoutModel
    
    public init(text: Binding<String>, maxLines: Binding<Int>, layoutModel: Binding<CJTextLayoutModel>) {
        self._text = text
        self._maxLines = maxLines
        self._layoutModel = layoutModel
    }
    

    var font: Font {
        let property = layoutModel
        if property.font.name.count == 0 {
            return .system(size: property.fontSize, weight: property.fontWeight.toFontWeight)
        } else {
            return .custom(property.font.name, fixedSize: property.fontSize)
        }
    }
    
    var validShowingText: String {
        return text.prefix(maxLines)
    }
    
    public var body: some View {
        let textView = CJVerticalTextView(
            text: validShowingText,
            font: font, 
            minimumScaleFactor: layoutModel.minimumScaleFactor,
            height: layoutModel.height
        )
        
        if let overlayView = layoutModel.overlay?.colorModel?.linearGradientColor {
            textView
                .layout(layoutModel, overlayView: overlayView)
        } else {
            textView
                .layout(layoutModel)
        }
    }
}
