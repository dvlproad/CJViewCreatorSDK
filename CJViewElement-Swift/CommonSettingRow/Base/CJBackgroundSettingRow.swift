//
//  CJBackgroundSettingRow.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/12/15.
//
//  CJBackgroundSettingRow 改为和 CJTextsSettingView 一样的使用方法，未来可支持像其一样的复杂使用

import SwiftUI

public struct CJBackgroundSettingRow: View {
    public let models: [CJTextColorDataModel]
    @Binding var currentBackgroundModel: CJBoxDecorationModel
    
    @State var selectedIndex: Int?
    public var onChangeOfBackgroundModel: ((_ newBackgroundModel: CJBoxDecorationModel) -> Void)
    
    @State private var originalBackgroundModel: CJBoxDecorationModel?
    public init(models: [CJTextColorDataModel], currentBackgroundModel: Binding<CJBoxDecorationModel>, onChangeOfBackgroundModel: @escaping (_: CJBoxDecorationModel) -> Void) {
        self.models = models
        self._currentBackgroundModel = currentBackgroundModel
        self._originalBackgroundModel = State(initialValue: currentBackgroundModel.wrappedValue.copy())
        
//        self.selectedIndex = selectedIndex
        self.onChangeOfBackgroundModel = onChangeOfBackgroundModel
    }
    
    // MARK: View
    public var body: some View {
        ZStack{
            VStack(alignment: .center, spacing: 0) {
                CJSettingTitleRow(title: "背景颜色", showRecoverIcon: .constant(true)) {
                    guard let originalBackgroundModel = originalBackgroundModel else {
                        return
                    }
                    currentBackgroundModel = originalBackgroundModel.copy()
                    selectedIndex = models.firstMatchingColorIndex(currentBackgroundModel.colorModel)
                    onChangeOfBackgroundModel(currentBackgroundModel.copy())
                }.padding(.leading, 21)
                
                backgroundScrollView
            }
            .frame(width: UIScreen.main.bounds.width, height: 80)
        }
        .onAppear(perform: {
            selectedIndex = models.firstMatchingColorIndex(currentBackgroundModel.colorModel)
        })
    }
    
    /// 颜色滚动视图
    var backgroundScrollView: some View {
        var colorModels: [CJTextColorDataModel] = []
        for (index, colorModel) in models.enumerated() {
            colorModels.append(colorModel)
        }
        
        return CJColorScrollView(
            colorModels: colorModels,
            currentColorModel: Binding(
                get: { currentBackgroundModel.colorModel ?? CJTextColorDataModel() },
                set: { newColorModel in
                    currentBackgroundModel = currentBackgroundModel.withColorModel(newColorModel.copy())
                }
            ),
            onChangeOfColorModel: { newColorModel in
                selectedIndex = models.firstMatchingColorIndex(newColorModel)
                onChangeOfBackgroundModel(currentBackgroundModel.copy())
            }
        )
    }
    
    // MARK: Event
    
}
