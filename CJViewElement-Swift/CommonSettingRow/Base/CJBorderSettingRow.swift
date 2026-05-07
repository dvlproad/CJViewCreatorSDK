//
//  CJBorderSettingRow.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/12/15.
//

import SwiftUI

public struct CJBorderSettingRow: View {
    public let models: [CJBorderDataModel]
    @Binding var currentBorderModel: CJBorderDataModel
    
    @State var selectedIndex: Int?
    public var onChangeOfBorderModel: ((_ newBorderModel: CJBorderDataModel) -> Void)
    
    @State private var originalBorderModel: CJBorderDataModel?
    public init(models: [CJBorderDataModel], currentBorderModel: Binding<CJBorderDataModel>, onChangeOfBorderModel: @escaping (_: CJBorderDataModel) -> Void) {
        self.models = models
        self._currentBorderModel = currentBorderModel
        self._originalBorderModel = State(initialValue: currentBorderModel.wrappedValue.copy())
//        self.selectedIndex = selectedIndex
        self.onChangeOfBorderModel = onChangeOfBorderModel
    }
    
    // MARK: View
    public var body: some View {
        ZStack{
            VStack(alignment: .center, spacing: 0) {
                CJSettingTitleRow(title: "边框", showRecoverIcon: .constant(true)) {
                    guard let originalBorderModel = originalBorderModel else {
                        return
                    }
                    currentBorderModel = originalBorderModel.copy()
                    selectedIndex = models.firstIndex(where: { $0.id == currentBorderModel.id }) ?? -1
                    onChangeOfBorderModel(currentBorderModel.copy())
                }.padding(.leading, 21)
                
                borderScrollView
            }
            .frame(width: UIScreen.main.bounds.width, height: 80)
        }
        .onAppear(perform: {
            selectedIndex = models.firstIndex(where: { $0.id == currentBorderModel.id }) ?? -1
        })
    }
    
    /// 颜色滚动视图
    var borderScrollView: some View {
        var borderModels: [CJBorderDataModel] = []
        for (index, borderModel) in models.enumerated() {
            borderModels.append(borderModel)
        }
        
        return CJBorderScrollView(borderModels: borderModels, currentBorderModel: $currentBorderModel, onChangeOfBorderModel: { newBorderModel in
            currentBorderModel = newBorderModel.copy()
            
            selectedIndex = models.firstIndex(where: { $0.id == newBorderModel.id }) ?? -1
            
            onChangeOfBorderModel(currentBorderModel.copy())
        })
    }
    
    // MARK: Event
    
}
