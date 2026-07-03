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
            CJTextColorDataModel(solidColorString: "#000000"),
            CJTextColorDataModel(solidColorString: "#FFFFFF"),
            CJTextColorDataModel(solidColorString: "#2F3F5F"),
            CJTextColorDataModel(solidColorString: "#4E5F82"),
            CJTextColorDataModel(solidColorString: "#7BAD9B"),
            CJTextColorDataModel(startPoint: .top,
                                 endPoint: .bottom,
                                 colorStrings: ["#1F625C","#7CB1AE"]),
            CJTextColorDataModel(startPoint: .top,
                                 endPoint: .bottom,
                                 colorStrings: ["#74A7CB","#D4CAD4"]),
            CJTextColorDataModel(startPoint: .topLeading,
                                 endPoint: .bottomTrailing,
                                 colorStrings: ["#E5CCEF","#C265D8"]),
            CJTextColorDataModel(startPoint: .topLeading,
                                 endPoint: .bottomTrailing,
                                 colorStrings: ["#B69DEE","#E4D9F3"]),
            CJTextColorDataModel(startPoint: .top,
                                 endPoint: .bottom,
                                 colorStrings: ["#503F8B","#BB3D72"]),
            CJTextColorDataModel(startPoint: .top,
                                 endPoint: .bottom,
                                 colorStrings: ["#C5AAAB","#505699"]),
        ]
        
        for (index, model) in colorModels.enumerated() {
            model.id = "\(index)"
            colorModels[index] = model
        }
        return colorModels
    }


    static func fontColorData() -> [CJTextColorDataModel] {
        var colorModels = [
            CJTextColorDataModel(solidColorString: "#000000"),
            CJTextColorDataModel(solidColorString: "#FFFFFF"),
            CJTextColorDataModel(solidColorString: "#629FBD"),
            CJTextColorDataModel(solidColorString: "#BBDDBF"),
            CJTextColorDataModel(solidColorString: "#E9D998"),
            CJTextColorDataModel(topColorString: "#DAFFE2", bottomColorString: "#C6DB9D"),
            CJTextColorDataModel(topLeadingColorString: "#FAC9E2", bottomTrailingColorString: "#959DF2"),
            CJTextColorDataModel(topLeadingColorString: "#DAFFE2", bottomTrailingColorString: "#F6DBFC"),
            CJTextColorDataModel(topLeadingColorString: "#E0C1FB", bottomTrailingColorString: "#258EF8"),
        ]
        for (index, model) in colorModels.enumerated() {
            model.id = "\(index)"
            colorModels[index] = model
        }
        return colorModels
    }

    
    static func fontModels() -> [CJFontDataModel] {
        return [
            CJFontDataModel(
                name: "zcool-gdh",
                egImage: "fontImage_5"
            ),
            CJFontDataModel(
                name: "Resource-Han-Rounded-CN-Bold",
                egImage: "fontImage_6"
            ),
            CJFontDataModel(
                name: "AlimamaShuHeiTi-Bold",
                egImage: "fontImage_1"
            ),
            CJFontDataModel(
                name: "WenCang-Regular",
                egImage: "fontImage_7"
            ),
            CJFontDataModel(
                name: "baotuxiaobaiti",
                egImage: "fontImage_2"
            ),
            CJFontDataModel(
                name: "HappyZcool-2016",
                egImage: "fontImage_3"
            ),
            CJFontDataModel(
                name: "zcoolqingkehuangyouti-Regular",
                egImage: "fontImage_4"
            ),
        ]
    }
    
    static func backgroundBorderData() -> [CJBorderDataModel] {
        return [
            CJBorderDataModel(imageName: "border_8"),
            CJBorderDataModel(imageName: "border_9"),
            CJBorderDataModel(imageName: "border_7"),
            CJBorderDataModel(imageName: "border_10"),
            CJBorderDataModel(imageName: "border_12"),
            CJBorderDataModel(imageName: "border_4"),
            CJBorderDataModel(imageName: "border_6"),
            CJBorderDataModel(imageName: "border_2"),
            CJBorderDataModel(imageName: "border_5"),
            
        ]
    }

}
