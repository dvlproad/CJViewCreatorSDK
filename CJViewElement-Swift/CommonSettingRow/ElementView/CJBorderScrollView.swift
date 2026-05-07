//
//  CJBorderScrollView.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/12/15.
//

import Foundation
import SwiftUI

public struct CJBorderScrollView: View {
    public var borderModels: [CJBorderDataModel]
    @Binding public var currentBorderModel: CJBorderDataModel
    public var onChangeOfBorderModel: ((_ newBorderModel: CJBorderDataModel) -> Void)
    
    @State var paletteSelectedColor: Color = .clear  // 调色板上选中的颜色
    @State var showPalette: Bool = false
    @State var selectedIndex: Int?
    
    public init(borderModels: [CJBorderDataModel], currentBorderModel: Binding<CJBorderDataModel>, onChangeOfBorderModel: @escaping (_: CJBorderDataModel) -> Void) {
        self.borderModels = borderModels
        self._currentBorderModel = currentBorderModel
        if let borderColorString = currentBorderModel.wrappedValue.borderColorString, !borderColorString.isEmpty {
            self._paletteSelectedColor = State(initialValue: Color(hex: borderColorString))
        }
        self.onChangeOfBorderModel = onChangeOfBorderModel
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
                    ForEach(Array(borderModels.enumerated()), id: \.offset) { index, model in
                        CJBorderIcon(borderImageName: model.imageName ?? "", isSelected: currentBorderModel.id == model.id)
                            .onTapGesture {
                                tapColor(index, colorModel: model)
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
            .onChange(of: currentBorderModel) { oldValue, newValue in
                selectedIndex = borderModels.firstIndex(where: { $0.id == newValue.id }) ?? -1
            }
            .onChange(of: paletteSelectedColor) { oldValue, newValue in
                if newValue == .clear {
                    return
                }
                let borderModel = CJBorderDataModel(
                    id: "8888",
                    imageName: nil,
                    borderColorString: newValue.toHex(includeAlpha: false) ?? ""
                )
                currentBorderModel = borderModel
                selectedIndex = -1
                onChangeOfBorderModel(borderModel.copy())
            }
            .onAppear() {
                selectedIndex = borderModels.firstIndex(where: { $0.id == currentBorderModel.id }) ?? -1
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
        currentBorderModel = colorModel.copy()
        
        selectedIndex = borderModels.firstIndex(where: { $0.id == colorModel.id }) ?? -1
        
        onChangeOfBorderModel(colorModel.copy())
    }
}


public struct CJBorderIcon: View {
    var borderImageName: String
    var isSelected: Bool
    
    public var body: some View {
        ZStack {
            Image(borderImageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 38, height: 38)
            if isSelected {
                Image("check")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 14, height: 10)
            }
        }
    }
}
