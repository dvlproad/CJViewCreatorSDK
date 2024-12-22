//
//  CJColorPickerIcon.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/12/18.
//

import Foundation
import SwiftUI

public struct CJColorPickerIcon: View {
    @Binding var paletteSelectedColor: Color    // 调色板上选中的颜色
    @Binding var showPalette: Bool
    
    public var body: some View {
        ZStack {
            ColorPicker("颜色", selection: $paletteSelectedColor, supportsOpacity: false)
                .frame(width: 30,height: 30)
                .offset(x: -4)
                .overlay(
                    Image("colorPalette")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: showPalette ? 30 : 0, height: showPalette ? 30 : 0)
                        .allowsHitTesting(false)
                )
        }
    }
}
