# CJViewCreatorSDK

SwiftUI 组件创建工具集，提供可配置的视图元素、组件模型及设置界面，帮助快速构建 iOS 应用界面和 Widget 小组件。

## 功能特性

- **组件配置模型**：支持文本、边框、背景、字体、颜色等多种组件类型的配置
- **SwiftUI 视图组件**：提供 `CJSquareView`、`CJToolView` 等可复用视图
- **设置行组件**：内置字体、颜色、背景、边框等常用设置界面
- **Widget 支持**：完整的小组件配置和渲染能力
- **扩展工具**：颜色、字符串、图片等常用扩展

## 项目结构

```
CJViewCreatorSDK/
├── CJViewElement-Swift/          # 核心库
│   ├── Extension/                # Swift 扩展（Color、String、Image）
│   ├── ElementModel/             # 基础模型（布局、背景、边框等）
│   ├── ComponentConfigModel/     # 组件配置模型
│   ├── CommonSettingRow/         # 通用设置行组件
│   └── SquareResultView/         # 方形结果视图
├── CJViewCreatorDemo/            # 演示项目
│   └── ViewCreatorPage/          # 视图创建页面示例
└── LICENSE                       # MIT 许可证
```

## 安装

### CocoaPods

在 `Podfile` 中添加：

```ruby
pod 'CJViewElement-Swift', :path => 'path/to/CJViewElement-Swift'
```

或远程依赖：

```ruby
pod 'CJViewElement-Swift'
```

然后执行：

```bash
pod install
```

## 快速开始

### 1. 基础使用

```swift
import SwiftUI
import CJViewElement_Swift

struct ContentView: View {
    @State var model: CQWidgetModel = CQWidgetModel("your_template_id")
    @State var backgroundModel: CJBoxDecorationModel = CJBoxDecorationModel()
    @State var anyComponentModel: CJAllComponentConfigModel = CJAllComponentConfigModel()
    @State var borderModel: CJBorderDataModel = CJBorderDataModel()
    @State var dealUpdateUI: Int = 0
    
    var body: some View {
        CJSquareView(
            backgroundModel: $backgroundModel,
            anyComponentModel: $anyComponentModel,
            borderModel: $borderModel,
            widgetFamily: .systemMedium,
            dealUpdateUI: $dealUpdateUI
        )
    }
}
```

### 2. 使用工具视图

```swift
CJToolView(model: $model, onChangeOfElementModel: { newModel in
    // 处理组件模型变更
    backgroundModel = newModel.backgroundModel
    anyComponentModel = newModel.anyComponentModel
    borderModel = newModel.borderModel
    dealUpdateUI += 1
})
```

### 3. 配置组件

```swift
// 文本组件
let textComponent = CJTextComponentConfigModel()
textComponent.data.text = "Hello World"
textComponent.layout.font = CJFontDataModel(id: "1", name: "System", egImage: nil)

// 背景组件
let backgroundModel = CJBoxDecorationModel(
    colorModel: CJTextColorDataModel(solidColorString: "#FF5500")
)

// 边框组件
let borderModel = CJBorderDataModel(id: "border_1", imageName: "border_image")
```

## 核心组件

| 组件 | 说明 |
|------|------|
| `CJSquareView` | 方形视图容器，支持背景、组件、边框配置 |
| `CJToolView` | 工具设置视图，包含字体、颜色、背景等设置项 |
| `CJFontSettingRow` | 字体设置行 |
| `CJTextColorSettingRow` | 文本颜色设置行 |
| `CJBackgroundSettingRow` | 背景设置行 |
| `CJBorderSettingRow` | 边框设置行 |
| `CJDatesSettingView` | 日期设置视图 |
| `CJTextsSettingView` | 文本设置视图 |



## TODO

【Feature】尝试对 位置与尺寸的设置视图 进行新增恢复动作。但失败，原因 CJPositionSizeSettingRow 里 onChange之后触发了更新UI，然后又重新走到了CJPositionSizeSettingRow 的init里，导致origin使用了onChange之后的值。所以待继续修改，其他的也类似，可以考虑 onChange 触发的更新UI，在 TSViewCreatorPage 中能否只更新 CJSquareView ，而不更新 CJToolView。



## 系统要求

- iOS 17.0+
- Swift 5.0+
- Xcode 15.0+

## 许可证

MIT License，详见 [LICENSE](LICENSE) 文件。

## 作者

dvlproad
