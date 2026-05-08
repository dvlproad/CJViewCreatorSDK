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

## 布局与编辑态手势

文本预览里选中元素后，需要给真实文本边界加上编辑框和角按钮。这里有一个容易踩坑的点：SwiftUI 的 modifier 顺序会影响 overlay、gesture 和 offset 拿到的布局区域。

文本布局的正确顺序应该是：

```swift
Text
    -> frame(width/height) + 字体/颜色/背景/渐变
    -> 编辑态修饰，如 addGR
    -> offset(left/top)
```

如果把 `.addGR(...)` 写在 `.layout(...)` 前面：

```swift
Text(text)
    .property(layout)
    .addGR(...)
    .layout(layout)
```

`.addGR(...)` 拿到的是原始 `Text` 的 intrinsic size，而不是 `layout.width/layout.height` 后的内容盒子，边框会包在文字本身上，不会贴合组件边界。

如果把 `.addGR(...)` 写在 `.layout(...)` 后面：

```swift
Text(text)
    .property(layout)
    .layout(layout)
    .addGR(...)
```

此时 `.layout(...)` 已经执行了 `offset(left/top)`。外层再加 overlay/gesture 时，拿到的是 offset 参与后的复合布局区域，边框位置容易和实际视图边界不一致。

因此 `layout` 提供了一个装饰闭包，用来把额外修饰插入到“内容盒子之后、位置偏移之前”：

```swift
Text(text)
    .property(layout)
    .layout(layout) { content in
        content.addGR(...)
    }
```

普通展示仍然直接使用原来的写法：

```swift
Text(text)
    .property(layout)
    .layout(layout)
```

更推荐在业务视图里使用 `CJTextView`，让它统一处理 `property`、普通颜色/渐变分支和 `layout`：

```swift
// 普通展示
CJTextView(text: $text, layoutModel: $layout)

// 编辑态展示
CJTextView(text: $text, layoutModel: $layout) { content in
    content.addGR(...)
}
```

`CJTextView` 的装饰闭包只是把编辑能力插入到 `layout` 的正确位置；不需要编辑能力时，它仍然走普通 `layout` 流程。

另外，`addGR` 内部不能通过给 content 加 padding 来扩大角按钮命中区域。padding 会参与布局，导致选中文本时位置发生变化。角按钮的外扩命中区域应该放在 overlay 层处理，边框则应贴着原始内容盒子绘制。



## TODO

【Feature】尝试对 位置与尺寸的设置视图 进行新增恢复动作。但失败，原因 CJPositionSizeSettingRow 里 onChange之后触发了更新UI，然后又重新走到了CJPositionSizeSettingRow 的init里，导致origin使用了onChange之后的值。所以待继续修改，其他的也类似，可以考虑 onChange 触发的更新UI，在 TSViewCreatorPage 中能否只更新 CJSquareView ，而不更新 CJToolView。



## 注意

由于 CJAllComponentConfigModel 是 class（引用类型），当 CJToolView 修改 model.anyComponentModel 内部属性时，实际上修改的是同一个对象实例。SwiftUI 的 @Binding 对于 class 类型的内部属性变化不会自动触发视图刷新，因为 Binding 只检测到引用地址没变。

详情请看： [SwiftUIRefreshSolutions.md](SwiftUIRefreshSolutions.md)

子控件 SettingRow 的设计原则见 [Setting Row State Design.md](SettingRowStateDesign.md)



## 系统要求

- iOS 17.0+
- Swift 5.0+
- Xcode 15.0+

## 许可证

MIT License，详见 [LICENSE](LICENSE) 文件。

## 作者

dvlproad
