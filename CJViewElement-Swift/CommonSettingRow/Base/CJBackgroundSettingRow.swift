//
//  CJBackgroundSettingRow.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/12/15.
//

import SwiftUI

public struct CJBackgroundSettingRow: View {
    public let models: [CJTextColorDataModel]
    public var originalBackgroundModel: CJBoxDecorationModel
    @State var currentBackgroundModel: CJBoxDecorationModel = CJBoxDecorationModel()
    @State var paletteSelectedColor: Color = .clear  // 调色板上选中的颜色
    
    @State var selectedIndex: Int?
    public var onChangeOfBackgroundModel: ((_ newBackgroundModel: CJBoxDecorationModel) -> Void)
    
    public init(models: [CJTextColorDataModel], originalBackgroundModel: CJBoxDecorationModel, onChangeOfBackgroundModel: @escaping (_: CJBoxDecorationModel) -> Void) {
        self.models = models
        self.originalBackgroundModel = originalBackgroundModel
//        self.currentBackgroundModel = currentBackgroundModel
//        self.paletteSelectedColor = paletteSelectedColor
//        self.selectedIndex = selectedIndex
        self.onChangeOfBackgroundModel = onChangeOfBackgroundModel
    }
    
    // MARK: View
    public var body: some View {
        ZStack{
            VStack(alignment: .center, spacing: 0) {
                CJSettingTitleRow(title: "背景颜色", showRecoverIcon: .constant(true)) {
                    currentBackgroundModel = originalBackgroundModel
                }.padding(.leading, 21)
                
                backgroundScrollView
            }
            .frame(width: UIScreen.main.bounds.width, height: 80)
        }
        .onChange(of: paletteSelectedColor) { oldValue, newValue in
            if newValue == .clear {
                return
            }
            currentBackgroundModel.colorModel = CJTextColorDataModel(id: "8888", solidColorString: newValue.toHex(includeAlpha: false) ?? "")
        }
        .onAppear(perform: {
            selectedIndex = models.firstIndex(where: { $0.id == currentBackgroundModel.id }) ?? -1
            if currentBackgroundModel.colorModel?.colorStrings.count == 2 {
                let colorStrings = currentBackgroundModel.colorModel!.colorStrings
                if colorStrings[0] == colorStrings[1] {
                    paletteSelectedColor = Color(hex: colorStrings[0])
                }
            }
        })
    }
    
    /// 颜色滚动视图
    var backgroundScrollView: some View {
        var colorModels: [CJTextColorDataModel] = []
        for (index, colorModel) in models.enumerated() {
            colorModels.append(colorModel)
        }
        
        return CJColorScrollView(colorModels: colorModels, currentColorModel: currentBackgroundModel.colorModel ?? CJTextColorDataModel(), onChangeOfColorModel: { newColorModel in
            currentBackgroundModel = CJBoxDecorationModel(colorModel: newColorModel)
            
            selectedIndex = models.firstIndex(where: { $0.id == newColorModel.id }) ?? -1
            
            onChangeOfBackgroundModel(currentBackgroundModel)
        })
    }
    
    // MARK: Event
    
}
