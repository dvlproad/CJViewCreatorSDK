//
//  CJGRCornerView.swift
//  CJViewGRDemo
//
//  Created by qian on 2024/11/28.
//

import SwiftUI

public struct CJGRTransformResult {
    public let translation: CGSize
    public let scale: CGFloat
    public let rotation: Angle

    public init(translation: CGSize = .zero,
                scale: CGFloat = 1,
                rotation: Angle = .zero) {
        self.translation = translation
        self.scale = scale
        self.rotation = rotation
    }
}

// 为任意 SwiftUI 视图添加贴纸编辑器常见的拖动、捏合缩放、旋转和角按钮能力。
public struct CJGRViewModifier: ViewModifier {
//    @ObservedObject public var imageModel: GRImageModel
    public let enableGR: Bool
    public let showCornerButton: Bool
    public let onDelete: (() -> Void)?
    public let onUpdate: (() -> Void)?
    public let onMinimize: (() -> Void)?
    public let onSelect: (() -> Void)?
    public let onTransformEnded: ((CJGRTransformResult) -> Void)?
    public let baseRotation: Angle
    public let minScale: CGFloat
    public let maxScale: CGFloat

    @State private var scale: CGFloat = 1
    @State private var rotation: Angle = .zero
    @State private var position: CGSize = .zero
    @State private var isTransforming: Bool = false
    @State private var isPinchingBelowMinScale: Bool = false
    @State private var isResizingFromCorner: Bool = false
    @State private var resizeStartScale: CGFloat = 1
    @State private var resizeStartRotation: Angle = .zero
    @GestureState private var gestureScale: CGFloat = 1
    @GestureState private var gestureRotation: Angle = .zero
    @GestureState private var gestureOffset: CGSize = .zero
    private let minimumCornerHitLength: CGFloat = 44
    private let minScaleDeadZone: CGFloat = 0.02

    public init(enableGR: Bool = true,
                showCornerButton: Bool = false,
                onDelete: (() -> Void)? = nil,
                onUpdate: (() -> Void)? = nil,
                onMinimize: (() -> Void)? = nil,
                onSelect: (() -> Void)? = nil,
                onTransformEnded: ((CJGRTransformResult) -> Void)? = nil,
                baseRotation: Angle = .zero,
                minScale: CGFloat = 0.3,
                maxScale: CGFloat = 6.0) {
        self.enableGR = enableGR
        self.showCornerButton = showCornerButton
        self.onDelete = onDelete
        self.onUpdate = onUpdate
        self.onMinimize = onMinimize
        self.onSelect = onSelect
        self.onTransformEnded = onTransformEnded
        self.baseRotation = baseRotation
        self.minScale = minScale
        self.maxScale = maxScale
    }

    @ViewBuilder
    public func body(content: Content) -> some View {
        // 模拟器或真实设备上，双指距离非常小时 MagnificationGesture 可能给出接近 0 的值。
        // 这里先限制手势临时缩放值，避免 scaleEffect 收到非法或过小值导致视图不可见。
        let magnificationGesture = MagnificationGesture()
            .updating($gestureScale) { value, state, _ in
                state = limitedGestureScale(value)
            }
            .onChanged { value in
                onSelect?()
                isTransforming = true
                isPinchingBelowMinScale = isAtOrBelowMinScale(scale * safeScaleValue(value))
            }
            .onEnded { value in
                let oldScale = scale
                let newScale = limitedScale(scale * safeScaleValue(value))
                if onTransformEnded != nil {
                    let deltaScale = oldScale > 0 ? newScale / oldScale : newScale
                    notifyTransformEnded(scale: deltaScale)
                    scale = oldScale
                } else {
                    scale = newScale
                }
                isPinchingBelowMinScale = false
                isTransforming = false
            }

        // 双指距离过小时旋转角度容易抖动；接近最小缩放时先冻结本次旋转增量，
        // 结束时再用安全值累计，避免贴纸在临界点突然跳转。
        let rotationGesture = RotationGesture()
            .updating($gestureRotation) { value, state, _ in
                state = safeRotationValue(value, allowsRotationAtMinScale: false)
            }
            .onChanged { _ in
                onSelect?()
                isTransforming = true
            }
            .onEnded { value in
                let deltaRotation = safeRotationValue(value, allowsRotationAtMinScale: true)
                if onTransformEnded != nil {
                    notifyTransformEnded(rotation: deltaRotation)
                } else {
                    rotation += deltaRotation
                }
                isTransforming = false
            }

        // 双指缩放/旋转期间暂停单指拖动。否则 SwiftUI 可能把双指中心点变化也识别为拖动，
        // 导致贴纸在缩放或旋转时被意外平移。
        let dragGesture = DragGesture()
            .updating($gestureOffset) { value, state, _ in
                guard isTransforming == false else { return }
                state = value.translation
            }
            .onChanged { _ in
                guard isTransforming == false else { return }
                onSelect?()
            }
            .onEnded { value in
                guard isTransforming == false else { return }
                onSelect?()
                if onTransformEnded != nil {
                    notifyTransformEnded(translation: value.translation)
                    position = .zero
                } else {
                    position.width += value.translation.width
                    position.height += value.translation.height
                }
            }

        let transformGesture = dragGesture
            .simultaneously(with: magnificationGesture)
            .simultaneously(with: rotationGesture)

        let cornerOutset = showCornerButton ? cornerHitOutset : 0

        let transformedContent = content
//            .scaleEffect(imageModel.scale)
//            .rotationEffect(.degrees(imageModel.currentRotationDegrees))
//            .offset(x: imageModel.position.width + imageModel.dragOffset.width,
//                    y: imageModel.position.height + imageModel.dragOffset.height)
            .overlay {
                if showCornerButton {
                    // 角按钮有一半在贴纸边界外。用负 padding 扩展 overlay 的绘制和命中区域，
                    // 避免 padding 参与内容布局，导致选中时原始视图位置发生变化。
                    CJGRCornerView(zoom: 0.50,
                                   contentInset: cornerOutset,
                                   displayScale: currentScale,
                                   onDelete: onDelete,
                                   onUpdate: onUpdate,
                                   onMinimize: onMinimize,
                                   onMinimizeDragChanged: resizeFromCorner,
                                   onMinimizeDragEnded: finishCornerResize)
                    .padding(-cornerOutset)
                }
            }
            .contentShape(Rectangle())
            .scaleEffect(currentScale)
            .rotationEffect(baseRotation + rotation + gestureRotation)
            .offset(x: position.width + gestureOffset.width,
                    y: position.height + gestureOffset.height)
            .onTapGesture {
                onSelect?()
            }

        if enableGR {
            transformedContent
                .gesture(transformGesture)
        } else {
            transformedContent
        }
    }

    private func limitedScale(_ value: CGFloat) -> CGFloat {
        guard isFiniteScaleValue(value) else { return scale }
        if isAtOrBelowMinScale(value) {
            return minScale
        }
        return min(max(value, minScale), maxScale)
    }

    // 非法、无穷大或小于等于 0 的缩放值都按“没有缩放变化”处理，保护 scaleEffect。
    private func safeScaleValue(_ value: CGFloat) -> CGFloat {
        guard isFiniteScaleValue(value), value > 0 else { return 1 }
        return value
    }

    // 返回本次手势应该作用到 scaleEffect 的局部倍率。这样缩放过程中也会被限制在 min/max 内，
    // 而不是等手势结束后才回弹。
    private func limitedGestureScale(_ value: CGFloat) -> CGFloat {
        let safeValue = safeScaleValue(value)
        let targetScale = limitedScale(scale * safeValue)
        guard scale > 0, isFiniteScaleValue(scale) else { return 1 }
        return targetScale / scale
    }

    private func safeRotationValue(_ value: Angle, allowsRotationAtMinScale: Bool) -> Angle {
        guard Double(value.radians).isFinite else { return .zero }
        guard allowsRotationAtMinScale || isPinchingBelowMinScale == false else { return .zero }
        return value
    }

    private func isFiniteScaleValue(_ value: CGFloat) -> Bool {
        Double(value).isFinite
    }

    private var currentScale: CGFloat {
        limitedScale(scale * gestureScale)
    }

    private var cornerHitOutset: CGFloat {
        guard currentScale > 0 else { return 0 }
        // 角按钮最小命中区域为 44pt，按钮中心放在贴纸角上，因此四周需要预留半径 22pt。
        // 这里除以当前缩放，是为了抵消外层 scaleEffect，让屏幕上的命中区域保持稳定大小。
        return minimumCornerHitLength / 2 / currentScale
    }

    // 拖动右下角操作柄时，把该角点看作绕贴纸中心运动的点。
    // 根据“中心 -> 右下角”的向量长度变化计算缩放，根据向量角度变化计算旋转。
    private func resizeFromCorner(_ translation: CGSize, contentSize: CGSize) {
        onSelect?()
        if isResizingFromCorner == false {
            resizeStartScale = scale
            resizeStartRotation = rotation
            isResizingFromCorner = true
        }
        isTransforming = true

        let startVector = CGSize(width: contentSize.width / 2,
                                 height: contentSize.height / 2)
        let startLength = vectorLength(startVector)
        guard startLength > 0 else { return }

        let startVectorInScreen = rotated(startVector, by: resizeStartRotation) * resizeStartScale
        let movedVectorInScreen = CGSize(width: startVectorInScreen.width + translation.width,
                                         height: startVectorInScreen.height + translation.height)
        let movedLength = vectorLength(movedVectorInScreen)
        guard movedLength > 0 else { return }

        scale = limitedScale(movedLength / startLength)
        rotation = angle(of: movedVectorInScreen) - angle(of: startVector)
    }

    private func finishCornerResize() {
        let endedScale = scale
        let deltaScale = resizeStartScale > 0 ? endedScale / resizeStartScale : endedScale
        let deltaRotation = Angle.radians(rotation.radians - resizeStartRotation.radians)
        if onTransformEnded != nil {
            notifyTransformEnded(scale: deltaScale, rotation: deltaRotation)
            scale = resizeStartScale
            rotation = resizeStartRotation
        }
        resizeStartScale = scale
        resizeStartRotation = rotation
        isResizingFromCorner = false
        isTransforming = false
    }

    private func notifyTransformEnded(translation: CGSize = .zero,
                                      scale: CGFloat = 1,
                                      rotation: Angle = .zero) {
        guard hasVisibleTransformChange(translation: translation, scale: scale, rotation: rotation) else {
            return
        }
        onTransformEnded?(
            CJGRTransformResult(translation: translation,
                                scale: scale,
                                rotation: rotation)
        )
    }

    private func hasVisibleTransformChange(translation: CGSize,
                                           scale: CGFloat,
                                           rotation: Angle) -> Bool {
        abs(translation.width) > 0.01 ||
        abs(translation.height) > 0.01 ||
        abs(scale - 1) > 0.001 ||
        abs(rotation.degrees) > 0.01
    }

    // 最小缩放附近加一个很小的吸附区，减少手势噪声导致的边界抖动。
    private func isAtOrBelowMinScale(_ value: CGFloat) -> Bool {
        value <= minScale + minScaleDeadZone
    }

    private func vectorLength(_ vector: CGSize) -> CGFloat {
        sqrt(vector.width * vector.width + vector.height * vector.height)
    }

    private func angle(of vector: CGSize) -> Angle {
        .radians(atan2(vector.height, vector.width))
    }

    private func rotated(_ vector: CGSize, by angle: Angle) -> CGSize {
        let radians = angle.radians
        let cosValue = CGFloat(cos(radians))
        let sinValue = CGFloat(sin(radians))
        return CGSize(width: vector.width * cosValue - vector.height * sinValue,
                      height: vector.width * sinValue + vector.height * cosValue)
    }
}

private func * (lhs: CGSize, rhs: CGFloat) -> CGSize {
    CGSize(width: lhs.width * rhs, height: lhs.height * rhs)
}


/*
public class GRImageModel: ObservableObject, Identifiable {
    public let id: UUID = UUID()
    public init() {
        
    }
    
    /// 是否可以替换图片
    var isReplaceable: Bool = true
    /// 是否是可拖拽的
    var isDraggable: Bool = true
    /// 图片默认显示大小
    var imageSize: CGSize = .zero
    /// 图片实际显示大小
    var size: CGSize {
        CGSize(width: imageSize.width * scale, height: imageSize.height * scale)
    }
    var lastSize: CGSize {
        CGSize(width: imageSize.width * lastScale, height: imageSize.height * lastScale)
    }
    // 当前缩放比例
    var scale: CGFloat = 1 {
        didSet {
            objectWillChange.send()
        }
    }
    // 起始拖动位置
    var dragOffset: CGSize = .zero {
        didSet {
            objectWillChange.send()
        }
    }
    
    var position: CGSize = .zero {
        didSet {
            objectWillChange.send()
        }
    }
    
    var currentRotationDegrees: Double = 0 {
        didSet {
            objectWillChange.send()
        }
    }
    
    var lastScale: CGFloat = 1 {
        didSet {
            objectWillChange.send()
        }
    }
    
    var lastRotationDegrees: Double = 0
    {
        didSet {
            objectWillChange.send()
        }
    }
    
    ///
    var origin: CGPoint?
    
    var rotation: Angle {
        Angle(degrees: currentRotationDegrees)
    }
    var offset: CGSize {
        CGSize(width: dragOffset.width + position.width, height: dragOffset.height + position.height)
    }
}
*/
