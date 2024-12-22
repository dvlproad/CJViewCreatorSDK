//
//  CJSquareView.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/8/13.
//
//  画布

import SwiftUI
import WidgetKit
import CJViewElement_Swift

struct CJSquareView: View {
    @Binding var backgroundModel: CJBoxDecorationModel
    @Binding var anyComponentModel: CJAllComponentConfigModel
    @Binding var borderModel: CJBorderDataModel
    var widgetFamily: WidgetFamily
    @Binding var dealUpdateUI: Int  // 为了不对model中的属性加修饰词，所以额外使用此变量
 
    var body: some View {
        ZStack {
            Color.red // 背景色
                .edgesIgnoringSafeArea(.all)
            
            GeometryReader { geometry in
                let designSize = widgetFamily.designSize
                
                CJSquareSubView(
                    backgroundModel: $backgroundModel,
                    anyComponentModel: $anyComponentModel,
                    borderModel: $borderModel,
                    widgetFamily: widgetFamily,
                    dealUpdateUI: $dealUpdateUI
                )
                .frame(width: designSize.width, height: designSize.height)
                .cornerRadius(widgetFamily.getCornerRadius())
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2) // 视图居中
            }
        }
    }
}
