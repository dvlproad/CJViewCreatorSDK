//
//  CJTextColorSettingRow.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/12/15.
//

import SwiftUI

public struct CJTextColorSettingRow: View {
    public let models: [CJTextColorDataModel]
    public var originalTextColorModel: CJTextColorDataModel
    @State var currentTextColorModel: CJTextColorDataModel = CJTextColorDataModel()
    @State var paletteSelectedColor: Color = .clear  // 调色板上选中的颜色
    
    
    @State var selectedIndex: Int?
    public var onChangeOfTextColorModel: ((_ newTextColorModel: CJTextColorDataModel) -> Void)
    
    public init(models: [CJTextColorDataModel], originalTextColorModel: CJTextColorDataModel, onChangeOfTextColorModel: @escaping (_: CJTextColorDataModel) -> Void) {
        self.models = models
        self.originalTextColorModel = originalTextColorModel
//        self.currentTextColorModel = currentTextColorModel
//        self.paletteSelectedColor = paletteSelectedColor
//        self.selectedIndex = selectedIndex
        self.onChangeOfTextColorModel = onChangeOfTextColorModel
    }
    
    // MARK: View
    public var body: some View {
        ZStack{
            VStack(alignment: .center, spacing: 0) {
                CJSettingTitleRow(title: "字体颜色", showRecoverIcon: .constant(true)) {
                    currentTextColorModel = originalTextColorModel
                }.padding(.leading, 21)
                
                colorScrollView
            }
            .frame(width: UIScreen.main.bounds.width, height: 80)
        }
        .onChange(of: paletteSelectedColor) { oldValue, newValue in
            if newValue == .clear {
                return
            }
            currentTextColorModel = CJTextColorDataModel(id: "8888", solidColorString: newValue.toHex(includeAlpha: false) ?? "")
        }
        .onAppear(perform: {
            selectedIndex = models.firstIndex(where: { $0.id == currentTextColorModel.id }) ?? -1
//            if currentTextColorModel.colorModel?.colorStrings.count == 2 {
//                let colorStrings = currentTextColorModel.colorModel!.colorStrings
//                if colorStrings[0] == colorStrings[1] {
//                    paletteSelectedColor = Color(hex: colorStrings[0])
//                }
//            }
        })
    }
    
    /// 颜色滚动视图
    var colorScrollView: some View {
        var colorModels: [CJTextColorDataModel] = []
        for (index, colorModel) in models.enumerated() {
            colorModels.append(colorModel)
        }
        
        return CJColorScrollView(colorModels: colorModels, currentColorModel: currentTextColorModel, onChangeOfColorModel: { newColorModel in
            currentTextColorModel = newColorModel
            
            selectedIndex = models.firstIndex(where: { $0.id == newColorModel.id }) ?? -1
            
            onChangeOfTextColorModel(currentTextColorModel)
        })
    }
    
    // MARK: Event
    
}
