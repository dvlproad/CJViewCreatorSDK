# Setting Row State Design

## 背景

本次整理的目标，是让 `CJTextsSettingView`、`CJBackgroundSettingRow`、`CJBorderSettingRow`、`CJFontSettingRow` 使用同一类状态设计：

- 父级持有真实业务 model。
- Setting Row 接收当前值的 `Binding`。
- Setting Row 内部保存进入时的 original 快照，用于恢复。
- 用户明确操作后，通过 callback 通知父级写回并刷新预览。

这个设计最早在 `CJTextsSettingView` 中已经自然形成。它处理文字列表、当前选中项、位置、字体、颜色等复杂编辑逻辑，因此它没有把所有中间状态都推给父级，而是在内部维护必要的编辑上下文。

## 核心原则

### 1. 重置控件必须知道 current 和 origin

这类 Setting Row 都有“恢复/重置”能力。点击恢复时，控件必须把当前值还原到“进入页面或进入这次编辑会话时的值”。

因此从能力上看，控件一定需要知道两份数据：

- `current`：当前正在编辑的值。
- `origin`：用于恢复的基准值。

设计问题不是“需不需要 origin”，而是“origin 由谁持有、通过什么方式让 Row 知道”。

### 2. 一般单值 Row：只传 current，Row 内部持有 origin

对背景、边框、字体这类单值 Setting Row 来说，origin 通常只是“这个 Row 创建时的快照”，不是父级业务概念。因此一般不需要父级同时传 `origin + current`，只需要父级传入 current binding，Row 在初始化时把 current copy 成自己的 origin。

典型结构是：

```swift
@Binding var currentModel: SomeModel
@State private var originalModel: SomeModel?
```

调用方只传 current：

```swift
SomeSettingRow(
    currentModel: Binding(
        get: { model.someModel },
        set: { model.someModel = $0 }
    ),
    onChange: { newModel in ... }
)
```

这样做的好处是：

- 父级只维护真实业务 model，不需要为每个 Row 额外保存一份 original。
- Row 的恢复逻辑内聚在 Row 内部。
- API 更短，未来增加更多设置项时不会持续膨胀父级参数。
- 避免 `CJToolView` 变成各种 original 状态的集中仓库。

它的前提是：Row 的 SwiftUI identity 要代表一次稳定的编辑会话。只要 Row 没被销毁重建，`@State` 中的 original 就不会因为父级 body 重新计算而丢失。

### 3. 同时传 origin 和 current 的适用场景

父级同时传入 original 和 current 也是一种可用设计：

```swift
SomeSettingRow(
    originalModel: originalModel,
    currentModel: $currentModel,
    onChange: { newModel in ... }
)
```

这种方式适合 origin 本身就是明确的业务概念，例如：

- 服务端原始模板值。
- 撤销栈中的恢复基准。
- 多个子 Row 必须共享同一份恢复基准。
- 列表父级统一维护每个组件的 original。

它的缺点是父级需要理解并维护更多编辑会话细节。对于普通单值 Row，如果 original 只是“进入 Row 时的快照”，把 original 上提给父级反而会让职责变重。

### 4. 列表场景：必须按组件区分 origin

列表场景是特殊情况。`CJTextsSettingView` 会在同一个设置区域里切换不同 `CJTextComponentConfigModel`，所以 origin 不能只有一份，而必须和组件 id 绑定。

列表场景通常有两种处理方式。

第一种是由列表父级统一管理 origin，例如：

```swift
@State private var originalTextLayouts: [String: CJTextLayoutModel] = [:]
```

这种方式适合“进入页面时的原始值”需要在整个列表编辑期间稳定存在。即使用户编辑了组件 A、切到组件 B、再切回组件 A，也仍然可以从 `originalTextLayouts["A"]` 找到 A 最初的值。此时如果不使用 `.id`，就应该由列表父级把对应 item 的 origin 传给子 Row。

第二种是让子 Row 自己 capture origin，但必须用 `.id(componentId)` 让子 Row 的生命周期和当前组件绑定：

```swift
CJFontSettingRow(...)
    .id("font-\(model.id)")
```

`.id("font-\(model.id)")` 的目的不是普通刷新，而是定义编辑会话身份。当当前组件从 A 切到 B 时，字体行会被当成新的 Row，重新初始化并 capture B 的 origin。如果不加 `.id`，SwiftUI 可能复用同一个 `CJFontSettingRow` 实例，导致内部的 `originalFontModel` 仍然是上一个组件的快照。

需要注意：`.id` 解决的是“不同组件不要复用同一个 Row 状态”。如果业务要求“切回组件 A 时仍然恢复到进入页面时的 A”，更稳的是第一种 `originalTextLayouts` 字典。`.id` 更适合把“切换到另一个组件”视为新的子 Row 编辑会话。

### 5. Binding setter 不负责刷新页面

`Binding` 的 setter 只负责写 current，不负责触发 `onChangeOfElementModel`。

刷新页面应该发生在明确的用户操作 callback 中：

```swift
onChangeOfBackgroundModel: { newBackgroundModel in
    model.anyComponentModel.backgroundModel = newBackgroundModel
    onChangeOfElementModel(model)
}
```

这样可以避免初始化、`onAppear`、内部同步状态时误触发页面更新。

## CJTextsSettingView

`CJTextsSettingView` 是这套设计的参考对象。

它的特点是：

- 编辑的是一组 `CJTextComponentConfigModel`。
- 有当前选中项 `currentIndex`。
- 可以新增、删除、切换文字项。
- 每个文字项都有独立的 layout、font、color 等设置。
- original 需要按 `model.id` 保存。

因此它使用：

```swift
@Binding var dateChooseModels: [CJTextComponentConfigModel]
@State var currentIndex = -1
@State private var originalTextLayouts: [String: CJTextLayoutModel] = [:]
```

当用户修改文字内容、位置、字体、颜色或列表数量时，调用 `updateUI()`，再通过 `onChangeOfDateChooseModels` 通知父级。

这套方式的好处是，复杂编辑上下文留在 `CJTextsSettingView` 内部，父级只关心最终 model 变化。

## CJBackgroundSettingRow

旧设计中，背景行存在几个问题：

- `originalBackgroundModel` 由外部传入，父级职责过重。
- 曾经用内部 `@State currentBackgroundModel`，容易和父级 model 脱节。
- 曾经在 binding setter 里触发 `onChangeOfElementModel`，初始化时可能误刷新。
- 外层曾经有重复的调色板状态，`onAppear` 设置初始颜色时可能误触发 change。

现在的设计是：

```swift
@Binding var currentBackgroundModel: CJBoxDecorationModel
@State private var originalBackgroundModel: CJBoxDecorationModel?
```

背景行只负责：

- 显示背景设置项。
- 内部保存 original。
- 用户选择颜色或点击恢复时，调用 `onChangeOfBackgroundModel`。

真正的调色板状态放在 `CJColorScrollView` 中，因为调色板属于颜色滚动控件，而不是背景行专有逻辑。

另外，颜色选中态不再只依赖 `id`。`CJTextColorDataModel` 提供了统一匹配方法：

```swift
matchesColorPreset(_:)
```

数组也提供：

```swift
firstMatchingColorIndex(_:)
```

这样即使初始 JSON 中只有 `backgroundColor`，临时转换出来的 color model 也可以通过颜色值匹配到预设项。

## CJBorderSettingRow

旧设计中，边框行的问题更明显：

- `originalBorderModel` 由外部传入。
- `currentBorderModel` 是内部 `@State`，不是父级 binding。
- 内部存在调色板相关状态，但没有完整数据模型承接。
- `CJBorderDataModel` 是 class，保存 original 时如果不 copy，会留下引用共享风险。

现在边框行改为：

```swift
@Binding var currentBorderModel: CJBorderDataModel
@State private var originalBorderModel: CJBorderDataModel?
```

并且给 `CJBorderDataModel` 增加：

```swift
public func copy() -> CJBorderDataModel
```

这样 original 是真正的快照，而不是同一个 class 引用。

边框调色板功能保留，并补齐了数据链路：

```swift
public var imageName: String?
public var borderColorString: String?
```

`imageName` 可为空，用于表达“这不是图片边框，而是颜色边框”。`CJBorderView` 渲染时先判断图片边框，再判断颜色边框：

1. `imageName` 有值且图片存在，渲染图片边框。
2. 否则 `borderColorString` 有值，渲染纯色圆角边框。

纯色边框使用和 widget 一致的 corner radius，避免直角 `Rectangle` 被外层圆角裁剪后露出背景边角。

## CJFontSettingRow

字体行也采用同一套模式：

```swift
@Binding var currentFontModel: CJFontDataModel
@State private var originalFontModel: CJFontDataModel?
```

旧设计中，字体行同时接收 `originalFontModel` 和 `currentFontModel`，并在内部用 `@State` 保存 current。这会让 current 和父级真实 model 有脱节风险，也让父级承担 original 快照管理。

现在字体行自己 capture original，父级只通过 binding 提供 current。用户选择字体或点击恢复时，通过 `onChangeOfFontModel` 通知父级写回并刷新。

在 `CJTextsSettingView` 的列表场景中，字体行通过：

```swift
.id("font-\(model.id)")
```

绑定到当前文字组件的身份。这里的 `.id` 不是为了普通刷新，而是为了避免不同文字组件复用同一个字体 Row 的 original。列表场景的两种 original 管理方式见“核心原则”第 4 节。

## 为什么不在 Row 中加入 resetKey

如果外部切换了整套 model，更合理的做法是由父级管理 SwiftUI identity，例如：

```swift
CJToolView(...)
    .id(model.id)
```

或者给具体子 view 加 `.id(...)`。

Row 本身不应该知道“模板切换”或“父级 model 替换”这种业务语义。它只需要在自身生命周期内保存 original 快照。这样和 `CJTextsSettingView` 的职责边界一致。

## 这样设计的好处

### 1. 单一真实数据源

父级 model 是真实数据源，Row 通过 binding 编辑它。不会出现 Row 内部 current 和父级 current 不一致。

### 2. 恢复逻辑内聚

original 属于编辑会话状态，放在 Row 内部更自然。父级不需要为每个设置项维护额外 original 字段。

### 3. 初始化更安全

`onAppear`、binding setter、调色板初始同步不会误触发页面刷新。只有明确用户操作才调用 change callback。

### 4. 更利于复杂扩展

未来如果背景支持图片、渐变、透明背景；边框支持图片边框、颜色边框、宽度、圆角、样式；文字支持更多组件级设置，都可以沿用同一模式：

- current 通过 binding 来自外部。
- original 在 Row 内部保存。
- 子控件处理自己的局部 UI 状态。
- 用户操作通过 callback 通知父级刷新。

### 5. 更容易复用基础控件

颜色匹配逻辑放到 `CJTextColorDataModel`，而不是散落在背景行和颜色滚动控件中。以后字体色、背景色、其他颜色设置都可以复用同一套规则。

## 后续建议

- 如果页面支持切换模板，优先在父级通过 `.id(model.id)` 让设置子树重建。
- 如果某个 Row 未来必须在不重建的情况下重置 original，再考虑显式 reset API。
- `CJTextsSettingView` 中的 `dateChooseModels` 命名已经和文字场景不完全匹配，后续可以改为更准确的 `textComponentModels`。
- 边框颜色目前使用固定线宽，未来可以把 width 加入 `CJBorderDataModel`，让颜色边框和图片边框都能通过统一 model 表达。
