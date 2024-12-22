//
//  CJBorderView.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/12/15.
//

import SwiftUI

public struct CJBorderView: View {
    @Binding var borderModel: CJBorderDataModel
    var makeupBorderNameBlock: ((_ borderPrefixImageName: String) -> String)
    
    public init(borderModel: Binding<CJBorderDataModel>, makeupBorderNameBlock: @escaping (_: String) -> String) {
        self._borderModel = borderModel
        self.makeupBorderNameBlock = makeupBorderNameBlock
    }
    
    public var body: some View {
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

