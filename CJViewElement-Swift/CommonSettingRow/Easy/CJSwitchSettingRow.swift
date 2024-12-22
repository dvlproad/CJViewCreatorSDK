//
//  CJSwitchSettingRow.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/12/18.
//
//  开关视图（可通过设置属性隐藏本视图）

import SwiftUI

public struct CJSwitchSettingRow: View {
    var title: String
    @ObservedObject var toggleModel: CJSwitchSettingModel
    var onChangeOfValue: (_ newBool: Bool) -> Void
    
    public init(title: String, toggleModel: CJSwitchSettingModel, onChangeOfValue: @escaping (_: Bool) -> Void) {
        self.title = title
        self.toggleModel = toggleModel
        self.onChangeOfValue = onChangeOfValue
    }
    
    public var body: some View {
        if toggleModel.isHidden == false {
            Toggle(isOn: $toggleModel.isOn) {
                Text(title)
                    .foregroundColor(Color(hex: "#333333"))
                        .font(.system(size: 15.5, weight: .medium))
            }
            .toggleStyle(SwitchToggleStyle(tint: Color(hex: "#2E2E2E")))
            .frame(height: 42)
            .padding(.horizontal, 20)
            .onChange(of: toggleModel.isOn, { oldValue, newValue in
                onChangeOfValue(newValue)
            })
            .transition(.opacity)
            .animation(.easeInOut, value: toggleModel.isHidden)
        }
    }
}

public class CJSwitchSettingModel: ObservableObject {
    @Published var isHidden: Bool = false
    var isOn: Bool = true {
        didSet {
            objectWillChange.send()
        }
    }
    
    required public init() {}
    
    convenience public init(isOn: Bool, isHidden: Bool = false) {
        self.init()
        self.isOn = isOn
        self.isHidden = isHidden
    }
}


#Preview {
    CJSwitchSettingRow(title: "是否打开", toggleModel: CJSwitchSettingModel(), onChangeOfValue: {newBool in
        
    })
}
