//
//  CJBackgroundView.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/12/15.
//

import SwiftUI

public struct CJBackgroundView: View {
    @Binding var backgroundModel: CJBoxDecorationModel
    
    public init(backgroundModel: Binding<CJBoxDecorationModel>) {
        self._backgroundModel = backgroundModel
    }
    
    public var body: some View {
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
