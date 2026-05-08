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
    private enum DateTextRole: Int, CaseIterable {
        case title
        case targetDate
        case countdown
        case dayUnit

        var title: String {
            switch self {
            case .title:
                return "标题"
            case .targetDate:
                return "目标日"
            case .countdown:
                return "倒数日"
            case .dayUnit:
                return "天"
            }
        }

        var textType: CJTextType {
            switch self {
            case .title:
                return .title
            case .targetDate:
                return .date_yyyyMMdd
            case .countdown:
                return .date_countdown
            case .dayUnit:
                return .date_unit
            }
        }
    }
    
    var title: String
    var minCount: Int
    var maxCount: Int
    @Binding var dateChooseModels: [CJCommemorationComponentConfigModel]
    @State var currentIndex = -1
    @StateObject private var currentTextRoleModel = CJSegmentedModel(selectedIndex: 0)
    @State private var originalTextLayouts: [String: CJTextLayoutModel] = [:]
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
            
            CJDateListRow(minCount: 1, maxCount: 3, items: $dateChooseModels, currentIndex: currentIndex, valueChangeBlock: { newItems, currentSelectedIndex, oldCount, newCount  in
                dateChooseModels = newItems
                captureOriginalLayoutsIfNeeded(newItems)
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
            //.background(Color.cyan.opacity(0.8))
            
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
                .withLevelOneLeadingTitle("文字", titleWidth: 40)
                .padding(.horizontal, 20)
                //.background(Color.green.opacity(0.8))
                .frame(height: 40)

                let bindDateModel: Binding<CJCommemorationDataModel> = Binding(get: { dateChooseModels[currentIndex].data }, set: { dateChooseModels[currentIndex].data = $0 })
                CJCommemorationDateSettingView(commemorationDateModel: bindDateModel, onChangeOfDateChooseModel: { newCommemorationDateModel in
                    currentTextDateModel = newCommemorationDateModel
                    self.updateUI()
                }, actionClosure: { actionType in
                    self.actionClosure(actionType)
                })
                //.background(Color.cyan.opacity(0.8))
                .environmentObject(dateSettingViewUpdateObserver)

                let currentComponent = dateChooseModels[currentIndex]
                let currentRole = DateTextRole(rawValue: currentTextRoleModel.selectedIndex) ?? .title

                CJElementLayoutStyleSettingSection(
                    segmentedControlModel: currentTextRoleModel,
                    options: elementLayoutStyleSettingOptions(for: currentComponent),
                    fontModels: TSRowDataUtil.fontModels(),
                    textColorModels: TSRowDataUtil.fontColorData(),
                    onChangeOfSegment: { _, _ in
                        dateSettingViewUpdateObserver.updateListeners()
                    }
                )
                .id("date-text-layout-style-\(currentComponent.id)-\(currentRole.rawValue)")
            }
            
        }
        .onAppear {
            captureOriginalLayoutsIfNeeded(dateChooseModels)
        }
    }

    private func elementLayoutStyleSettingOptions(for component: CJCommemorationComponentConfigModel) -> [CJElementLayoutStyleSettingOption] {
        return DateTextRole.allCases.map { role in
            let currentLayout = textLayout(for: role, in: component)
            let originalLayout = originalTextLayouts[originalLayoutKey(for: component, role: role)] ?? currentLayout.copy()

            return CJElementLayoutStyleSettingOption.text(
                title: role.title,
                originalLayout: originalLayout,
                currentLayout: currentLayout,
                originalTextColorModel: originalLayout.textColorModel(),
                currentTextColorModel: currentLayout.textColorModel(),
                currentFontModel: Binding(
                    get: { currentLayout.font },
                    set: { newFontModel in
                        currentLayout.font = newFontModel.copy()
                        syncChildTextLayout(for: role, in: component)
                    }
                ),
                onChangeOfPositionSize: { newLayout in
                    applyPositionSize(from: newLayout, to: currentLayout)
                    syncChildTextLayout(for: role, in: component)
                    self.updateUI()
                },
                onChangeOfFontModel: { newFontModel in
                    currentLayout.font = newFontModel.copy()
                    syncChildTextLayout(for: role, in: component)
                    self.updateUI()
                },
                onChangeOfTextColorModel: { newTextColorModel in
                    currentLayout.overlay = CJBoxDecorationModel(colorModel: newTextColorModel.copy())
                    syncChildTextLayout(for: role, in: component)
                    self.updateUI()
                }
            )
        }
    }

    private func textLayout(for role: DateTextRole, in component: CJCommemorationComponentConfigModel) -> CJTextLayoutModel {
        switch role {
        case .title:
            return component.layout.titleLayoutModel
        case .targetDate:
            return component.layout.dateLayoutModel
        case .countdown:
            return component.layout.countdownLayoutModel
        case .dayUnit:
            return component.layout.dayUnitLayoutModel
        }
    }

    private func originalLayoutKey(for component: CJCommemorationComponentConfigModel, role: DateTextRole) -> String {
        return "\(component.id)-\(role.rawValue)"
    }

    private func captureOriginalLayoutsIfNeeded(_ components: [CJCommemorationComponentConfigModel]) {
        for component in components {
            for role in DateTextRole.allCases {
                let key = originalLayoutKey(for: component, role: role)
                if originalTextLayouts[key] == nil {
                    originalTextLayouts[key] = textLayout(for: role, in: component).copy()
                }
            }
        }
    }

    private func applyPositionSize(from sourceLayout: CJTextLayoutModel, to targetLayout: CJTextLayoutModel) {
        targetLayout.left = sourceLayout.left
        targetLayout.top = sourceLayout.top
        targetLayout.width = sourceLayout.width
        targetLayout.height = sourceLayout.height
    }

    private func syncChildTextLayout(for role: DateTextRole, in component: CJCommemorationComponentConfigModel) {
        guard let childTextComponent = childTextComponent(for: role, in: component) else {
            return
        }

        childTextComponent.layout = textLayout(for: role, in: component)
    }

    private func childTextComponent(for role: DateTextRole, in component: CJCommemorationComponentConfigModel) -> CJTextComponentConfigModel? {
        return component.childComponents?.compactMap { $0 as? CJTextComponentConfigModel }.first { textComponent in
            textComponent.data.textType == role.textType
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
