//
//  ContentView.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/12/15.
//

import SwiftUI
import CJViewElement_Swift

struct ContentView: View {
    @State var count: Int = 0
    @State var countModel: CountModel = CountModel(count: 0)
//    @State var configModel: CQWidgetModel = CQWidgetModel()
    
    var initLayout: CJTextLayoutModel {
        //let font: Font = .system(size: 15, weight: .bold)
        let font: CJFontDataModel = CJFontDataModel(
            name: "WenCang-Regular",
            egImage: "fontImage_7"
        )
        let background: CJBoxDecorationModel = CJBoxDecorationModel(
            colorModel: CJTextColorDataModel(solidColorString: "#00FF00")
        )
        let initLayout =  CJTextLayoutModel(left: 0, top: 0, width: 40, height: 200, lineLimit: 1, fontSize: 15, fontWeight: .bold, font: font, foregroundColor: "#FFFF00", backgroundColor: "#FF00FF", textAlignment: .center, multilineTextAlignment: .center, minimumScaleFactor: 1, borderCornerRadius: 10, background: background)
        return initLayout
    }
    
    var body: some View {
        NavigationView {
            List {
                Button("\(count) +1") {
                    count = count + 1
                }
                

                HStack {
                    CJVEVerticalTextView(
                        text: .constant("年年岁岁花相似"),
                        maxLines: .constant(4),
                        layoutModel: .constant(initLayout)
                    ).frame(height: initLayout.height)
                    
                    CJVEVerticalTextView(
                        text: .constant("年年岁岁花相似"),
                        maxLines: .constant(10),
                        layoutModel: .constant(initLayout)
                    ).frame(height: initLayout.height)
                    
                    CJVerticalTextView(text: "年年岁岁花相似", font: .custom("WenCang-Regular", size: 15), height: 200)
                    
                    CJVerticalTextView(text: "年年岁岁花相似", font: .system(size: 15, weight: .bold), height: 200)
                }
                
                
                NavigationLink(destination: DetailView(count: $count)) {
                    Text("Go to Detail View")
                }
                
                Button("\(countModel.count) +1") {
                    countModel.count = countModel.count + 1
                }
                NavigationLink(destination: DetailView(count: $countModel.count)) {
                    Text("Go to Detail View")
                }
                
                Button("检查 countModel 的值") {
                    debugPrint("countModel:\(countModel)")
                }
                NavigationLink(destination: DetailCountView(countModel: $countModel)) {
                    Text("Go to Detail View")
                }
                
                
//                Button("检查 configModel 的值") {
//                    debugPrint("configModel:\(configModel)")
//                }
//                NavigationLink(destination: CJToolView(model: $configModel)) {
//                    Text("CJToolView")
//                }
//                
//                NavigationLink(destination: CJSquareSubView(anyComponentModel: $configModel.anyComponentModel)) {
//                    Text("CJSquareSubView")
//                }
//                
//                NavigationLink(destination: TSViewCreatorPage(model: $configModel)) {
//                    Text("TSViewCreatorPage")
//                }
                NavigationLink(destination: TSViewCreatorPage()) {
                    Text("TSViewCreatorPage")
                }
            }
        }.onAppear() {
            countModel = CountModel(count: 0)
//            configModel = CQWidgetModel("countdown_middle_3_123_diffcom")
//            debugPrint("onAppear countModel:\(countModel)")
//            debugPrint("onAppear configModel:\(configModel)")
        }
    }
}

struct CountModel {
    var count: Int
}

struct DetailCountView: View {
    @Binding var countModel: CountModel
    var body: some View {
        Text("Detail View: \(countModel.count)")
    }
}

struct DetailView: View {
    @Binding var count: Int
    var body: some View {
        Text("Detail View: \(count)")
    }
}

#Preview {
    ContentView()
}
