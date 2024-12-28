//
//  CJToolView.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/8/15.
//

import SwiftUI
import Combine
import CJViewElement_Swift

struct CJToolView: View {
    @Binding var model: CQWidgetModel
    @State var refreshID = UUID()
    @StateObject private var keyboardObserver = KeyboardObserver()
//    @State var popMenus: [(model: MenuPickerModel, view: AnyView)] = []
    
//    var completeBlock: (([CJCommemorationComponentConfigModel]) -> Void)? = nil
    var onChangeOfElementModel: ((_ newElementModel: CQWidgetModel) -> Void)
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                ZStack(alignment: .topLeading) {
                    LazyVStack(alignment: .leading, spacing: 10) {
                        if commemorationComponents.count > 0 {
//                            ForEach(model.commemorationComponents, id: \.self) { component in
//                                // 为每个component创建视图
//                                Text("Component:  $component)")
//                            }
//                            let bindDateModel: Binding<CJCommemorationComponentConfigModel> = Binding(get: { (model as! CQWidgetModel).datesChooseModel.values }, set: { (model as! CQWidgetModel).datesChooseModel.values = $0 })
                            CJDatesSettingView(
                                title: "我是新的日期标题",
                                minCount: 1,
                                maxCount: 3,
                                dateChooseModels: Binding(get: { commemorationComponents }, set: { commemorationComponents = $0 }),
                                onChangeOfDateChooseModels: { newTextDateModels, isCountUpdate in
                                    // 1.    删除：从 components 中移除 id 不在 newTextDateModels 中的项。
                                    // 2.    添加：将 newTextDateModels 中 id 不在 components 中的项添加到 components。
                                    var typeComponents = model.anyComponentModel.commemorationComponents
                                    // 1. 获取所有的 id 集合
                                    let componentsIds = Set(typeComponents.map { $0.id })
                                    let newTextIds = Set(newTextDateModels.map { $0.id })

                                    // 2. 找出需要删除的 id 和需要添加的 id
                                    let idsToDelete = componentsIds.subtracting(newTextIds)
                                    let idsToAdd = newTextIds.subtracting(componentsIds)

                                    // 3. 删除 components 中的无效项
                                    typeComponents.removeAll { idsToDelete.contains($0.id) }

                                    // 4. 添加 newTextDateModels 中的新项到 components
                                    let itemsToAdd = newTextDateModels.filter { idsToAdd.contains($0.id) }
                                    typeComponents.append(contentsOf: itemsToAdd.map { $0 })

                                    //debugPrint("idsToDelete:\(idsToDelete)")
                                    //debugPrint("idsToAdd:\(idsToAdd)")
                                    //debugPrint("typeComponents:\(typeComponents)")
                                    
                                    
                                    // 移除符合条件的组件，并添加新增的
                                    model.anyComponentModel.components.removeAll { component in
                                        if component.componentType == .commemoration,
                                           let commemComponent = component as? CJCommemorationComponentConfigModel {
                                            return idsToDelete.contains(commemComponent.id)
                                        }
                                        return false
                                    }
                                    model.anyComponentModel.components.append(contentsOf: itemsToAdd.map { $0 })
                                    onChangeOfElementModel(model)
                                },
                                actionClosure: { actionType in
//                                    viewModel.actionClosure(actionType)
//                                    popMenus.append(<#T##Element#>)
                                }
                            )
                        }
                        
                        if singleTextComponents.count > 0 {
//                            let textModel: CJTextComponentConfigModel = singleTextComponents[0]
//                            let textDataModel: CJTextDataModel = textModel.data
                            CJTextSettingRow(title: "文字", text: $singleTextComponents[0].data.text, placeHolder: "请输入内容", lineLimit: 1, textFieldWidth: 320, textFieldHeight: 40, textDidChange: { newText in
                                
                            })
                            
                            CJTextsSettingView(
                                title: "我是新的日期标题",
                                minCount: 1,
                                maxCount: 3,
                                dateChooseModels: Binding(get: { singleTextComponents }, set: { singleTextComponents = $0 }),
                                onChangeOfDateChooseModels: { newTextDateModels, isCountUpdate in
                                    // 1.    删除：从 components 中移除 id 不在 newTextDateModels 中的项。
                                    // 2.    添加：将 newTextDateModels 中 id 不在 components 中的项添加到 components。
                                    var typeComponents = model.anyComponentModel.singleTextComponents
                                    // 1. 获取所有的 id 集合
                                    let componentsIds = Set(typeComponents.map { $0.id })
                                    let newTextIds = Set(newTextDateModels.map { $0.id })

                                    // 2. 找出需要删除的 id 和需要添加的 id
                                    let idsToDelete = componentsIds.subtracting(newTextIds)
                                    let idsToAdd = newTextIds.subtracting(componentsIds)

                                    // 3. 删除 components 中的无效项
                                    typeComponents.removeAll { idsToDelete.contains($0.id) }

                                    // 4. 添加 newTextDateModels 中的新项到 components
                                    let itemsToAdd = newTextDateModels.filter { idsToAdd.contains($0.id) }
                                    typeComponents.append(contentsOf: itemsToAdd.map { $0 })

                                    //debugPrint("idsToDelete:\(idsToDelete)")
                                    //debugPrint("idsToAdd:\(idsToAdd)")
                                    //debugPrint("typeComponents:\(typeComponents)")
                                    
                                    
                                    // 移除符合条件的组件，并添加新增的
                                    model.anyComponentModel.components.removeAll { component in
                                        if component.componentType == .normal_single_text,
                                           let commemComponent = component as? CJTextComponentConfigModel {
                                            return idsToDelete.contains(commemComponent.id)
                                        }
                                        return false
                                    }
                                    model.anyComponentModel.components.append(contentsOf: itemsToAdd.map { $0 })
                                    onChangeOfElementModel(model)
                                },
                                actionClosure: { actionType in
//                                    viewModel.actionClosure(actionType)
//                                    popMenus.append(<#T##Element#>)
                                }
                            )
                                    
                        }
                        
                        if backgroundTextComponents.count > 0 {
                            CJBackgroundSettingRow(models: TSRowDataUtil.backgroundColorData(), originalBackgroundModel: model.backgroundModel, onChangeOfBackgroundModel: { newBackgroundModel in
                                model.backgroundModel = newBackgroundModel
                                
//                                let randomColorString = Color.randomColor.toHex()!
//                                model.backgroundModel.colorModel?.colorStrings = [randomColorString]
//                                model.backgroundModel.colorModel = CJTextColorDataModel(solidColorString: randomColorString)
                                //model.backgroundModel = CJBoxDecorationModel(colorModel: CJTextColorDataModel(solidColorString: randomColorString))
                                
                                onChangeOfElementModel(model)
                            })
                        }
                        //
                        if existTextElement {
                            CJFontSettingRow(models: TSRowDataUtil.fontModels(), originalFontModel: CJFontDataModel(id: "111", name: "zcoolqingkehuangyouti-Regular", egImage: "fontImage_4"), onChangeOfFontModel: { newFontModel in
                                let showingModels: [CJTextComponentConfigModel] = model.anyComponentModel.getAllLayoutModels()
                                for showingModel in showingModels {
                                    showingModel.layout.font = newFontModel
                                }
                                onChangeOfElementModel(model)
                            })

                            CJTextColorSettingRow(models: TSRowDataUtil.fontColorData(), originalTextColorModel: CJTextColorDataModel(id: "111",
                                                                                               startPoint: .topLeading,
                                                                                               endPoint: .bottomTrailing,
                                                                                               colorStrings: ["#F8AC9F","#F9EFE5"]
                                                                                              ), onChangeOfTextColorModel: { newTextColorModel in
                                let showingModels: [CJTextComponentConfigModel] = model.anyComponentModel.getAllLayoutModels()
                                if newTextColorModel.colorStrings.count == 1 {
                                    for showingModel in showingModels {
                                        showingModel.layout.foregroundColor = newTextColorModel.colorStrings[0]
                                    }
                                    
                                } else {
                                    let forgroundColorString = Color.clear.toHex()!
                                    for showingModel in showingModels {
                                        showingModel.layout.foregroundColor = forgroundColorString
                                        let overlay: CJBoxDecorationModel? = showingModel.layout.overlay
                                        if overlay != nil {
                                            overlay?.colorModel = newTextColorModel
                                        } else {
                                            showingModel.layout.overlay = CJBoxDecorationModel(colorModel: newTextColorModel)
                                        }
                                    }
                                }
                                onChangeOfElementModel(model)
                            })
                        }
                        
                        if borderComponents.count > 0 {
                            CJBorderSettingRow(models: TSRowDataUtil.backgroundBorderData(), originalBorderModel: CJBorderDataModel(id: "111", imageName: "border_8"), onChangeOfBorderModel: { newBorderModel in
                                model.borderModel = newBorderModel
                                onChangeOfElementModel(model)
                            })
                        }
                    }
                    .padding(.vertical, 20)
                    .padding(.bottom, keyboardObserver.keyboardHeight) // 添加底部填充距离
                    .animation(.easeOut(duration: 0.3), value: keyboardObserver.keyboardHeight)
                    .background(Color.white)
                    
//                    ZStack(alignment: .topLeading) {
//                        ForEach(0..<popMenus.count, id: \.self) { index in
//                            popMenus[index].view
//                        }
//                    }
                }
                .simultaneousGesture(TapGesture().onEnded({ _ in
                    dismissMenu()
                }).simultaneously(with: DragGesture()
                    .onChanged { _ in
                        debugPrint("Scroll onChanged")
                        dismissMenu()
                    }
                    .onEnded { _ in
                        debugPrint("Scroll ended")
                    }))
            }
            .coordinateSpace(name: "CommonToolsView")
            .id(refreshID)
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("KeyDefault_need_refresh_detailView"))) { _ in
                
                refreshID = UUID()
            }
        }.onAppear() {
            getAnyComponents()
        }
    }
    @State var commemorationComponents: [CJCommemorationComponentConfigModel] = []
    @State var singleTextComponents: [CJTextComponentConfigModel] = []
    @State var backgroundTextComponents: [CJBackgroundComponentConfigModel] = []
    @State var existTextElement: Bool = false
    @State var borderComponents: [CJBorderComponentConfigModel] = []
    private func getAnyComponents() {
        let anyCom: CJAllComponentConfigModel = model.anyComponentModel
        
        commemorationComponents = anyCom.commemorationComponents
        singleTextComponents = anyCom.singleTextComponents
        backgroundTextComponents = anyCom.backgroundTextComponents
        existTextElement = anyCom.existTextElement
        borderComponents = anyCom.borderComponents
    }

    
    
//    func showMenu(_ menu: (model: MenuPickerModel, view: AnyView)) {
//        popMenus.append(menu)
//    }
//    
//    
//    func removeMenu(_ model: MenuPickerModel) {
//        guard let index = popMenus.firstIndex(where: {$0.model.id == model.id}) else { return }
//        popMenus[index].model.dismiss()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
//            popMenus.remove(at: index)
//        })
//    }
//    
    func dismissMenu() {
//        popMenus.forEach({ $0.model.dismiss() })
//        popMenus.removeAll()
    }
}

class KeyboardObserver: ObservableObject {
    @Published var keyboardHeight: CGFloat = 0
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect }
            .map { $0.height }
            .assign(to: \.keyboardHeight, on: self)
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }
            .assign(to: \.keyboardHeight, on: self)
            .store(in: &cancellables)
    }
}
