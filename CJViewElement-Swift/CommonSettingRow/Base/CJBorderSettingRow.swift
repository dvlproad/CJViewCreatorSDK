//
//  CJBorderSettingRow.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/12/15.
//

import SwiftUI

public struct CJBorderSettingRow: View {
    public let models: [CJBorderDataModel]
    public var originalBorderModel: CJBorderDataModel
    @State var currentBorderModel: CJBorderDataModel = CJBorderDataModel()
    @State var paletteSelectedColor: Color = .clear  // 调色板上选中的颜色
    
    
    @State var selectedIndex: Int?
    public var onChangeOfBorderModel: ((_ newBorderModel: CJBorderDataModel) -> Void)
    
    public init(models: [CJBorderDataModel], originalBorderModel: CJBorderDataModel, onChangeOfBorderModel: @escaping (_: CJBorderDataModel) -> Void) {
        self.models = models
        self.originalBorderModel = originalBorderModel
//        self.currentBorderModel = currentBorderModel
//        self.paletteSelectedColor = paletteSelectedColor
//        self.selectedIndex = selectedIndex
        self.onChangeOfBorderModel = onChangeOfBorderModel
    }
    
    // MARK: View
    public var body: some View {
        ZStack{
            VStack(alignment: .center, spacing: 0) {
                CJSettingTitleRow(title: "边框", showRecoverIcon: .constant(true)) {
                    currentBorderModel = originalBorderModel
                }.padding(.leading, 21)
                
                borderScrollView
            }
            .frame(width: UIScreen.main.bounds.width, height: 80)
        }
        .onChange(of: paletteSelectedColor) { oldValue, newValue in
            if newValue == .clear {
                return
            }
            //currentBorderModel.colorModel = CJTextColorDataModel(id: "8888", solidColorString: newValue.toHex(includeAlpha: false) ?? "")
        }
        .onAppear(perform: {
            selectedIndex = models.firstIndex(where: { $0.id == currentBorderModel.id }) ?? -1
//            if currentBorderModel.colorModel?.colorStrings.count == 2 {
//                let colorStrings = currentBorderModel.colorModel!.colorStrings
//                if colorStrings[0] == colorStrings[1] {
//                    paletteSelectedColor = Color(hex: colorStrings[0])
//                }
//            }
        })
    }
    
    /// 颜色滚动视图
    var borderScrollView: some View {
        var borderModels: [CJBorderDataModel] = []
        for (index, borderModel) in models.enumerated() {
            borderModels.append(borderModel)
        }
        
        return CJBorderScrollView(borderModels: borderModels, currentBorderModel: currentBorderModel, onChangeOfBorderModel: { newBorderModel in
            currentBorderModel = newBorderModel
            
            selectedIndex = models.firstIndex(where: { $0.id == newBorderModel.id }) ?? -1
            
            onChangeOfBorderModel(currentBorderModel)
        })
    }
    
    // MARK: Event
    
}
