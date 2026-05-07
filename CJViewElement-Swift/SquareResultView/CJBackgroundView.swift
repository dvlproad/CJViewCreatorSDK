//
//  CJBackgroundView.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/12/15.
//

import SwiftUI

public struct CJBackgroundView: View {
    @Binding var backgroundModel: CJBoxDecorationModel
    @Binding var dealUpdateUI: Int
    
    public init(backgroundModel: Binding<CJBoxDecorationModel>) {
        self._backgroundModel = backgroundModel
        self._dealUpdateUI = .constant(0)
    }
    
    public init(backgroundModel: Binding<CJBoxDecorationModel>, dealUpdateUI: Binding<Int>) {
        self._backgroundModel = backgroundModel
        self._dealUpdateUI = dealUpdateUI
    }
    
    public var body: some View {
        let _ = dealUpdateUI
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                if let backgroundImageModel = backgroundModel.imageModel {
                    Image(uiImage: backgroundImageModel.image ?? UIImage.init(named: "")!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else if let backgroundColorModel = backgroundModel.colorModel {
                    Rectangle()
                        .fill(backgroundColorModel.linearGradientColor)
                }            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}
