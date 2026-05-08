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
    var commemorationComponents: [CJCommemorationComponentConfigModel] = []
    @State var currentIndex = -1
    @State private var originalTextLayouts: [String: CJTextLayoutModel] = [:]
    @State private var dateSettingModels: [String: CJCommemorationDataModel] = [:]
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
                    let bindDateModel: Binding<CJCommemorationDataModel> = Binding(
                        get: {
                            dateSettingModel(for: model)
                        },
                        set: { newDateModel in
                            dateSettingModels[model.id] = newDateModel
                            applyDateSettingModel(newDateModel, to: model)
                        }
                    )
                    CJCommemorationDateSettingView(commemorationDateModel: bindDateModel, onChangeOfDateChooseModel: { newDateModel in
                        dateSettingModels[model.id] = newDateModel
                        applyDateSettingModel(newDateModel, to: model)
                        self.updateUI()
                    }, actionClosure: { actionType in
                        self.actionClosure(actionType)
                    })
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

//                let bindDateModel: Binding<CJTextDataModel> = Binding(get: { dateChooseModels[currentIndex].data }, set: { dateChooseModels[currentIndex].data = $0 })
//                CJCommemorationDateSettingView(commemorationDateModel: bindDateModel, onChangeOfDateChooseModel: { newCommemorationDateModel in
//                    currentTextDateModel = newCommemorationDateModel
//                    self.updateUI()
//                }, actionClosure: { actionType in
//                    self.actionClosure(actionType)
//                })
//                .environmentObject(dateSettingViewUpdateObserver)
                
                
               
                
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
            captureDateSettingModelsIfNeeded(dateChooseModels)
        }
    }

    private func captureOriginalModelsIfNeeded(_ models: [CJTextComponentConfigModel]) {
        for model in models {
            if originalTextLayouts[model.id] == nil {
                originalTextLayouts[model.id] = model.layout.copy()
            }
        }
    }

    private func applyDateSettingModel(_ dateModel: CJCommemorationDataModel, to sourceModel: CJTextComponentConfigModel) {
        let referDate = Date()

        if let commemorationModel = commemorationComponent(containing: sourceModel) {
            applyDateSettingFields(dateModel, to: commemorationModel.data)
            commemorationModel.updateData(referDate: referDate, isForDesktop: false)
        }

        let relatedModels = textModelsInSameGroup(as: sourceModel)
        let targetModels = relatedModels.isEmpty ? [sourceModel] : relatedModels

        for textModel in targetModels {
            applyCommemorationPreviewText(from: dateModel, to: textModel, referDate: referDate)
        }
    }

    private func dateSettingModel(for textModel: CJTextComponentConfigModel) -> CJCommemorationDataModel {
        if let commemorationModel = commemorationComponent(containing: textModel) {
            return commemorationModel.data
        }

        if let dateSettingModel = dateSettingModels[textModel.id] {
            return dateSettingModel
        }

        let dateSettingModel = Self.commemorationDataModel(from: textModel.data)
        dateSettingModels[textModel.id] = dateSettingModel
        return dateSettingModel
    }

    private func captureDateSettingModelsIfNeeded(_ models: [CJTextComponentConfigModel]) {
        for model in models where model.data.textType == .date_yyyyMMdd {
            if dateSettingModels[model.id] == nil, commemorationComponent(containing: model) == nil {
                dateSettingModels[model.id] = Self.commemorationDataModel(from: model.data)
            }
        }
    }

    private static func commemorationDataModel(from textDataModel: CJTextDataModel) -> CJCommemorationDataModel {
        return CJCommemorationDataModel(
            title: "",
            date: date(from: textDataModel.text) ?? Date(),
            cycleType: .year,
            shouldContainToday: false
        )
    }

    private func applyDateSettingFields(_ dateModel: CJCommemorationDataModel, to targetModel: CJCommemorationDataModel) {
        targetModel.date = dateModel.date
        targetModel.cycleType = dateModel.cycleType
        targetModel.includeTodayIsOn = dateModel.includeTodayIsOn
        targetModel.dateStringIsLunarType = dateModel.dateStringIsLunarType
    }

    private func commemorationComponent(containing textModel: CJTextComponentConfigModel) -> CJCommemorationComponentConfigModel? {
        return commemorationComponents.first { component in
            component.childComponents?.contains(where: { child in
                (child as? CJTextComponentConfigModel)?.id == textModel.id
            }) ?? false
        }
    }

    private func textModelsInSameGroup(as sourceModel: CJTextComponentConfigModel) -> [CJTextComponentConfigModel] {
        guard let sourceGroupKey = Self.groupKey(from: sourceModel.id) else {
            return []
        }

        return dateChooseModels.filter { Self.groupKey(from: $0.id) == sourceGroupKey }
    }

    private static func groupKey(from id: String) -> String? {
        let parts = id.split(separator: "_")
        guard parts.count > 1, parts.last.flatMap({ Int($0) }) != nil else {
            return nil
        }

        return parts.dropLast().joined(separator: "_")
    }

    private func applyCommemorationPreviewText(from dateModel: CJCommemorationDataModel, to textModel: CJTextComponentConfigModel, referDate: Date) {
        switch textModel.data.textType {
        case .some(.date_yyyyMMdd):
            textModel.data.text = dateModel.getNextRepeatDateString(referDate: referDate)
        case .some(.date_countdown):
            textModel.data.text = dateModel.stringForPreviewCountdownDays(referDate: referDate)
        case .some(.date_unit):
            textModel.data.text = "天"
        case .some(.title), nil:
            break
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
    private static func createDataAndLayoutModels() -> [CJCommemorationDataModel] {
        let dataAndLayoutModels: [CJCommemorationDataModel] = CCAllComponentConfigModel.getDefaultDataByLayoutId("").commemorationComponents
        return dataAndLayoutModels
    }
}
*/
