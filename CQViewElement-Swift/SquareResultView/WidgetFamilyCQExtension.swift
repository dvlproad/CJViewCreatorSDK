//
//  WidgetFamilyCQExtension.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/12/19.
//

import WidgetKit

extension WidgetFamily {
    /// 设计大小
    var designSize: CGSize {
        switch self {
        case .systemSmall:
            return .init(width: 166, height: 166)
        case .systemMedium:
            return .init(width: 333, height: 157)
        case .systemLarge:
            return .init(width: 333 * 0.953, height: 333)
        case .accessoryCircular:
            return .init(width: 76, height: 76)
        case .accessoryRectangular:
            return .init(width: 172, height: 76)
        case .accessoryInline:
            return .init(width: 225, height: 26)
        default:
            return .zero
        }
    }
     
    
    func makeupBorderName(_ borderPrefixImageName: String) -> String {
        switch self {
        case .systemMedium:
            return borderPrefixImageName + "_4x2.webp"
        case .systemLarge:
            return borderPrefixImageName + "_4x4.webp"
        default:
            return borderPrefixImageName + "_2x2.webp"
        }
    }
    
    
    func getCornerRadius(_ height: CGFloat = 0) -> CGFloat {
        let styleType = "W4H1"
        if styleType == "W4H1", height > 0  {
            return height / 2.0
        }
        if styleType == "W1H1" || styleType == "W2H1" {
            return height * 0.177
        }
        
        return 19.5
    }
    
}

