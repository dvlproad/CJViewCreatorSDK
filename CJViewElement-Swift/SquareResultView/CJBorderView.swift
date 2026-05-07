//
//  CJBorderView.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/12/15.
//

import SwiftUI

public struct CJBorderView: View {
    @Binding var borderModel: CJBorderDataModel
    @Binding var dealUpdateUI: Int
    var makeupBorderNameBlock: ((_ borderPrefixImageName: String) -> String)
    var cornerRadius: CGFloat
    
    public init(borderModel: Binding<CJBorderDataModel>, cornerRadius: CGFloat = 0, makeupBorderNameBlock: @escaping (_: String) -> String) {
        self._borderModel = borderModel
        self.cornerRadius = cornerRadius
        self.makeupBorderNameBlock = makeupBorderNameBlock
        self._dealUpdateUI = .constant(0)
    }
    
    public init(borderModel: Binding<CJBorderDataModel>, cornerRadius: CGFloat = 0, makeupBorderNameBlock: @escaping (_: String) -> String, dealUpdateUI: Binding<Int>) {
        self._borderModel = borderModel
        self.cornerRadius = cornerRadius
        self.makeupBorderNameBlock = makeupBorderNameBlock
        self._dealUpdateUI = dealUpdateUI
    }
    
    public var body: some View {
        let _ = dealUpdateUI
        GeometryReader { geometry in
            if let imageName = borderModel.imageName,
               !imageName.isEmpty,
               let uiimage = UIImage(named: makeupBorderNameBlock(imageName)) {
                let image = Image(uiImage: uiimage)
                AnyView(
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                    //                .mask(
                    //                    image
                    //                        .resizable()
                    //                        .aspectRatio(contentMode: .fill)
                    //                    //                        .frame(width: imageSize.width, height: imageSize.height)
                    //                )
                )
            } else if let borderColorString = borderModel.borderColorString, !borderColorString.isEmpty {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(Color(hex: borderColorString), lineWidth: 8)
                    .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
    }
    
}
