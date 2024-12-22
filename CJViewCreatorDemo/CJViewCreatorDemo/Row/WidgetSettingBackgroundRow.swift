//
//  WidgetSettingBackgroundRow.swift
//  WidgetIsland
//
//  Created by One on 2024/8/14.
//

import SwiftUI
import Photos

struct WidgetSettingBackgroundRow<M: BaseModel, VM: ViewModel>: View {
    
    @EnvironmentObject var editStatus: EditStatusModel
    var panelsViewModel: PanelsViewModel
    var model: M
    var viewModel: VM
    @ObservedObject var background: ColorSettingModel
//    @Binding var showPermisionView: Bool
    /// 透明组件上传截图界面
    @State var paletteColor: Color = .clear
//    @Binding var showTransparentPositionView: Bool
    let data = backgroundColorData()
    var isPreview: Bool = false
    init(panelsViewModel: PanelsViewModel, model: M, viewModel: VM, background: ColorSettingModel, isPreview: Bool = false) {
        self.panelsViewModel = panelsViewModel
        self.viewModel = viewModel
        self.model = model
        self.background = background
        #if DEBUG
        self.isPreview = isPreview
        #endif
    }
    
    var body: some View {
        ZStack{
            VStack(alignment: .center, spacing: 0) {
                WidgetSettingTitle(title: "背景颜色", index: $background.index) {
                    background.clear()
                    editStatus.didEdit()
                }.padding(.leading, 21)
                HScrollView(selectedIndex: $background.index, content: {
                    ButtonShowView(title: "相册")
                        .onTapGesture {
                            tapPhoto()
                        }
                    ButtonShowView(title: "透明").onTapGesture {
                        DispatchQueue.main.async {
                            // 点击透明
                            transparentAction()
                        }
                    }
                    ZStack {
                        ColorPicker("颜色", selection: $paletteColor, supportsOpacity: false)
                            .frame(width: 30,height: 30)
                            .offset(x: -4)
                            .overlay(
                                Image("colorPalette")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: (background.index ?? 0) == -2 ? 0 : 30,height: (background.index ?? 0) == -2 ? 0 : 30)
                                    .allowsHitTesting(false)
                            )
                    }.frame(width: 30,height: 30)
                    
                    ForEach(0..<data.count,id:\.self) { item in
                        ColorItem(
                            isSelected: background.index == item,
                            content: data[item])
                            .onTapGesture {
                                background.clear()
                                tapColor(item, color: data[item])
                                background.index = item
                                editStatus.didEdit()
                            }.id(item)
                    }
                })
                .frame(height: 40)
            }
            .frame(width: screenWidth ,height: 80)
        }
        .onChange(of: paletteColor, perform: { value in
            if value == .clear { return }
            background.clear()
            background.index = -2
            background.color = ChangeColorModel(solidColor: value.toHex(includeAlpha: false) ?? "")
            editStatus.didEdit()
        })
        .onChange(of: background.index, perform: { value in
            panelsViewModel.viewModels.filter { $0.model.layoutId == self.model.layoutId }.forEach { viewModel in
                let model = viewModel.model
                model.background = background
            }
        })
        .onAppear(perform: {
            if background.index == -2 {
                paletteColor = Color(hex: background.color?.solidColor ?? "")
            }
        })
        .fullScreenCover(isPresented: $background.isShowImagePicker) {
            PhotoSelectVC(isShowingImagePicker: $background.isShowImagePicker,
                          selectArray: $background.selectedBgImageAssets,
                          selectedMaxIndex: 1) { selectImages in
                var images: [UIImage] = []
                for (_, asset) in selectImages.enumerated() where asset.image != nil && asset.asset != nil {
                    if let image = asset.image {
                        images.append(image)
                    }
                }
                
                debugPrint("2相册==")
                background.selectedBgImageAssets = selectImages
                if selectImages.isNotEmpty {
                    background.isShowCropView = true
                }
            }
        }
        .fullScreenCover(isPresented: $background.isShowCropView) {
            if background.selectedBgImageAssets.isNotEmpty {
                let asset = background.selectedBgImageAssets[0]
                CropView(image: (asset.originalImage ?? asset.image)!, family: model.family, customAspectRatio: WidgetSize(family: model.family)) { croppedImage in
                    print("3相册==")
                    asset.isEdited = true
                    asset.image = croppedImage
                    DispatchQueue.main.async {
                        let selectedBgImageAssets = background.selectedBgImageAssets
                        asset.isEdited = true
                        asset.image = croppedImage
                        background.clear()
                        background.isShowCropView = false
                        background.image = croppedImage
                        background.selectedBgImageAssets = selectedBgImageAssets
                        background.index = -3
                        editStatus.didEdit()
                    }
                }onCancel: {
                    background.isShowCropView = false
                }
                .edgesIgnoringSafeArea(.all)
            } else {
                EmptyView()
            }
        }
    }
    /// 点击相册
    func tapPhoto() {
        debugPrint("相册==")
        PHPhotoLibrary.requestAuthorization(for: PHAccessLevel.readWrite) { status in
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    background.isShowImagePicker = true
                case .denied, .limited:/// 相册权限弹窗
                    @State var showPhotoPermissionAlert: Bool = true
                    var popHander: (() -> Void)?
                    let vc = CustomPopupViewController(rootView: PhotoPermisionAlertView(showingAlert: $showPhotoPermissionAlert, showPhotoSelectVC: $background.isShowImagePicker,isPopWindows: true, popHandler: {
                        popHander?()
                    }))
                    popHander = {
                        vc.dismiss()
                    }
                    vc.show()
                case .notDetermined:
                    print("权限尚未请求")
                case .restricted:
                    print("此应用无权访问")
                @unknown default:
                    print("未知的权限状态")
                }
            }
        }
    }
    
    func tapColor(_ index: Int, color: ChangeColorModel) {
        background.color = color
    }
    
    private func transparentAction() {
        if TransparentManager.lightScreenShot == nil && TransparentManager.darkScreenShot == nil {
            let alert = SWAlertController(title: "温馨提示",
                                          message: "您还未设置透明背景，透明效果需要先上传 您手机中的壁纸，是否现在设置？",
                                          confirmTitle: "去设置",
                                          confirmHandler: {action in
                viewModel.actionClosure(.transparentPosition)
            },
                                          cancelTitle: "取消",
                                          cancelHandler: { action in
            })
            alert.show()
        } else {
//            let viewModel = self.viewModel.viewModels[viewModel.currentIndex]
//            let model = viewModel.viewModels[viewModel.currentIndex].model
            var dismissHandler: VoidClosure?
            let  transparent = TransparentPositionSettingView(model: model){
                dismissHandler?()
            } showTransparentView: {
                viewModel.actionClosure(.transparentPosition)
            }.environmentObject(editStatus)
            let vc = CustomPopupViewController(rootView: transparent, isFullScreen: true)
                
            dismissHandler = {
                vc.dismiss()
            }
            vc.show()
        }
    }
}

#Preview {
    let model = NotesModel(layoutId: "notes_small_1")
    return WidgetSettingBackgroundRow(panelsViewModel: PanelsViewModel(subArray: [model], actionClosure: {_ in }), model: model, viewModel: NotesViewModel(model: model, actionClosure: { _ in }), background: model.background)
}
