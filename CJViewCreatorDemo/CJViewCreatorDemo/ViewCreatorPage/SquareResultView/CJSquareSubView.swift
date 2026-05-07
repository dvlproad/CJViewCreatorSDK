//
//  CJSquareSubView.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/9/21.
//

import SwiftUI
import WidgetKit
import CJViewElement_Swift

struct CJSquareSubView: View {
    @Binding var anyComponentModel: CJAllComponentConfigModel
    var widgetFamily: WidgetFamily
    @Binding var dealUpdateUI: Int  // 为了不对model中的属性加修饰词，所以额外使用此变量

    var body: some View {
        GeometryReader(content: { geometry in
            CJBackgroundView(backgroundModel: $anyComponentModel.backgroundModel, dealUpdateUI: $dealUpdateUI)
            
            CJTextsView(anyComponentModel: $anyComponentModel, dealUpdateUI: $dealUpdateUI)

            CJBorderView(
                borderModel: $anyComponentModel.borderModel,
                cornerRadius: widgetFamily.getCornerRadius(),
                makeupBorderNameBlock: { borderPrefixImageName in
                    let borderImageName = widgetFamily.makeupBorderName(borderPrefixImageName)
                    return borderImageName
                },
                dealUpdateUI: $dealUpdateUI
            )
            .frame(width: geometry.size.width, height: geometry.size.height)
        })
        .onAppear() {
            
        }
    }
}
