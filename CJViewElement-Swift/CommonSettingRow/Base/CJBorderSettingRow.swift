//
//  CJBorderSettingRow.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/12/15.
//

import SwiftUI

public struct CJBorderSettingRow: View {
    var contentPadding: EdgeInsets
    
    public let models: [CJBorderDataModel]
    @Binding var currentBorderModel: CJBorderDataModel
    
    @State var selectedIndex: Int?
    public var onChangeOfBorderModel: ((_ newBorderModel: CJBorderDataModel) -> Void)
    
    @State private var originalBorderModel: CJBorderDataModel?
    public init(
        contentPadding: EdgeInsets = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0),
        models: [CJBorderDataModel],
        currentBorderModel: Binding<CJBorderDataModel>,
        onChangeOfBorderModel: @escaping (_: CJBorderDataModel) -> Void
    ) {
        self.contentPadding = contentPadding
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
                CJSettingTitleRow(title: "边框", showRecoverIcon: .constant(currentBorderModel != originalBorderModel)) {
                    guard let originalBorderModel = originalBorderModel else {
                        return
                    }
                    currentBorderModel = originalBorderModel.copy()
                    selectedIndex = models.firstIndex(where: { $0.id == currentBorderModel.id }) ?? -1
                    onChangeOfBorderModel(currentBorderModel.copy())
                }
                .padding(.leading, contentPadding.leading)
                
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
        
        return CJBorderScrollView(
            contentPadding: contentPadding,
            borderModels: borderModels,
            currentBorderModel: $currentBorderModel,
            onChangeOfBorderModel: { newBorderModel in
                currentBorderModel = newBorderModel.copy()
                
                selectedIndex = models.firstIndex(where: { $0.id == currentBorderModel.id }) ?? -1
                
                onChangeOfBorderModel(currentBorderModel.copy())
            }
        )
    }
    
    // MARK: Event
    
}
