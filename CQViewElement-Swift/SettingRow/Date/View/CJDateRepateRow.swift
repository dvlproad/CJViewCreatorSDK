//
//  CJDateRepateRow.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/12/22.
//

import Foundation
import SwiftUI
import CJDataVientianeSDK_Swift

struct CJDateRepateRow: View {
    var cycleType: CJCommemorationCycleType
    var onChangeOfCycleType: ((_ newCycleType: CJCommemorationCycleType) -> ())
    
    var body: some View {
        let repateType: Int = indexForCycleType(cycleType)
        let repeatModel: CJSegmentedModel = CJSegmentedModel(selectedIndex: repateType)
        CJSegmentedSettingRow(title: "事件重复", segmentedControlModel: repeatModel, segments: ["每周", "每月", "每年", "不重复"], onChangeOfValue: {  _, index in
            let newCycleType: CJCommemorationCycleType = cycleTypeForIndex(index)
            onChangeOfCycleType(newCycleType)
        }).padding(.vertical, 5)
    }
    
    private func indexForCycleType(_ cycleType: CJCommemorationCycleType) -> Int {
        switch cycleType {
        case .week:
            return 0
        case .month:
            return 1
        case .year:
            return 2
        case .none:
            return 3
        }
    }
    
    private func cycleTypeForIndex(_ index: Int) -> CJCommemorationCycleType {
        switch index {
        case 0:
            return .week
        case 1:
            return .month
        case 2:
            return .year
        case 3:
            return .none
        default:
            return .none
        }
    }
}
