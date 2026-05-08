# CJGRKit（贴纸编辑器的手势）

CJGRKit 是一个 SwiftUI 视图手势编辑组件，当前核心模块为 `CJViewGR-Swift`。它可以把任意 SwiftUI View 包装成类似贴纸编辑器中的可编辑贴纸，支持拖动、双指缩放、双指旋转、选中态角按钮，以及右下角操作柄拖拽缩放/旋转。

## 功能

- 单指拖动视图。
- 双指捏合缩放，并限制最小/最大缩放范围。
- 双指旋转，处理最小缩放附近的旋转抖动。
- 支持外部选中态控制，只有选中的视图显示边框和角按钮。
- 左上角删除按钮、右上角更新按钮。
- 右下角为贴纸编辑器操作柄，拖动时同时缩放和旋转。
- 角按钮视觉尺寸和命中区域会抵消贴纸缩放，缩小后仍然容易按住。
- 右下角按钮完整区域都在可命中范围内，不需要往按钮内侧点。

## 快速使用

基础手势能力：

```swift
MyStickerView()
    .frame(width: 240, height: 180)
    .addGR(minScale: 0.4, maxScale: 4.0)
```

带选中态和角按钮的贴纸编辑能力：

```swift
@State private var selectedID: Int?

MyStickerView()
    .frame(width: 240, height: 180)
    .addGR(
        showCornerButton: selectedID == 1,
        onDelete: {
            // 删除当前贴纸
        },
        onUpdate: {
            // 替换或更新当前贴纸
        },
        onMinimize: nil,
        onSelect: {
            selectedID = 1
        },
        minScale: 0.4,
        maxScale: 4.0
    )
```

外层空白区域可以清空选中态：

```swift
ZStack {
    Color(.systemGroupedBackground)
        .ignoresSafeArea()
        .contentShape(Rectangle())
        .onTapGesture {
            selectedID = nil
        }

    // sticker views...
}
```

## 关键行为说明

`showCornerButton` 建议由业务层的选中态控制。点击、拖动、缩放、旋转或拖右下角操作柄时，组件会触发 `onSelect`，业务层据此切换当前选中的贴纸。

右下角按钮在完整贴纸模式下不是普通点击按钮，而是缩放/旋转操作柄。拖动它时，组件会以贴纸中心为基准，根据“中心到右下角”的向量长度变化计算缩放，根据向量角度变化计算旋转。

角按钮的最小命中区域为 44pt。组件会根据当前缩放值做反向补偿，并在贴纸内容外预留半个命中区域，保证贴纸缩小后按钮仍然好按，且按钮外侧也可以稳定响应。

`onMinimize` 是早期接口遗留命名。当前推荐的贴纸模式中右下角已作为缩放/旋转操作柄使用，因此示例中传 `nil`。旧的 `addGRButtons` 纯按钮叠加接口仍保留右下角点击回调，以兼容已有调用。

## Demo

Demo 工程位于 `CJViewGRDemo`。其中：

- `Basic Gesture Demo` 展示基础拖动、缩放、旋转。
- `Sticker Editor Demo` 展示两个贴纸视图的选中态切换、角按钮显示隐藏，以及右下角缩放/旋转操作柄。

## 当前可优化点

- 将 `onMinimize` 重命名为更贴近语义的 `onResizeHandleTap` 或移除完整贴纸模式下的该参数。目前为了兼容旧接口暂时保留。
- 提供可配置的角按钮资源、边框颜色、线宽和最小命中尺寸。
- 抽出可外部持有的贴纸状态模型，便于保存和恢复贴纸的 `scale`、`rotation`、`position`。
- 为选中态和右下角操作柄增加单元测试或 UI 测试，覆盖多个贴纸切换、缩小后拖拽、旋转后继续缩放等场景。
