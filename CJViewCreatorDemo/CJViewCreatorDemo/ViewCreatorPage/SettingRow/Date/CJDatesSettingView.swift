//
//  CCDatesSetttingView.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/11/25.
//

import Foundation
import SwiftUI
import CJViewElement_Swift

struct CJDatesSettingView: View {
//    @ObservedObject var model: M
    
    var title: String
    var minCount: Int
    var maxCount: Int
    @Binding var dateChooseModels: [CJCommemorationComponentConfigModel]
    @State var currentIndex = -1
//    @State var currentTextDateModel: CJCommemorationDataModel
//    @State var currentTextDateModel: CJCommemorationComponentConfigModel
    var onChangeOfDateChooseModels: ((_ newTextDateModels: [CJCommemorationComponentConfigModel], _ isCountUpdate: Bool) -> Void)
    var actionClosure: ((CJSheetActionType) -> Void)
    
    
    //@State var shouldUpdateDateSettingView = false
    @StateObject var dateSettingViewUpdateObserver = UIUpdateModel()
    
    func updateUI(isCountUpdate: Bool = false) {
        for i in 0 ..< dateChooseModels.count {
            let tmodel: CJCommemorationComponentConfigModel = dateChooseModels[i]
            tmodel.updateData(referDate: Date(), isForDesktop: false)
        }
        
        //shouldUpdateUI.toggle()
        dateSettingViewUpdateObserver.updateListeners()
        onChangeOfDateChooseModels(dateChooseModels, isCountUpdate)
        
//        if model is CCCountDownsModel2 {
//            let tmodel = self.model as! CCCountDownsModel2
//            tmodel.datesChooseModel.components = dateChooseModels
//        }
//        self.model.isSelected = !self.model.isSelected
    }
    
    var body: some View {
        VStack {
//            HStack(spacing: 0) {
//                Text(title)
//                    .font(.system(size: 15.5,weight: .medium))
//                    .foregroundColor(title1Color)
//                Text(" (\(datesChooseModel.values.count)/\(maxCount))")
//                    .font(.system(size: 12.5))
//                    .foregroundColor(title3Color)
//                
//                Spacer()
//            }
//            .frame(height: 45)
//            .padding(.horizontal, widgetDetailPadding)
            
            CJDateListRow(minCount: 1, maxCount: 3, items: $dateChooseModels, currentIndex: currentIndex, valueChangeBlock: { newItems, currentSelectedIndex, oldCount, newCount  in
                dateChooseModels = newItems
                currentIndex = currentSelectedIndex
//                currentTextDateModel = newItems[currentSelectedIndex]
                //debugPrint("currentSelectedIndex:\(currentSelectedIndex)")
                
                for i in 0 ..< newItems.count {
                    let item = newItems[i]
                    item.updateEditingState(isEditing: i == currentSelectedIndex ? true : false, updateChildrenIfExsit: true)
                }
                
                self.updateUI(isCountUpdate: newCount != oldCount)
            })
            .padding(.horizontal, 21)
            
            let existData = dateChooseModels.count > 0
            if existData, currentIndex >= 0, currentIndex < dateChooseModels.count {
                var currentTextDateModel = dateChooseModels[currentIndex].data
//                let bindingText: Binding<String> = Binding(get: { currentTextDateModel.title }, set: { currentTextDateModel.title = $0 })
                
                CJTextInputView(
                    text: Binding(get: { currentTextDateModel.title }, set: { currentTextDateModel.title = $0 }),
//                    titleAlignment: TitleAlignment.leading,
                    placeHolder: "请输入内容",
                    lineLimit: 1,
                    textDidChange: { value in
                        currentTextDateModel.title = value
                        self.updateUI()
                    }
                )
                .frame(height: 40)
                .withCornerRadius(10.0, horizontalPadding: 10.0)
                .withLeadingTitle("文字", titleWidth: 40)
                .padding(.horizontal, 20)

                let bindDateModel: Binding<CJCommemorationDataModel> = Binding(get: { dateChooseModels[currentIndex].data }, set: { dateChooseModels[currentIndex].data = $0 })
                CJCommemorationDateSettingView(commemorationDateModel: bindDateModel, onChangeOfDateChooseModel: { newCommemorationDateModel in
                    currentTextDateModel = newCommemorationDateModel
                    self.updateUI()
                }, actionClosure: { actionType in
                    self.actionClosure(actionType)
                })
                .environmentObject(dateSettingViewUpdateObserver)
            }
            
        }
    }
}



/*
// MARK: - 预览 CCDatesSetttingView
struct CJDatesSettingView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = CCCountDownsViewModel2(model: CCCountDownsModel2(layoutId: "memorialDay_lianai_small_1"), actionClosure: { _ in })
        let model = viewModel.model
        
        let dataAndLayoutModel = createDataAndLayoutModels()
        let items = dataAndLayoutModel.map { $0.data }

        CJDatesSettingView(
            title: "目标日期",
            minCount: 1,
            maxCount: 3,
            dateChooseModels: .constant(dataAndLayoutModel),
            onChangeOfDateChooseModels: { newTextDateModels, isCountUpdate in
                
            },
            actionClosure: { actionType in
                
            }
        )
    }
    
    /// 这个函数负责构建 dataAndLayoutModels 数组
    private static func createDataAndLayoutModels() -> [CJCommemorationDataModel] {
        let dataAndLayoutModels: [CJCommemorationDataModel] = CCAllComponentConfigModel.getDefaultDataByLayoutId("").commemorationComponents
        return dataAndLayoutModels
    }
}
*/
