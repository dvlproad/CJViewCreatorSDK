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
    @State var backgroundModel: CJBoxDecorationModel = CJBoxDecorationModel(colorModel: CJTextColorDataModel(solidColorString: "#FF0000"))
    @State var anyComponentModel: CJAllComponentConfigModel = CJAllComponentConfigModel()
    @State var borderModel: CJBorderDataModel = CJBorderDataModel()
    @State var dealUpdateUI: Int = 0    // 为了不对model中的属性加修饰词，所以额外使用此变量

    var body: some View {
        GeometryReader(content: { geometry in
            NavigationView {
                VStack(alignment: .leading, spacing: 0) {
                    CJSquareView(
                        backgroundModel: $backgroundModel,
                        anyComponentModel: $anyComponentModel,
                        borderModel: $borderModel,
                        widgetFamily: WidgetFamily.systemMedium,
                        dealUpdateUI: $dealUpdateUI
                    )
                    .frame(width: geometry.size.width, height: 200)
                    
                    CJToolView(model: $model, onChangeOfElementModel:{ newElementModel in
                        backgroundModel = newElementModel.backgroundModel
                        anyComponentModel = newElementModel.anyComponentModel
                        borderModel = newElementModel.borderModel
                        dealUpdateUI = dealUpdateUI + 1
                    })
                }
            }
        }).onAppear(){
            model = CQWidgetModel("countdown_middle_3_123_children")
            backgroundModel = model.backgroundModel
            anyComponentModel = model.anyComponentModel
            borderModel = model.borderModel
        }
    }
}
