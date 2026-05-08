//
//  CJGRCornerView.swift
//  CJViewGRDemo
//
//  Created by qian on 2024/11/28.
//

import SwiftUI

// MARK: - 使用ViewModifier为View实现一个扩展，将其添加到一个视图中，该视图中有添加进来的view，view的边缘有边框以及有三个位于该view左上的删除、右上的更新、右下的缩小按钮。
public struct CJGRCornerViewModifier: ViewModifier {
    let onDelete: (() -> Void)
    let onUpdate: (() -> Void)
    let onMinimize: (() -> Void)

    public func body(content: Content) -> some View {
//        GeometryReader { geometry in
//            ZStack {
                content
                    .overlay(content: {
                        CJGRCornerView(zoom: 0.50, onDelete: onDelete, onUpdate: onUpdate, onMinimize: onMinimize)
                    })
//                    .frame(width: geometry.size.width, height: geometry.size.height)
//
//
//            }
//            .frame(width: geometry.size.width, height: geometry.size.height) // 限制 ZStack 的大小
//        }
    }
}

public struct CJGRCornerView: View {
    public var zoom: CGFloat
    public var contentInset: CGFloat
    public var displayScale: CGFloat
    public var onDelete: (() -> Void)?
    public var onUpdate: (() -> Void)?
    public var onMinimize: (() -> Void)?
    public var onMinimizeDragChanged: ((CGSize, CGSize) -> Void)?
    public var onMinimizeDragEnded: (() -> Void)?
    
    public init(zoom: CGFloat,
                contentInset: CGFloat = 0,
                displayScale: CGFloat = 1,
                onDelete: ( () -> Void)? = nil,
                onUpdate: ( () -> Void)? = nil,
                onMinimize: ( () -> Void)? = nil,
                onMinimizeDragChanged: ((CGSize, CGSize) -> Void)? = nil,
                onMinimizeDragEnded: (() -> Void)? = nil) {
        self.zoom = zoom
        self.contentInset = contentInset
        self.displayScale = displayScale
        self.onDelete = onDelete
        self.onUpdate = onUpdate
        self.onMinimize = onMinimize
        self.onMinimizeDragChanged = onMinimizeDragChanged
        self.onMinimizeDragEnded = onMinimizeDragEnded
    }
    
    public var body: some View {
        GeometryReader { geometry in
            let buttonScaleCompensation = scaleCompensation
            let baseIconLength = max(23, 23 * zoom)
            let iconLength = baseIconLength * buttonScaleCompensation
            let hitLength = max(44, baseIconLength) * buttonScaleCompensation
            let borderLineWidth = zoom * 2 * buttonScaleCompensation
            // 外层为了让角按钮完整可点，会给真实内容加一圈 padding。
            // contentInset 用来从扩大后的布局区域中反算出真实贴纸边界。
            let contentSize = CGSize(width: max(0, geometry.size.width - contentInset * 2),
                                     height: max(0, geometry.size.height - contentInset * 2))
            let minX = contentInset
            let minY = contentInset
            let maxX = contentInset + contentSize.width
            let maxY = contentInset + contentSize.height
            let supportsCornerResize = onMinimizeDragChanged != nil || onMinimizeDragEnded != nil
            ZStack {
                Rectangle()
                    .stroke(Color.black, lineWidth: borderLineWidth)  // 添加蓝色的边框
                    .padding(-borderLineWidth)
                    .frame(width: contentSize.width, height: contentSize.height)
                    .position(x: minX + contentSize.width / 2,
                              y: minY + contentSize.height / 2)
                
                cornerButton(imageName: "photoEdit_close",
                             iconLength: iconLength,
                             hitLength: hitLength,
                             position: CGPoint(x: minX, y: minY))
                    .onTapGesture {
                        onDelete?()
                    }
                
                if onUpdate != nil {
                    cornerButton(imageName: "photoEdit_replace",
                                 iconLength: iconLength,
                                 hitLength: hitLength,
                                 position: CGPoint(x: maxX, y: minY))
                        .onTapGesture {
                            onUpdate?()
                        }
                }
                
                if supportsCornerResize {
                    cornerButton(imageName: "photoEdit_enlarge",
                                 iconLength: iconLength,
                                 hitLength: hitLength,
                                 position: CGPoint(x: maxX, y: maxY))
                        // 完整贴纸模式下，右下角是缩放/旋转操作柄，不承担点击动作。
                        // 使用高优先级拖拽，避免被外层贴纸拖动手势抢占。
                        .highPriorityGesture(
                            DragGesture(minimumDistance: 0, coordinateSpace: .global)
                                .onChanged { value in
                                    onMinimizeDragChanged?(value.translation, contentSize)
                                }
                                .onEnded { _ in
                                    onMinimizeDragEnded?()
                                }
                        )
                } else {
                    cornerButton(imageName: "photoEdit_enlarge",
                                 iconLength: iconLength,
                                 hitLength: hitLength,
                                 position: CGPoint(x: maxX, y: maxY))
                        .onTapGesture {
                            onMinimize?()
                        }
                }
                
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .contentShape(Rectangle())
        }
    }

    private var scaleCompensation: CGFloat {
        guard Double(displayScale).isFinite, displayScale > 0 else { return 1 }
        // 角按钮跟随贴纸一起 scaleEffect 后会被放大/缩小；这里反向补偿，
        // 让按钮和命中区域在屏幕上的大小尽量稳定。
        return 1 / displayScale
    }

    private func cornerButton(imageName: String,
                              iconLength: CGFloat,
                              hitLength: CGFloat,
                              position: CGPoint) -> some View {
        Image(imageName)
            .resizable()
            .frame(width: iconLength, height: iconLength, alignment: .center)
            .frame(width: hitLength, height: hitLength, alignment: .center)
            .contentShape(Rectangle())
            .position(position)
    }

}



// MARK: 预览 CJGRCornerView
struct CJGRCornerView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Text("Hello, World!")
                .background(Color.red)
        }
        .frame(width: 200, height: 200)
        .background(Color.green)
        .overlay(content: {
            CJGRCornerView(zoom: 1)
        })
    }
}
