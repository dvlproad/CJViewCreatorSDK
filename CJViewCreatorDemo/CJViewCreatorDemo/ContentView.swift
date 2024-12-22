//
//  ContentView.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/12/15.
//

import SwiftUI

struct ContentView: View {
    @State var count: Int = 0
    @State var countModel: CountModel = CountModel(count: 0)
//    @State var configModel: CQWidgetModel = CQWidgetModel()
    
    var body: some View {
        NavigationView {
            List {
                Button("\(count) +1") {
                    count = count + 1
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
            debugPrint("onAppear countModel:\(countModel)")
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
