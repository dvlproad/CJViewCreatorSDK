//
//  CJColorScrollView.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/12/15.
//

import Foundation
import SwiftUI

public struct CJFontScrollView: View {
    var fontModels: [CJFontDataModel]
    @State var currentFontModel: CJFontDataModel
    var onChangeOfFontModel: ((_ newFontModel: CJFontDataModel) -> Void)
    
    @State var paletteSelectedColor: Color = .clear  // 调色板上选中的颜色
    @State var showPalette: Bool = false
    @State var selectedIndex: Int?
    
    public init(fontModels: [CJFontDataModel], currentFontModel: CJFontDataModel, onChangeOfFontModel: @escaping (_: CJFontDataModel) -> Void) {
        self.fontModels = fontModels
        self.currentFontModel = currentFontModel
        self.onChangeOfFontModel = onChangeOfFontModel
    }
    
    // MARK: View
    public var body: some View {
        ScrollViewReader { scrollView in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 10) {
//                            ForEach(0..<items.count, id:\.self) { index in
//                                let item = items[index].data
                    ForEach(Array(fontModels.enumerated()), id: \.offset) { index, model in
                        CJFontIcon(fontModel: model, isSelected: currentFontModel.id == model.id)
                            .onTapGesture {
                                tapColor(index, fontModel: model)
                            }
                            .id(index)
                    }
                }
                .padding(.horizontal, 21)
                .frame( height: 40)
            }
            .onChange(of: selectedIndex) { oldValue, newValue in
                withAnimation {
                    if let index = newValue {
                        scrollView.scrollTo(index, anchor: .center)
                    }
                }
            }
            .onAppear() {
                selectedIndex = fontModels.firstIndex(where: { $0.id == currentFontModel.id }) ?? -1
//                if currentFontModel.colorStrings.count == 2 {
//                    let colorStrings = currentFontModel.colorStrings
//                    if colorStrings[0] == colorStrings[1] {
//                        paletteSelectedColor = Color(hex: colorStrings[0])
//                    }
//                }
                
                withAnimation {
                    if let index = selectedIndex {
                        scrollView.scrollTo(index, anchor: .center)
                    }
                }
            }
        }
    }
    
    // MARK: Event
    private func tapColor(_ index: Int, fontModel: CJFontDataModel) {
        currentFontModel = fontModel
        
        selectedIndex = fontModels.firstIndex(where: { $0.id == fontModel.id }) ?? -1
        
        onChangeOfFontModel(fontModel)
    }
}




public struct CJFontIcon: View {
    var fontModel: CJFontDataModel
    var isSelected: Bool
    
    public var body: some View {
        ZStack(alignment: .center){
            if(isSelected){
                Rectangle() // 可以是透明的，用于确保点击事件被捕捉
                 .fill(Color(hex: "#2E2E2E"))
                 .contentShape(Rectangle()) // 确保整个区域都是可点击的
                 .frame(width: 65,height: 28)
                 .cornerRadius(15)
                Image(fontModel.egImage)
                    .resizable()
                    .renderingMode(.template) // 将图片设置为模板模式
                    .foregroundColor(Color.white)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 65,height: 28)
            }else{
                Image(fontModel.egImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 65,height: 28)
            }
        }
        .frame(width: 65,height: 28)
    }
}

#Preview {
    CJFontIcon(fontModel: CJFontDataModel(name: "fontImage_6", egImage: "fontImage_6"), isSelected: false)
}
