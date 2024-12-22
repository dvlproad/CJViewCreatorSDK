//
//  CJSegmentedView.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/12/22.
//

import Foundation
import SwiftUI

public enum CJSegmentedStyle {
    case capsule    // 胶囊样式
}

public struct CJSegmentedView: View {
    @State var segments: [String] = ["First", "Second", "Third", "Fourth"]
    @Binding var selectedIndex: Int
    var padding: CGFloat = 1
    var fixSize: Bool = true
    var fontSize: CGFloat = 11
    var didSelectItem: ((_ oldValue: Int, _ newValue: Int) -> Void)
    
    @State private var scrollViewContentSize: CGSize = .zero
    @State var interSpacing: CGFloat = 0
    @State var horizontalPadding: CGFloat = 0
    @State var itemHorizontalPadding: CGFloat = 11
    let itemHeight: CGFloat? = nil
    let style: CJSegmentedStyle = .capsule
    var selectedItemStyle: ((Text) -> Text)?
    var normalItemStyle: ((Text) -> Text)?
    
    public init(segments: [String], selectedIndex: Binding<Int>, padding: CGFloat, fixSize: Bool, fontSize: CGFloat, didSelectItem: @escaping (_: Int, _: Int) -> Void) {
        self.segments = segments
        self._selectedIndex = selectedIndex
        self.padding = padding
        self.fixSize = fixSize
        self.fontSize = fontSize
        self.didSelectItem = didSelectItem
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                ZStack(alignment: .leading) {
                    // 背景视图
                    if style == .capsule {
                        Capsule()
                            .fill(Color.white)
                            .cornerRadius(3.0)
                            .frame(width: itemWidth(for: segments[selectedIndex], geo: geometry), height: itemHeight)
                            .offset(x: backgroundOffset(geo: geometry), y: 0)
                            .animation(.easeInOut(duration: 0.3), value: selectedIndex)
                    }
                    
                    HStack(spacing: interSpacing) {
                        ForEach(0..<segments.count, id: \.self) { index in
                            textItem(text: segments[index], isSelected: selectedIndex == index).frame(width: itemWidth(for: segments[index], geo: geometry), height: itemHeight).contentShape(Rectangle())
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        let oldValue = selectedIndex
                                        selectedIndex = index
                                        didSelectItem(oldValue, index)
                                    }
                                }
                        }
                    }
                    .background(
                        Group {
                            if fixSize {
                                GeometryReader { geo -> Color in
                                    DispatchQueue.main.async {
                                        scrollViewContentSize = geo.size
                                    }
                                    return Color.clear
                                }
                            } else {
                                EmptyView()
                            }
                        }
                    )
                }
                .padding(padding)
                .background(Color(hex: "#F5F5F5"))
                .cornerRadius(geometry.size.height * 0.5)
            }
        }
        .frame(width: fixSize ? scrollViewContentSize.width + padding * 2 : nil)
    }
    
    func textItem(text: String, isSelected: Bool = false) -> Text {
        if let style = (isSelected ? selectedItemStyle : normalItemStyle) {
            style(Text(text))
        } else {
            Text(text)
                .foregroundColor(isSelected ? Color(hex: "#333333") : Color(hex: "#666666"))
                .font(.system(size: fontSize, weight: .regular))
        }
    }
    
    // 计算选项的宽度
    private func itemWidth(for text: String, geo: GeometryProxy) -> CGFloat {
        guard fixSize else {
            return (geo.size.width - padding * 2) / CGFloat(segments.count)
        }
        let font = UIFont.systemFont(ofSize: fontSize, weight: .regular)
        let textWidth = textWidth(text, font: font)
        return textWidth + itemHorizontalPadding * 2 // 增加一些padding
    }
    
    // 计算背景的偏移量
    private func backgroundOffset(geo: GeometryProxy) -> CGFloat {
        var offset: CGFloat = 0 // 初始padding
        for index in 0..<selectedIndex {
            offset += itemWidth(for: segments[index], geo: geo) + interSpacing
        }
        return offset
    }
    
    func textWidth(_ text: String, font: UIFont) -> CGFloat {
        let attributes = [NSAttributedString.Key.font: font]
        let size = text.size(withAttributes: attributes)
        return size.width
    }
}

