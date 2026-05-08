//
//  CCDatesSetttingView.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/11/25.
//

import Foundation
import SwiftUI
import CJDataVientianeSDK_Swift
import CJViewElement_Swift

struct CJTextsSettingView: View {
//    @ObservedObject var model: M
    
    var title: String
    var minCount: Int
    var maxCount: Int
    @Binding var dateChooseModels: [CJTextComponentConfigModel]
    @State var currentIndex = -1
    @State private var originalTextLayouts: [String: CJTextLayoutModel] = [:]
    @State private var dateSettingDates: [String: Date] = [:]
    @State private var dateStringIsLunarTypes: [String: Bool] = [:]
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
            
            CJTextListRow(title: title, minCount: 1, maxCount: 3, items: $dateChooseModels, currentIndex: currentIndex, valueChangeBlock: { newItems, currentSelectedIndex, oldCount, newCount  in
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
                
                if currentTextDateModel.textType == .date_yyyyMMdd {
                    let date: Binding<Date> = Binding(
                        get: { dateSettingDates[model.id] ?? Self.date(from: currentTextDateModel.text) ?? Date() },
                        set: { newDate in
                            dateSettingDates[model.id] = newDate
                            currentTextDateModel.text = Self.dateString(from: newDate, isLunar: dateStringIsLunarTypes[model.id] ?? false)
                        }
                    )
                    let dateStringIsLunarType: Binding<Bool> = Binding(
                        get: { dateStringIsLunarTypes[model.id] ?? false },
                        set: { isLunar in
                            dateStringIsLunarTypes[model.id] = isLunar
                            let currentDate = dateSettingDates[model.id] ?? Self.date(from: currentTextDateModel.text) ?? Date()
                            currentTextDateModel.text = Self.dateString(from: currentDate, isLunar: isLunar)
                        }
                    )
                    CJDateChooseRow(
                        title: "日期",
                        date: date,
                        dateStringIsLunarType: dateStringIsLunarType,
                        dateFormaterHandle: { date in
                            Self.dateString(from: date, isLunar: dateStringIsLunarTypes[model.id] ?? false)
                        },
                        isPickerSupportLunar: true,
                        onChangeOfDate: { newDate in
                            currentTextDateModel.text = Self.dateString(from: newDate, isLunar: dateStringIsLunarTypes[model.id] ?? false)
                            self.updateUI()
                        },
                        onChangeOfDateStringIsLunarType: { isLunar in
                            let currentDate = dateSettingDates[model.id] ?? Self.date(from: currentTextDateModel.text) ?? Date()
                            currentTextDateModel.text = Self.dateString(from: currentDate, isLunar: isLunar)
                            self.updateUI()
                        },
                        isValidateHandler: { _ in
                            return (true, "")
                        },
                        actionClosure: { actionType in
                            self.actionClosure(actionType)
                        }
                    )
                    .environmentObject(dateSettingViewUpdateObserver)
                } else {
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
                }

                // CJFontSettingRow 已改为符合 Setting Row 设计原则的方式，CJPositionSizeSettingRow 和 CJTextColorSettingRow 还是旧的，暂时不改，当做旧方式的代码示例
                CJPositionSizeSettingRow(
                    title: "位置与尺寸",
                    originalLayout: originalTextLayouts[model.id] ?? model.layout.copy(),
                    currentLayout: model.layout,
                    onChange: { newLayout in
                        model.layout.left = newLayout.left
                        model.layout.top = newLayout.top
                        model.layout.width = newLayout.width
                        model.layout.height = newLayout.height
                        self.updateUI()
                    }
                )
                .id("position-\(model.id)")
                //.background(Color.red.opacity(0.8))
                
                // CJFontSettingRow 已改为符合 Setting Row 设计原则的方式，CJPositionSizeSettingRow 和 CJTextColorSettingRow 还是旧的，暂时不改，当做旧方式的代码示例
                CJFontSettingRow(
                    models: TSRowDataUtil.fontModels(),
                    currentFontModel: Binding(
                        get: { model.layout.font },
                        set: { newFontModel in
                            model.layout.font = newFontModel.copy()
                        }
                    ),
                    onChangeOfFontModel: { newFontModel in
                        model.layout.font = newFontModel.copy()
                        self.updateUI()
                    }
                )
                .id("font-\(model.id)")
                //.background(Color.green.opacity(0.8))
                
                // CJFontSettingRow 已改为符合 Setting Row 设计原则的方式，CJPositionSizeSettingRow 和 CJTextColorSettingRow 还是旧的，暂时不改，当做旧方式的代码示例
                let referenceTextColorModel = originalTextLayouts[model.id]?.textColorModel() ?? model.layout.textColorModel()
                CJTextColorSettingRow(models: TSRowDataUtil.fontColorData(), originalTextColorModel: referenceTextColorModel, currentTextColorModel: model.layout.textColorModel(), onChangeOfTextColorModel: { newTextColorModel in
                    model.layout.overlay = CJBoxDecorationModel(colorModel: newTextColorModel.copy())
                    self.updateUI()
                })
                .id("textColor-\(model.id)")
                //.background(Color.cyan.opacity(0.8))
                
                
                
            }
            
        }
        .onAppear {
            captureOriginalModelsIfNeeded(dateChooseModels)
            captureDateSettingValuesIfNeeded(dateChooseModels)
        }
    }

    private func captureOriginalModelsIfNeeded(_ models: [CJTextComponentConfigModel]) {
        for model in models {
            if originalTextLayouts[model.id] == nil {
                originalTextLayouts[model.id] = model.layout.copy()
            }
        }
    }

    private func captureDateSettingValuesIfNeeded(_ models: [CJTextComponentConfigModel]) {
        for model in models where model.data.textType == .date_yyyyMMdd {
            if dateSettingDates[model.id] == nil {
                dateSettingDates[model.id] = Self.date(from: model.data.text) ?? Date()
            }
            if dateStringIsLunarTypes[model.id] == nil {
                dateStringIsLunarTypes[model.id] = false
            }
        }
    }

    private static func date(from text: String) -> Date? {
        for format in ["yyyy-MM-dd", "yyyy/MM/dd"] {
            if let date = dateFormatter(format: format).date(from: text) {
                return date
            }
        }
        return nil
    }

    private static func dateString(from date: Date, isLunar: Bool) -> String {
        if isLunar {
            let lunarTuple = date.lunarTuple()
            return "\(lunarTuple.lunarYear)\(lunarTuple.stemBranch).\(lunarTuple.monthString)月.\(lunarTuple.dayString)"
        }
        return date.format("yyyy/MM/dd")
    }

    private static func dateFormatter(format: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .current
        formatter.dateFormat = format
        return formatter
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
    private static func createDataAndLayoutModels() -> [CJCommemorationDateModel] {
        let dataAndLayoutModels: [CJCommemorationDateModel] = CCAllComponentConfigModel.getDefaultDataByLayoutId("").commemorationComponents.map { $0.data }
        return dataAndLayoutModels
    }
}
*/
