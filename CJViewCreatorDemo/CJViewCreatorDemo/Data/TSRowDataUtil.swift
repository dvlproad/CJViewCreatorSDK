//
//  TSRowDataUtil.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/12/19.
//

import Foundation
import AppIntents
import WidgetKit
import CJViewElement_Swift

struct TSRowDataUtil {
    static func loadJSONFromFile(jsonFileName: String) -> String? {
        // 使用 FileManager 检查文件是否存在
        let fileManager = FileManager.default
        let bundle = Bundle.main
        let jsonFilePath = bundle.path(forResource: jsonFileName, ofType: "json")
        guard let jsonFilePath = jsonFilePath, fileManager.fileExists(atPath: jsonFilePath) else {
            return nil
        }
        
        do {
            let data = try String(contentsOfFile: jsonFilePath, encoding: .utf8)
            return data
        } catch {
            print("Error reading JSON file:  $error)")
            return nil
        }
    }
    
    static func backgroundColorData() -> [CJTextColorDataModel] {
        var colorModels = [
            CJTextColorDataModel(solidColorString: "#2F3F5E"),
            CJTextColorDataModel(solidColorString: "#4E5F83"),
        ]
        
        for (index, model) in colorModels.enumerated() {
            model.id = "\(index)"
            colorModels[index] = model
        }
        return colorModels
    }


    static func fontColorData() -> [CJTextColorDataModel] {
        var colorModels = [
            CJTextColorDataModel(solidColorString:"#FFFFFF"),
            CJTextColorDataModel(solidColorString:"#000000"),
        ]
        for (index, model) in colorModels.enumerated() {
            model.id = "\(index)"
            colorModels[index] = model
        }
        return colorModels
    }

    
    static func fontModels() -> [CJFontDataModel] {
        return [
            
        ]
    }
    
    static func backgroundBorderData() -> [CJBorderDataModel] {
        return [CJBorderDataModel(imageName: "border_1"),
                CJBorderDataModel(imageName: "border_2"),
                CJBorderDataModel(imageName: "border_3"),
                CJBorderDataModel(imageName: "border_4"),
                CJBorderDataModel(imageName: "border_5"),
                CJBorderDataModel(imageName: "border_6"),
                CJBorderDataModel(imageName: "border_7"),
                CJBorderDataModel(imageName: "border_8"),
                CJBorderDataModel(imageName: "border_9"),
                CJBorderDataModel(imageName: "border_10"),
                CJBorderDataModel(imageName: "border_11"),
                CJBorderDataModel(imageName: "border_12"),
                CJBorderDataModel(imageName: "border_13"),
                CJBorderDataModel(imageName: "border_14"),
        ]
    }

}


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

