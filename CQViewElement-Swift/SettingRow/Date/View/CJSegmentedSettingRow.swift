//
//  CJSegmentedSettingRow.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/12/22.
//

import SwiftUI
import CJViewElement_Swift

struct CJSegmentedSettingRow: View {
    var title: String?
    @ObservedObject var segmentedControlModel: CJSegmentedModel
    var segments: [String]
    var padding: CGFloat = 1
    var segmentHeight: CGFloat = 26.5
    var fontSize: CGFloat = 11
    var onChangeOfValue: ((_ oldValue: Int, _ newValue: Int) -> Void)?
    var body: some View {
        HStack {
            if let title = self.title {
                Text(title)
                    .foregroundColor(Color(hex: "#333333"))
                    .font(.system(size: 15.5, weight: .medium))
                Spacer()
            }
            CJSegmentedView(segments: segments, selectedIndex: $segmentedControlModel.selectedIndex, padding: padding, fixSize: title != nil, fontSize: fontSize, didSelectItem: { oldValue, newValue in
                self.segmentedControlModel.selectedIndex = newValue
                onChangeOfValue?(oldValue, newValue)
            })
            .frame(height: segmentHeight)
        }
        .frame(height: 45)
        .padding(.horizontal, 20)
    }
}

class CJSegmentedModel: ObservableObject {
    var selectedIndex: Int = 0 {
        didSet {
            isEdited = true
            objectWillChange.send()
        }
    }
    @Published var isHidden: Bool = false
    var isEdited: Bool = false
    
    required init() {}
    
    convenience init(selectedIndex: Int, isHidden: Bool = false) {
        self.init()
        self.selectedIndex = selectedIndex
        self.isHidden = isHidden
    }
}
