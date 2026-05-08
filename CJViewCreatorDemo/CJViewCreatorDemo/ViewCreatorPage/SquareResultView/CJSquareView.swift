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
    @Binding var anyComponentModel: CJAllComponentConfigModel
    var widgetFamily: WidgetFamily
    @Binding var dealUpdateUI: Int  // 工具区修改模型后，通知预览区刷新。
    @Binding var toolUpdateUI: Int  // 预览区手势修改模型后，通知工具区刷新。
 
    var body: some View {
        ZStack {
            Color.red // 背景色
                .edgesIgnoringSafeArea(.all)
            
            GeometryReader { geometry in
                let designSize = widgetFamily.designSize
                
                CJSquareSubView(
                    anyComponentModel: $anyComponentModel,
                    widgetFamily: widgetFamily,
                    dealUpdateUI: $dealUpdateUI,
                    toolUpdateUI: $toolUpdateUI
                )
                .frame(width: designSize.width, height: designSize.height)
                .cornerRadius(widgetFamily.getCornerRadius())
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2) // 视图居中
            }
        }
    }
}
