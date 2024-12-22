//
//  CJBorderScrollView.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/12/18.
//

import Foundation
import SwiftUI

public struct CJBorderScrollView: View {
    public var borderModels: [CJBorderDataModel]
    @State public var currentBorderModel: CJBorderDataModel
    public var onChangeOfBorderModel: ((_ newBorderModel: CJBorderDataModel) -> Void)
    
    @State var paletteSelectedColor: Color = .clear  // 调色板上选中的颜色
    @State var showPalette: Bool = false
    @State var selectedIndex: Int?
    
    public init(borderModels: [CJBorderDataModel], currentBorderModel: CJBorderDataModel, onChangeOfBorderModel: @escaping (_: CJBorderDataModel) -> Void) {
        self.borderModels = borderModels
        self.currentBorderModel = currentBorderModel
        self.onChangeOfBorderModel = onChangeOfBorderModel
    }
    
    // MARK: View
    public var body: some View {
        ScrollViewReader { scrollView in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 10) {
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
                    }.frame(width: 30,height: 30)
                    
//                            ForEach(0..<items.count, id:\.self) { index in
//                                let item = items[index].data
                    ForEach(Array(borderModels.enumerated()), id: \.offset) { index, model in
                        CJBorderIcon(borderImageName: model.imageName, isSelected: currentBorderModel.id == model.id)
                            .onTapGesture {
                                tapColor(index, colorModel: model)
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
                selectedIndex = borderModels.firstIndex(where: { $0.id == currentBorderModel.id }) ?? -1
//                if currentBorderModel.colorStrings.count == 2 {
//                    let colorStrings = currentBorderModel.colorStrings
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
    private func tapColor(_ index: Int, colorModel: CJBorderDataModel) {
        currentBorderModel = colorModel
        
        selectedIndex = borderModels.firstIndex(where: { $0.id == colorModel.id }) ?? -1
        
        onChangeOfBorderModel(colorModel)
    }
}


public struct CJBorderIcon: View {
    var borderImageName: String
    var isSelected: Bool
    
    public var body: some View{
        ZStack{
            Image(borderImageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 38,height: 38)
            if isSelected {
                Image("check")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 14,height: 10)
            }
        }
    }
}
