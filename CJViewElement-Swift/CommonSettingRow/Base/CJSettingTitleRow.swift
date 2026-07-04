//
//  CJSettingTitleRow.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/12/15.
//

import SwiftUI

public struct CJSettingTitleRow: View {
    var title: String
    var subTitle: String?
    @Binding var showRecoverIcon: Bool
    var onTapRecover: (() -> Void)?
    
    public init(
        title: String,
        subTitle: String? = nil,
        showRecoverIcon: Binding<Bool> = .constant(false),
        onTapRecover: (() -> Void)? = nil
    ) {
        self.title = title
        self.subTitle = subTitle
        
        self._showRecoverIcon = showRecoverIcon
        self.onTapRecover = onTapRecover
    }
    
    public var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Text(title)
                .foregroundColor(Color(hex: "#333333"))
                .font(.system(size: 15.5, weight: .medium))
            if let subTitle = subTitle, subTitle.count > 0 {
                Text(subTitle)
                    .foregroundColor(Color(hex: "#999999"))
                    .font(.system(size: 13.5, weight: .regular))
            }
            
            if showRecoverIcon {
                Button(action: {
                    onTapRecover?()
                }, label: {
                    Image("recover", bundle: .cjViewElement)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 12, height: 12)
                })
                .buttonStyle(StaticButtonStyle())
                .frame(width: 27)
                .frame(maxHeight: .infinity)  // 撑满父视图高度
                //.background(.red)
                //.padding(.leading, 7.5)
            }
            
            Spacer()
            
        }
        .frame(maxHeight: .infinity)  // HStack 撑满父视图
        //.background(.green)
    }
}

struct StaticButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}

#Preview {
    @State var showRecoverIcon: Bool = true
    return CJSettingTitleRow(title: "背景颜色", showRecoverIcon: $showRecoverIcon, onTapRecover: {
        
    })
}
