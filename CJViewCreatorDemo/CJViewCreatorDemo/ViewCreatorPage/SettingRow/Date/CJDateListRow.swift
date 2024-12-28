//
//  CJDateListRow.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/11/25.
//

import SwiftUI
import WidgetKit
import CQDemoKit

// MARK: - 数据模型
//struct CJCommemorationComponentConfigModel: Identifiable {
//    let id = UUID()
//    let title: String
//    let dateString: String
//    var backgroundColor: Color = .yellow
//}
class UIUpdateModel: ObservableObject {
    @Published var shouldUpdate: Bool = false
    
    func updateListeners() {
        shouldUpdate.toggle()
    }
}



// MARK: - 主视图
struct CJDateListRow: View {
    //@Binding var shouldUpdateUI: Bool
    @EnvironmentObject var uiUpdateObserver: UIUpdateModel
    
    let minCount: Int
    let maxCount: Int
    @Binding var items: [CJCommemorationComponentConfigModel]
    let currentIndex: Int
    let newItemWidgetFamily: WidgetFamily = .systemMedium
    let valueChangeBlock: (_ newItems: [CJCommemorationComponentConfigModel], _ newSelectedIndex: Int, _ oldCount: Int, _ newCount: Int) -> Void // 添加、删除、切换选中
    
//    init(minCount: Int = 0, maxCount: Int = 10, items: Binding<[CJCommemorationComponentConfigModel]>, currentIndex: Int = 0, valueChangeBlock: @escaping (_ newItems: [CJCommemorationComponentConfigModel], _ newSelectedIndex: Int, _ oldCount: Int, _ newCount: Int) -> Void
//    ) {
//        self.valueChangeBlock = valueChangeBlock
////        self.itemCountChange = itemCountChange
//        
////        self._items = State(initialValue: items)
//        self._items = items
//        self.minCount = minCount
//        self.maxCount = maxCount
//        self.currentIndex = currentIndex
//    }
    
    var body: some View {
        let allowsDelete = items.count > 1
        
        VStack(alignment: .leading, spacing: 0) {
            // 标题栏
            HStack(alignment: .center, spacing: 0) {
                Text("我的倒数日")
                    .foregroundColor(Color(hex: "#333333"))
                    .font(.system(size: 15))
                Text("(\(items.count)/\(maxCount))")
                    .foregroundColor(Color(hex: "#999999"))
                    .font(.system(size: 12))
            }
//            .background(Color.orange)
            
            HStack(spacing: 6) {
                // 添加按钮
                AddButton {
                    if items.count >= maxCount {
                        CJUIKitToastUtil.showMessage("最多添加\(maxCount)个")
                        return
                    }
                    let newItem = CJCommemorationComponentConfigModel(title: "", date: Date(), cycleType: .year, shouldContainToday: false, family: newItemWidgetFamily, index: items.count) // 默认关闭
                    // 添加在头部
  
                    items.insert(newItem, at: 0)
                    valueChangeBlock(items, 0, items.count-1, items.count)
                    // 添加在尾部
                    // items.append(newItem)
                    //onClickItem(items.count-1, items.count-1, items.count)
                    
//                    self.itemCountChange(items.count-1, items.count)
                }
                
                // 内容区
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10-2*2) {
                        ForEach(0..<items.count, id:\.self) { index in
                            let itemModel: CJCommemorationComponentConfigModel = items[index]
                            let item: CJCommemorationDataModel = itemModel.data
                            
                            CountdownLabel(
                                title: item.title,
                                date: item.stringForDateCollectionView(),
//                                backgroundColor: item.backgroundColor,
                                isEditing: index == currentIndex,
                                allowDelete: allowsDelete,
                                onDelete: {
                                    if items.count <= 1 {
                                        CJUIKitToastUtil.showMessage("最少添加\(minCount)个")
                                        return
                                    }
                                    items.remove(at: index)
                                    
                                    var newSelectedIndex = -1
                                    if items.isEmpty {
                                        newSelectedIndex = -1
                                    } else {
                                        newSelectedIndex = max(0, index-1)
                                    }
                                    valueChangeBlock(items, newSelectedIndex, items.count+1, items.count)
                                }
                            ).onTapGesture {
                                valueChangeBlock(items, index, items.count, items.count)
                            }
                        }
                    }
                }
            }
        }
    }
}



// MARK: - 添加按钮
struct AddButton: View {
    let onAdd: () -> Void
    
    var body: some View {
        Button(action: onAdd) {
            ZStack {
                RoundedRectangle(cornerRadius: 13)
                    .fill(Color(hex: "#E5E5E5"))
                    .frame(width: 60, height: 60)
                
                Image(systemName: "plus")
                    .foregroundColor(Color(hex: "#2E2E2E"))
                    .font(.system(size: 30, weight: .medium))
            }
        }
        .frame(width: 60, height: 60)
        //.backgroundColor(Color.green)
    }
}



// MARK: - 倒数日标签
struct CountdownLabel: View {
    let title: String
    let date: String
//    let backgroundColor: Color?
    let isEditing: Bool
    let allowDelete: Bool
    let onDelete: () -> Void
    
    @ViewBuilder
    var body: some View {
        ZStack(alignment: .topTrailing) {
            // 主要内容
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .lineLimit(1)
                    .foregroundColor(Color(hex: "#333333"))
                    .font(.system(size: 13))
//                    .padding(.trailing, 20) // 为删除按钮留出空间
                
                Text(date)
                    .foregroundColor(Color(hex: "#333333"))
                    .font(.system(size: 11))
            }
//            .padding(.horizontal, 12)
//            .padding(.vertical, 24)
            .frame(width: 90, height: 60)
            .background(
                RoundedRectangle(cornerRadius: 13)
                    .fill(Color(hex: "#FFE352").opacity(isEditing ? 1.0 : 0.3))
            )
            
            // 删除按钮
            if allowDelete {
                Button(action: onDelete) {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(.black)
                        .font(.system(size: 16))
                }
                .offset(x: 5, y: -5)
            }
        }
        .frame(width: 100, height: 80)
        //.backgroundColor(Color.red)
    }
}

// MARK: - 预览 CountdownLabel
struct CountdownLabel_Previews: PreviewProvider {
    static var previews: some View {
        CountdownLabel(
            title: "国庆节",
            date: "2024-10-01",
            isEditing: true,
            allowDelete: true,
            onDelete: {
                // 这里可以放置一个打印语句或者实际的删除逻辑
                print("Delete button tapped")
            }
        )
        .previewLayout(.sizeThatFits)
        .padding() // 给预览添加一些边距
        .background(Color.blue) // 给预览添加一个白色背景
    }
}





// MARK: - 预览 CCDatesSettingSubView
struct CJDateListRow_Previews: PreviewProvider {
    static var previews: some View {
        
        let dataAndLayoutModels: [CJCommemorationComponentConfigModel] = createDataAndLayoutModels()
        //let items = dataAndLayoutModels.map { $0.data }
        
        CJDateListRow(minCount: 1, maxCount: 3, items: .constant(dataAndLayoutModels), currentIndex: 3, valueChangeBlock: { newItems, newSelectedIndex, oldCount, newCount in
            
        })
        .previewLayout(.sizeThatFits)
        .padding() // 给预览添加一些边距
        .background(Color.gray.opacity(0.3)) // 给预览添加一个白色背景
    }

    /// 这个函数负责构建 dataAndLayoutModels 数组
    private static func createDataAndLayoutModels() -> [CJCommemorationComponentConfigModel] {
        let dataAndLayoutModels: [CJCommemorationComponentConfigModel] = CJAllComponentConfigModel.getDefaultDataByLayoutId("").commemorationComponents
        return dataAndLayoutModels
    }
}
