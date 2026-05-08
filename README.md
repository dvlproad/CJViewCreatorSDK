# CJViewCreatorSDK

SwiftUI 组件创建工具集，提供可配置的视图元素、组件模型及设置界面，帮助快速构建 iOS 应用界面和 Widget 小组件。

## 开发记录原则

本项目开发过程中，凡是会影响后续实现判断的内容，都需要实时补充到根目录 `README.md`，避免后续重新开发时重复踩坑。

需要记录的内容包括：

- 功能要求：例如某个控件应该支持哪些设置项、某类文本是否应该当作纪念日处理。
- 设计思路：例如工具区与预览区的刷新方向、元素设置 Section 的职责边界。
- 功能要点：例如 `layout` 和 `addGR` 的 modifier 顺序、预览拖动结束后不能重建整个工具区。
- 关键坑点：例如 class 内部属性变化不会自动触发 SwiftUI 刷新、恢复 original 的捕获时机。

记录原则是：只要一个结论会影响未来如何写代码、如何拆类、如何处理状态同步，就应该写进 README；普通临时代码细节可以只写在代码注释里。

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
    @State var toolUpdateUI: Int = 0
    
    var body: some View {
        CJSquareView(
            backgroundModel: $backgroundModel,
            anyComponentModel: $anyComponentModel,
            borderModel: $borderModel,
            widgetFamily: .systemMedium,
            dealUpdateUI: $dealUpdateUI,
            toolUpdateUI: $toolUpdateUI
        )
    }
}
```

### 2. 使用工具视图

```swift
CJToolView(model: $model, toolUpdateUI: $toolUpdateUI, onChangeOfElementModel: { newModel in
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

因此 `layout` 提供了一个装饰闭包，用来把额外修饰插入到“内容盒子和持久几何变换之后、位置偏移之前”：

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

持久旋转在普通态和编辑态的处理不同：

- 普通态不传 `decorateContent`，由 `layout` 自己应用 `rotationDegrees` 后再执行 `left/top` 偏移。
- 编辑态传 `decorateContent`，由 `addGR(baseRotation:)` 接管 `rotationDegrees`，让内容和编辑边框一起旋转；`layout` 只负责最后的 `left/top` 偏移。

预览区不要在 `CJTextsView` 这类列表容器里直接手写这两个分支，而是封装成预览专用元素视图，例如 `CJPreviewTextElementView`：

- `CJTextsView` 只负责遍历文本模型、传入 `isEditing` 和手势结束回调。
- `CJPreviewTextElementView` 内部负责判断普通态/编辑态。
- 普通态使用不带 `decorateContent` 的 `CJTextView` 初始化，让 `layout` 自己应用持久旋转。
- 编辑态使用带 `decorateContent` 的 `CJTextView` 初始化，并在闭包里插入 `addGR(baseRotation:)`。

这样做的重点不是减少代码，而是把容易误用的 `CJTextView { content in ... }` 入口收在预览元素内部。以后如果图片、贴纸、日期子文本也需要编辑框和手势，也应该各自有对应的 `CJPreview...ElementView` 或统一的预览元素包装层，而不是让列表容器直接拼装底层展示视图和编辑手势。

不要为了减少这点重复，在普通态的 `decorateContent` 里手动写 `content.rotationEffect(.degrees(layout.rotationDegrees))`。那会把 `layout` 内部“谁负责持久旋转”的细节泄漏到业务视图里，后面维护时很容易误改。

不要把持久 `rotationDegrees` 放在 `addGR` 外层再执行。否则大角度旋转后，`addGR` 拖动时的临时 offset 会被外层旋转影响；放手写回屏幕坐标 translation 时，边框和内容的坐标系不一致，就会出现位置跳动或边框不跟着旋转的问题。

另外，`addGR` 内部不能通过给 content 加 padding 来扩大角按钮命中区域。padding 会参与布局，导致选中文本时位置发生变化。角按钮的外扩命中区域应该放在 overlay 层处理，边框则应贴着原始内容盒子绘制。

### Layout 模型职责

`CJBaseLayoutModel` 承载所有可视元素共有的几何布局属性。当前包含 `left/top/width/height/scale/rotationDegrees`，缩放和旋转都放在 `CJBaseLayoutModel`，而不是只放在 `CJTextLayoutModel`。

几何变换字段：

- `scale: CGFloat = 1`
- `rotationDegrees: CGFloat = 0`

原因：

- 缩放和旋转不是文本专属能力，未来图片、贴纸、日期子文本等元素也可能需要。
- `addGR` 的拖动、缩放、旋转属于同一类几何变换，持久化位置尺寸时也应该能持久化缩放和旋转。
- 放在 base layout 后，`CJElementLayoutStyleSettingSection` 这类通用元素设置区以后可以统一扩展“缩放/旋转”设置，而不用为每种元素重复加字段。
- 对文本来说，手势缩放不只是改变 `width/height`，还应该让文字视觉大小按比例变化。因此文本渲染时使用 `fontSize * scale`，保留 `fontSize` 作为原始字体大小。

但不要把所有可能的属性都塞进 `CJBaseLayoutModel`。Base layout 只放所有元素都可能共享的几何/容器属性，例如位置、尺寸、缩放、旋转、圆角、背景。文本内容、字体、字体颜色、行数等仍然属于 `CJTextLayoutModel` 或文本样式设置；图片资源、裁剪方式等未来应该属于图片自己的 layout/data。

缩放/旋转持久化必须同步更新这些地方：`copy`、`Equatable`、`Codable`、`layout` 修饰符、`CJGRTransformResult` 写回逻辑，以及位置尺寸设置区是否展示缩放/旋转输入。

`CJPositionSizeSettingRow` 虽然保留了旧名字，但职责已经是“几何设置”：除了 `left/top/width/height`，还必须展示和设置 `scale/rotationDegrees`。位置、尺寸、旋转按整数展示；缩放倍数允许保留小数。

因为这个 Row 已经是几何设置，所有接收 `onChangeOfPositionSize` 的地方都不能只回写 `left/top/width/height`。恢复、手动输入、预览手势同步时，都必须一起回写 `scale/rotationDegrees`，否则会出现重置后位置尺寸恢复了，但字体大小或旋转仍然保留旧状态的问题。

`CJLayoutInputView` 负责编辑一组 layout 几何属性，内部的 `CJLayoutPropertyInputView` 负责编辑单个属性。加减按钮和文本输入框不能只依赖 `.onChange(of:)` 观察绑定值。当前 layout 是 class，`CJPositionSizeSettingRow` 里的 `@State currentLayout` 持有的是对象引用；修改 `currentLayout.left` 这类内部属性时，引用本身没有变化，SwiftUI 可能不会触发 `.onChange`。因此按钮点击和输入框 setter 必须主动调用提交方法，并在里面执行外层 `onChange`，确保工具区操作能立刻通知预览区刷新。

当 `addGR` 提供 `onTransformEnded` 回调时，手势内部的拖动、缩放、旋转只是临时预览状态，结束后要写回 layout，并清掉内部临时状态。如果外部已经把 `deltaScale` 写入 `layout.scale`、把 `deltaRotation` 写入 `layout.rotationDegrees`，`CJGRViewModifier` 内部就不能再累计自己的 `scale/rotation`，否则会出现双重缩放或双重旋转。

### 预览区与工具区的刷新方向

`ToolView` 和预览区都可能修改同一份组件模型，但它们的刷新方向不能混用同一个信号：

- 工具区修改模型时，只通知预览区刷新。
- 预览区手势修改模型时，只通知工具区刷新。

目前页面里用两个刷新触发值表达这个方向：

- `dealUpdateUI`：工具区修改模型后递增，预览区监听它并重新读取模型。
- `toolUpdateUI`：预览区拖动、缩放等手势修改模型后递增，工具区的布局设置区域监听它并重新读取 layout。

这样做的原因是：`CJAllComponentConfigModel` 和 layout model 都是 class，很多修改是直接改内部属性。SwiftUI 不会因为 class 内部属性变化自动刷新依赖视图，所以需要额外的刷新触发值。但这个触发值必须区分来源，否则会形成“预览区更新位置 -> 工具区数值更新 -> 工具区又触发位置更新 -> 预览区再刷新”的回声循环。

预览区手势结束后不要重建整个 `ToolView` 或整个 `CJTextsSettingView`。拖动只是在修改当前元素的位置尺寸，不代表用户切换了编辑对象。正确做法是只让 `CJElementLayoutStyleSettingSection` 这类布局设置区域重新初始化，使位置数值读取最新 layout，同时保留列表 `currentIndex`、分段选中项等编辑态。

预览区自身也需要一个局部刷新触发值。拖动结束时，`addGR` 的临时位移会清零，同时新的 `left/top` 已经写入 layout；但 layout 是 class 内部属性，SwiftUI 不一定会立刻重新执行当前 `CJTextView` 的布局。如果不刷新当前文本子树，就会出现 ToolView 数值已经变化，而预览图里的文本又回到拖动前位置的问题。这个刷新只用于预览内部重新按新 layout 布局，不要复用 `dealUpdateUI` 做全量刷新。

同理，工具区修改位置、尺寸、字体、颜色等 layout/data 后，`dealUpdateUI` 到达预览区时，预览区除了重新读取模型，也要递增自己的局部刷新触发值，让当前文本子树立刻按新的 class 内部属性重建。这个动作只能发生在预览内部，不能顺手递增 `toolUpdateUI`，否则会形成工具区 -> 预览区 -> 工具区的反向刷新。

`addGR` 内部同时组合了拖动、缩放、旋转手势。手势结束时可能会产生没有实际变化的空变换，例如 `translation = .zero`、`scale = 1`、`rotation = 0`。这类空变换不能继续触发 layout 写回、预览局部刷新或工具区刷新，否则放手瞬间会因为多次无意义重建产生抖动。

后续新增类似能力时也按这个原则处理：谁发起修改，就只通知对侧刷新；不要让接收方再用同一个刷新信号反向触发发起方。



## TODO

【Feature】位置与尺寸的“恢复”动作仍需继续梳理。注意：恢复逻辑里的 original 值应该在进入编辑会话时捕获，不能在每次刷新工具区时被当前值覆盖。否则 `CJPositionSizeSettingRow` 重新 init 后，original 会变成已经修改过的值。



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
