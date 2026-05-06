//
//  CJColorScrollView.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/12/15.
//

import Foundation
import SwiftUI

public struct CJColorScrollView: View {
    public var colorModels: [CJTextColorDataModel]
    @Binding public var currentColorModel: CJTextColorDataModel
    public var onChangeOfColorModel: ((_ newColorModel: CJTextColorDataModel) -> Void)
    
    @State var paletteSelectedColor: Color = .clear  // 调色板上选中的颜色
    @State var showPalette: Bool = false
    @State var selectedIndex: Int?
    
    public init(colorModels: [CJTextColorDataModel], currentColorModel: Binding<CJTextColorDataModel>, onChangeOfColorModel: @escaping (_: CJTextColorDataModel) -> Void) {
        self.colorModels = colorModels
        self._currentColorModel = currentColorModel
        self.onChangeOfColorModel = onChangeOfColorModel
    }
    
    
    // MARK: View
    public var body: some View {
        ScrollViewReader { scrollView in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 10) {
                    CJColorPickerIcon(paletteSelectedColor: $paletteSelectedColor, showPalette: $showPalette)
                        .frame(width: 30, height: 30)
                    
//                            ForEach(0..<items.count, id:\.self) { index in
//                                let item = items[index].data
                    ForEach(Array(colorModels.enumerated()), id: \.offset) { index, model in
                        CJColorIcon(colorModel: model, isSelected: currentColorModel.id == model.id)
                            .onTapGesture {
                                selectColor(index, colorModel: model)
                            }
                            .id(index)
                    }
                }
                .padding(.horizontal, 21)
                .frame(height: 40)
            }
            .onChange(of: selectedIndex) { oldValue, newValue in
                withAnimation {
                    if let index = newValue {
                        scrollView.scrollTo(index, anchor: .center)
                    }
                }
            }
            .onChange(of: currentColorModel) { oldValue, newValue in
                selectedIndex = colorModels.firstIndex(where: { $0.id == newValue.id }) ?? -1
            }
            .onAppear() {
                selectedIndex = colorModels.firstIndex(where: { $0.id == currentColorModel.id }) ?? -1
                if currentColorModel.colorStrings.count == 2 {
                    let colorStrings = currentColorModel.colorStrings
                    if colorStrings[0] == colorStrings[1] {
                        paletteSelectedColor = Color(hex: colorStrings[0])
                    }
                }
                
                withAnimation {
                    if let index = selectedIndex {
                        scrollView.scrollTo(index, anchor: .center)
                    }
                }
            }
        }
    }
    
    // MARK: Event
    private func selectColor(_ index: Int, colorModel: CJTextColorDataModel) {
        currentColorModel = colorModel
        
        selectedIndex = colorModels.firstIndex(where: { $0.id == colorModel.id }) ?? -1
        
        onChangeOfColorModel(colorModel)
    }
}



public struct CJColorIcon: View {
    var colorModel: CJTextColorDataModel
    var isSelected: Bool
    
    public var body: some View {
        ZStack{
            Rectangle()
                .fill(colorModel.linearGradientColor)
                .contentShape(Rectangle()) // 确保整个区域都是可点击的
                .frame(width: 30, height: 30)
                .cornerRadius(15)
            
            if isSelected {
                Image("check")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 14, height: 10)
            }
        }
    }
}

// MARK: - Preview
struct Preview_CJColorIcon: PreviewProvider {
    static var previews: some View {
        let colorModel = CJTextColorDataModel(id: "", startPoint: .top, endPoint: .bottom, colorStrings: ["#1F625B","#7CB1AF"])
        CJColorIcon(colorModel: colorModel, isSelected: false)
    }
}
