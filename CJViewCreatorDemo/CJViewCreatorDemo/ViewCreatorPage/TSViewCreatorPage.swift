//
//  TSViewCreatorPage.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/12/16.
//

import Foundation
import SwiftUI
import WidgetKit
import CJViewElement_Swift


struct TSViewCreatorPage: View {
    @State var model: CQWidgetModel = CQWidgetModel("countdown_middle_3_123_children")
    @State var anyComponentModel: CJAllComponentConfigModel = CJAllComponentConfigModel()
    @State var dealUpdateUI: Int = 0    // 工具区修改模型后，通知预览区刷新。
    @State var toolUpdateUI: Int = 0    // 预览区手势修改模型后，通知工具区刷新。

    var body: some View {
        GeometryReader(content: { geometry in
            NavigationView {
                VStack(alignment: .leading, spacing: 0) {
                    CJSquareView(
                        anyComponentModel: $anyComponentModel,
                        widgetFamily: WidgetFamily.systemMedium,
                        dealUpdateUI: $dealUpdateUI,
                        toolUpdateUI: $toolUpdateUI
                    )
                    .frame(width: geometry.size.width, height: 200)
                    
                    CJToolView(model: $model, toolUpdateUI: $toolUpdateUI, onChangeOfElementModel:{ newElementModel in
                        anyComponentModel = newElementModel.anyComponentModel
                        dealUpdateUI = dealUpdateUI + 1
                    })
                }
            }
        }).onAppear(){
            model = CQWidgetModel("countdown_middle_3_123_children")
            anyComponentModel = model.anyComponentModel
        }
    }
}
