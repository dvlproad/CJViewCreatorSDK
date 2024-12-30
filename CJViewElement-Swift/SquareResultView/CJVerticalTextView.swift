//
//  CJTextsView.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/12/15.
//  竖直对联 = 此视图+限制字数

import SwiftUI

public struct CJVerticalTextView: View {
    let text: String
    let font: Font
    let height: CGFloat
    
    public init(text: String, font: Font, height: CGFloat) {
        self.text = text
        self.font = font
        self.height = height
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<text.count, id: \.self) { index in
                let character = text[text.index(text.startIndex, offsetBy: index)]
                Text(String(character))
                    .font(font)
                    //.background(Color.randomColor)
                if index != text.count - 1 {
                    Spacer()
                }
            }
        }
        .frame(height: height)  // 必须限制大小，不然可能高度够显示时候，Spacer可能比较小，而导致最后的高度不是你要的高度
        //.background(Color.blue)
    }
    
}
