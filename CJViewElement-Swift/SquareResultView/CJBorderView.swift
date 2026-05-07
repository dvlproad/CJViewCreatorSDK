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
    
    public init(borderModel: Binding<CJBorderDataModel>, makeupBorderNameBlock: @escaping (_: String) -> String) {
        self._borderModel = borderModel
        self.makeupBorderNameBlock = makeupBorderNameBlock
        self._dealUpdateUI = .constant(0)
    }
    
    public init(borderModel: Binding<CJBorderDataModel>, makeupBorderNameBlock: @escaping (_: String) -> String, dealUpdateUI: Binding<Int>) {
        self._borderModel = borderModel
        self.makeupBorderNameBlock = makeupBorderNameBlock
        self._dealUpdateUI = dealUpdateUI
    }
    
    public var body: some View {
        let _ = dealUpdateUI
        GeometryReader { geometry in
            let borderImageName = makeupBorderNameBlock(borderModel.imageName)
            let uiimage : UIImage? = UIImage(named: borderImageName)
            if uiimage != nil {
                let image = Image(uiImage: uiimage!)
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
            }
        }
    }
    
}

