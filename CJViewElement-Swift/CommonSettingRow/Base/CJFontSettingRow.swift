//
//  CJFontSettingRow.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/12/15.
//

import SwiftUI

public struct CJFontSettingRow: View {
    var contentPadding: EdgeInsets
    
    public let models: [CJFontDataModel]
    @Binding var currentFontModel: CJFontDataModel
    
    @State var selectedIndex: Int?
    public var onChangeOfFontModel: ((_ newFontModel: CJFontDataModel) -> Void)
    
    @State private var originalFontModel: CJFontDataModel?
    public init(
        contentPadding: EdgeInsets = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0),
        models: [CJFontDataModel],
        currentFontModel: Binding<CJFontDataModel>,
        onChangeOfFontModel: @escaping (_: CJFontDataModel) -> Void
    ) {
        self.contentPadding = contentPadding
        self.models = models
        self._currentFontModel = currentFontModel
        self._originalFontModel = State(initialValue: currentFontModel.wrappedValue.copy())
//        self.selectedIndex = selectedIndex
        self.onChangeOfFontModel = onChangeOfFontModel
    }
    
    // MARK: View
    public var body: some View {
        ZStack{
            VStack(alignment: .center, spacing: 0) {
                CJSettingTitleRow(title: "字体", showRecoverIcon: .constant(currentFontModel != originalFontModel)) {
                    guard let originalFontModel = originalFontModel else {
                        return
                    }
                    currentFontModel = originalFontModel.copy()
                    onChangeOfFontModel(currentFontModel.copy())
                }
                .padding(.leading, contentPadding.leading)
                
                fontScrollView
            }
            .frame(width: UIScreen.main.bounds.width, height: 80)
        }
        .onAppear(perform: {
            selectedIndex = models.firstIndex(where: { $0.id == currentFontModel.id }) ?? -1
        })
    }
    
    /// 颜色滚动视图
    var fontScrollView: some View {
        var fontModels: [CJFontDataModel] = []
        for (index, fontModel) in models.enumerated() {
            fontModels.append(fontModel)
        }
        
        return CJFontScrollView(
            contentPadding: contentPadding,
            fontModels: fontModels,
            currentFontModel: $currentFontModel,
            onChangeOfFontModel: { newFontModel in
                currentFontModel = newFontModel.copy()
            
                selectedIndex = models.firstIndex(where: { $0.id == currentFontModel.id }) ?? -1
                
                onChangeOfFontModel(currentFontModel.copy())
            }
        )
    }
    
    // MARK: Event
    
}

