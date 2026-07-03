//
//  CJElementLayoutStyleSettingSection.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2026/5/8.
//
//  用来统一处理所有视图的布局

import SwiftUI
import CJViewElement_Swift

struct CJElementLayoutStyleSettingOption {
    struct PositionSizeSetting {
        let originalLayout: CJTextLayoutModel
        let currentLayout: CJTextLayoutModel
        let onChange: (CJTextLayoutModel) -> Void
    }

    struct TextStyleSetting {
        let currentFontModel: Binding<CJFontDataModel>
        let originalTextColorModel: CJTextColorDataModel
        let currentTextColorModel: CJTextColorDataModel
        let onChangeOfFontModel: (CJFontDataModel) -> Void
        let onChangeOfTextColorModel: (CJTextColorDataModel) -> Void
    }

    let title: String?
    let positionSizeSetting: PositionSizeSetting
    let textStyleSetting: TextStyleSetting?

    init(
        title: String? = nil,
        originalLayout: CJTextLayoutModel,
        currentLayout: CJTextLayoutModel,
        onChangeOfPositionSize: @escaping (CJTextLayoutModel) -> Void,
        textStyleSetting: TextStyleSetting? = nil
    ) {
        self.title = title
        self.positionSizeSetting = PositionSizeSetting(
            originalLayout: originalLayout,
            currentLayout: currentLayout,
            onChange: onChangeOfPositionSize
        )
        self.textStyleSetting = textStyleSetting
    }

    static func text(
        title: String? = nil,
        originalLayout: CJTextLayoutModel,
        currentLayout: CJTextLayoutModel,
        originalTextColorModel: CJTextColorDataModel? = nil,
        currentTextColorModel: CJTextColorDataModel? = nil,
        currentFontModel: Binding<CJFontDataModel>,
        onChangeOfPositionSize: @escaping (CJTextLayoutModel) -> Void,
        onChangeOfFontModel: @escaping (CJFontDataModel) -> Void,
        onChangeOfTextColorModel: @escaping (CJTextColorDataModel) -> Void
    ) -> CJElementLayoutStyleSettingOption {
        let resolvedOriginalTextColorModel = originalTextColorModel ?? currentLayout.textColorModel()
        let resolvedCurrentTextColorModel = currentTextColorModel ?? currentLayout.textColorModel()

        return CJElementLayoutStyleSettingOption(
            title: title,
            originalLayout: originalLayout,
            currentLayout: currentLayout,
            onChangeOfPositionSize: onChangeOfPositionSize,
            textStyleSetting: TextStyleSetting(
                currentFontModel: currentFontModel,
                originalTextColorModel: resolvedOriginalTextColorModel,
                currentTextColorModel: resolvedCurrentTextColorModel,
                onChangeOfFontModel: onChangeOfFontModel,
                onChangeOfTextColorModel: onChangeOfTextColorModel
            )
        )
    }
}

struct CJElementLayoutStyleSettingSection: View {
    let segmentedControlModel: CJSegmentedModel
    let options: [CJElementLayoutStyleSettingOption]
    let fontModels: [CJFontDataModel]
    let textColorModels: [CJTextColorDataModel]
    let onChangeOfSegment: (Int, Int) -> Void

    var body: some View {
        VStack(spacing: 0) {
            if options.count > 1 {
                CJSegmentedSettingRow(
                    title: "编辑文本",
                    segmentedControlModel: segmentedControlModel,
                    segments: options.map { $0.title ?? "" },
                    onChangeOfValue: onChangeOfSegment
                )
            }

            if let currentOption = currentOption {
                // CJFontSettingRow 已改为符合 Setting Row 设计原则的方式，CJPositionSizeSettingRow 和 CJTextColorSettingRow 还是旧的，暂时不改，当做旧方式的代码示例
                CJPositionSizeSettingRow(
                    title: "位置与尺寸",
                    originalLayout: currentOption.positionSizeSetting.originalLayout,
                    currentLayout: currentOption.positionSizeSetting.currentLayout,
                    onChange: currentOption.positionSizeSetting.onChange
                )

                if let textStyleSetting = currentOption.textStyleSetting {
                    // CJFontSettingRow 已改为符合 Setting Row 设计原则的方式，CJPositionSizeSettingRow 和 CJTextColorSettingRow 还是旧的，暂时不改，当做旧方式的代码示例
                    CJFontSettingRow(
                        models: fontModels,
                        currentFontModel: textStyleSetting.currentFontModel,
                        onChangeOfFontModel: textStyleSetting.onChangeOfFontModel
                    )
                    
                    // CJFontSettingRow 已改为符合 Setting Row 设计原则的方式，CJPositionSizeSettingRow 和 CJTextColorSettingRow 还是旧的，暂时不改，当做旧方式的代码示例
                    CJTextColorSettingRow(
                        models: textColorModels,
                        originalTextColorModel: textStyleSetting.originalTextColorModel,
                        currentTextColorModel: textStyleSetting.currentTextColorModel,
                        onChangeOfTextColorModel: textStyleSetting.onChangeOfTextColorModel
                    )
                }
            }
        }
        .background(Color.purple.opacity(0.8))
    }

    private var currentOption: CJElementLayoutStyleSettingOption? {
        guard options.indices.contains(segmentedControlModel.selectedIndex) else {
            return nil
        }
        return options[segmentedControlModel.selectedIndex]
    }
}
