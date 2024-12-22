//
//  CJTextsView.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/11/27.
//

import Foundation
import SwiftUI
import WidgetKit
import CJViewElement_Swift

struct CJTextsView: View {
    @Binding var anyComponentModel: CJAllComponentConfigModel
//    @Binding var textModels: [TextsModel]
//    @State private var textModels: [CJTextLayoutModel] = []
    @Binding var dealUpdateUI: Int  // 为了不对model中的属性加修饰词，所以额外使用此变量
    @State private var textModels: [CJTextLayoutModel] = []  // 使用 @State 保存 textModels

    var body: some View {
        GeometryReader(content: { geometry in
            // 获取动态的 textModels
            let updatedTextModels = self.textModels // 这会是一个动态更新的副本
            
            // 在 ForEach 中使用 index 来获取绑定
            ForEach(0..<updatedTextModels.count, id: \.self) { index in
//                let textModel = textModels[index]
                //                Text(textModel.text)
                CJTextView(text: $textModels[index].text, layoutModel: $textModels[index])
            }
        })
        .onAppear {
            // 在视图出现时更新 textModels，确保它从 anyComponentModel 获取数据
            self.textModels = self.anyComponentModel.getAllLayoutModels()
        }
        .onChange(of: anyComponentModel) { oldValue, newValue in
            // 如果 anyComponentModel 改变，也要更新 textModels
            self.textModels = newValue.getAllLayoutModels()
        }
        .onChange(of: dealUpdateUI) { oldValue, newValue in
            // 如果 anyComponentModel 改变，也要更新 textModels
            self.textModels = self.anyComponentModel.getAllLayoutModels()
        }
    }
    
    // 将 textModels 改为计算属性
//    private var textModels: [CJTextLayoutModel] {
//        let allTextModels: [CJTextLayoutModel] = anyComponentModel.getAllLayoutModels()
//        
//        return allTextModels
//    }
}

/*
// MARK: 预览 CJTextsView
struct CJTextsView_Previews: PreviewProvider {
    static var previews: some View {
        let family: WidgetFamily = .systemMedium
        var width: CGFloat = 166.0
        if family == .systemMedium {
            width = 333.0
        }
        
        let model = CQWidgetModel()

        let textModels: [CJTextLayoutModel]? = TSRowDataUtil.getTextModels(thingCount: 3, family: family)
        model.text.texts = textModels ?? [CJTextLayoutModel()]
        

        return CJTextsView()
            .environmentObject(model)
            .frame(width: width, height: 166)
            .backgroundColor(Color(hex: "#B1B6E5"))
    }
}
*/
