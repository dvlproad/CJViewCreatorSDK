//
//  CCDatesSetttingView.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/11/25.
//

import Foundation
import SwiftUI
import CJViewElement_Swift

struct CJTextsSettingView: View {
//    @ObservedObject var model: M
    
    var title: String
    var minCount: Int
    var maxCount: Int
    @Binding var dateChooseModels: [CJTextComponentConfigModel]
    @State var currentIndex = 0
//    @State var currentTextDateModel: CJCommemorationDataModel
//    @State var currentTextDateModel: CJTextComponentConfigModel
    var onChangeOfDateChooseModels: ((_ newTextDateModels: [CJTextComponentConfigModel], _ isCountUpdate: Bool) -> Void)
    var actionClosure: ((CJSheetActionType) -> Void)
    
    
    //@State var shouldUpdateDateSettingView = false
    @StateObject var dateSettingViewUpdateObserver = UIUpdateModel()
    
    func updateUI(isCountUpdate: Bool = false) {
        for i in 0 ..< dateChooseModels.count {
            let tmodel: CJTextComponentConfigModel = dateChooseModels[i]
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
            
            CJTextListRow(minCount: 1, maxCount: 3, items: $dateChooseModels, currentIndex: currentIndex, valueChangeBlock: { newItems, currentSelectedIndex, oldCount, newCount  in
                dateChooseModels = newItems
                currentIndex = currentSelectedIndex
//                currentTextDateModel = newItems[currentSelectedIndex]
                //debugPrint("currentSelectedIndex:\(currentSelectedIndex)")
                let item = newItems[currentSelectedIndex]
                item.isEditing = true
                
                self.updateUI(isCountUpdate: newCount != oldCount)
            })
            .padding(.horizontal, 21)
            
            let existData = dateChooseModels.count > 0
            if existData {
                var model: CJTextComponentConfigModel = dateChooseModels[currentIndex]
                var currentTextDateModel: CJTextDataModel = model.data
//                let bindingText: Binding<String> = Binding(get: { currentTextDateModel.title }, set: { currentTextDateModel.title = $0 })
                
                let textFieldWidth = 320.0
                let textFieldHeight = 40.0
                CJTextSettingRow(
                    title: "",
                    text: Binding(get: { currentTextDateModel.text }, set: { currentTextDateModel.text = $0 }),
//                    titleAlignment: TitleAlignment.leading,
                    placeHolder: "请输入内容",
                    lineLimit: 1,
                    textFieldWidth: textFieldWidth,
                    textFieldHeight: textFieldHeight,
                    textDidChange: { value in
                        currentTextDateModel.text = value
                        self.updateUI()
                    }
                )
                .padding(.horizontal, 21)

//                let bindDateModel: Binding<CJTextDataModel> = Binding(get: { dateChooseModels[currentIndex].data }, set: { dateChooseModels[currentIndex].data = $0 })
//                CJCommemorationDateSettingView(commemorationDateModel: bindDateModel, onChangeOfDateChooseModel: { newCommemorationDateModel in
//                    currentTextDateModel = newCommemorationDateModel
//                    self.updateUI()
//                }, actionClosure: { actionType in
//                    self.actionClosure(actionType)
//                })
//                .environmentObject(dateSettingViewUpdateObserver)
                
                
               
                
                CJFontSettingRow(models: TSRowDataUtil.fontModels(), originalFontModel: CJFontDataModel(id: "111", name: "zcoolqingkehuangyouti-Regular", egImage: "fontImage_4"), onChangeOfFontModel: { newFontModel in
                    model.layout.font = newFontModel
                    self.updateUI()
                })
                
                CJTextColorSettingRow(models: TSRowDataUtil.fontColorData(), originalTextColorModel: CJTextColorDataModel(id: "111",
                                                                                                                          startPoint: .topLeading,
                                                                                                                          endPoint: .bottomTrailing,
                                                                                                                          colorStrings: ["#F8AC9F","#F9EFE5"]
                                                                                                                         ), onChangeOfTextColorModel: { newTextColorModel in
                    model.layout.overlay = CJBoxDecorationModel(colorModel: newTextColorModel)
                    self.updateUI()
                })
                
                
                
            }
            
        }
    }
}



/*
// MARK: - 预览 CCDatesSetttingView
struct CJTextsSettingView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = CCCountDownsViewModel2(model: CCCountDownsModel2(layoutId: "memorialDay_lianai_small_1"), actionClosure: { _ in })
        let model = viewModel.model
        
        let dataAndLayoutModel = createDataAndLayoutModels()
        let items = dataAndLayoutModel.map { $0.data }

        CJTextsSettingView(
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
