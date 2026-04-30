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
    @State var currentIndex = -1
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
        VStack(spacing: 0) {
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
                
                for i in 0 ..< newItems.count {
                    let item = newItems[i]
                    item.updateEditingState(isEditing: i == currentSelectedIndex ? true : false, updateChildrenIfExsit: false)
                }
                
                self.updateUI(isCountUpdate: newCount != oldCount)
            })
            .padding(.horizontal, 21)
            //.background(Color.red.opacity(0.8))
            
            let existData = dateChooseModels.count > 0
            if existData, currentIndex >= 0, currentIndex < dateChooseModels.count  {
                let model: CJTextComponentConfigModel = dateChooseModels[currentIndex]
                let currentTextDateModel: CJTextDataModel = model.data
//                let bindingText: Binding<String> = Binding(get: { currentTextDateModel.title }, set: { currentTextDateModel.title = $0 })
                
                CJTextInputView(
                    text: Binding(get: { currentTextDateModel.text }, set: { currentTextDateModel.text = $0 }),
//                    titleAlignment: TitleAlignment.leading,
                    placeHolder: "请输入内容",
                    lineLimit: 1,
                    textDidChange: { value in
                        currentTextDateModel.text = value
                        self.updateUI()
                    }
                )
                .frame(height: 40)
                .withCornerRadius(10.0, horizontalPadding: 10.0)
                .withLevelOneLeadingTitle("文字", titleWidth: 40)
                .padding(.horizontal, 20)
                .frame(height: 40)
                .padding(.bottom, 4)
                //.background(Color.yellow.opacity(0.8))

//                let bindDateModel: Binding<CJTextDataModel> = Binding(get: { dateChooseModels[currentIndex].data }, set: { dateChooseModels[currentIndex].data = $0 })
//                CJCommemorationDateSettingView(commemorationDateModel: bindDateModel, onChangeOfDateChooseModel: { newCommemorationDateModel in
//                    currentTextDateModel = newCommemorationDateModel
//                    self.updateUI()
//                }, actionClosure: { actionType in
//                    self.actionClosure(actionType)
//                })
//                .environmentObject(dateSettingViewUpdateObserver)
                
                
               
                
                CJPositionSizeSettingRow(
                    title: "位置与尺寸",
                    originalLayout: model.layout,
                    onChange: { newLayout in
                        model.layout = newLayout
                        self.updateUI()
                    }
                )
                //.background(Color.red.opacity(0.8))
                
                CJFontSettingRow(models: TSRowDataUtil.fontModels(), originalFontModel: CJFontDataModel(id: "111", name: "zcoolqingkehuangyouti-Regular", egImage: "fontImage_4"), onChangeOfFontModel: { newFontModel in
                    model.layout.font = newFontModel
                    self.updateUI()
                })
                //.background(Color.green.opacity(0.8))
                
                CJTextColorSettingRow(models: TSRowDataUtil.fontColorData(), originalTextColorModel: CJTextColorDataModel(id: "111",
                                                                                                                          startPoint: .topLeading,
                                                                                                                          endPoint: .bottomTrailing,
                                                                                                                          colorStrings: ["#F8AC9F","#F9EFE5"]
                                                                                                                         ), onChangeOfTextColorModel: { newTextColorModel in
                    model.layout.overlay = CJBoxDecorationModel(colorModel: newTextColorModel)
                    self.updateUI()
                })
                //.background(Color.cyan.opacity(0.8))
                
                
                
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
