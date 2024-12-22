//
//  CJSettingTitleRow.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/12/15.
//

import SwiftUI

public struct CJSettingTitleRow: View {
    var title: String
    @Binding var showRecoverIcon: Bool
    var onTapRecover: (() -> Void)?
    
    public var body: some View {
        HStack(spacing: 0) {
            Text(title)
                .foregroundColor(Color(hex: "#333333"))
                .font(.system(size: 15.5, weight: .medium))
            
            Button(action: {
                onTapRecover?()
            }, label: {
                if showRecoverIcon {
                    Image("recover")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 12, height: 12)
                }
                
            })
            .frame(width: 27, height: 30)
            .background(.clear)
            .cornerRadius(0)
            .buttonStyle(StaticButtonStyle())
            
            Spacer()
        }
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
