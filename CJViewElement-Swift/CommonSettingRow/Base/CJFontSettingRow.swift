//
//  CJFontSettingRow.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/12/15.
//

import SwiftUI
import CJViewElement_Swift

public struct CJFontSettingRow: View {
    public let models: [CJFontDataModel]
    public var originalFontModel: CJFontDataModel
    @State var currentFontModel: CJFontDataModel = CJFontDataModel()
    @State var paletteSelectedColor: Color = .clear  // 调色板上选中的颜色
    
    
    @State var selectedIndex: Int?
    public var onChangeOfFontModel: ((_ newFontModel: CJFontDataModel) -> Void)
    
    public init(models: [CJFontDataModel], originalFontModel: CJFontDataModel, onChangeOfFontModel: @escaping (_: CJFontDataModel) -> Void) {
        self.models = models
        self.originalFontModel = originalFontModel
//        self.currentFontModel = currentFontModel
//        self.paletteSelectedColor = paletteSelectedColor
//        self.selectedIndex = selectedIndex
        self.onChangeOfFontModel = onChangeOfFontModel
    }
    
    // MARK: View
    public var body: some View {
        ZStack{
            VStack(alignment: .center, spacing: 0) {
                CJSettingTitleRow(title: "字体", showRecoverIcon: .constant(true)) {
                    currentFontModel = originalFontModel
                }.padding(.leading, 21)
                
                fontScrollView
            }
            .frame(width: UIScreen.main.bounds.width, height: 80)
        }
        .onChange(of: paletteSelectedColor) { oldValue, newValue in
            if newValue == .clear {
                return
            }
//            currentFontModel = CJFontDataModel(id: "8888", solidColorString: newValue.toHex(includeAlpha: false) ?? "")
        }
        .onAppear(perform: {
            selectedIndex = models.firstIndex(where: { $0.id == currentFontModel.id }) ?? -1
//            if currentFontModel.colorModel?.colorStrings.count == 2 {
//                let colorStrings = currentFontModel.colorModel!.colorStrings
//                if colorStrings[0] == colorStrings[1] {
//                    paletteSelectedColor = Color(hex: colorStrings[0])
//                }
//            }
        })
    }
    
    /// 颜色滚动视图
    var fontScrollView: some View {
        var fontModels: [CJFontDataModel] = []
        for (index, fontModel) in models.enumerated() {
            fontModels.append(fontModel)
        }
        
        return CJFontScrollView(fontModels: fontModels, currentFontModel: currentFontModel, onChangeOfFontModel: { newFontModel in
            currentFontModel = newFontModel
            
            selectedIndex = models.firstIndex(where: { $0.id == newFontModel.id }) ?? -1
            
            onChangeOfFontModel(currentFontModel)
        })
    }
    
    // MARK: Event
    
}


