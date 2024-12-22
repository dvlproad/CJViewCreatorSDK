//
//  UILabel+Ex.swift
//  VVLife
//
//  Created by julian on 2020/3/30.
//  Copyright © 2020 vv. All rights reserved.
//

import Foundation

public extension UILabel {
    // 初始化
    /// 文字内容等创建
    /// - Parameters:
    ///   - text: 文本内容
    ///   - font: 字体
    ///   - style: UIFont.TextStyle，设置了style后font失效
    ///   - textColor: 字体颜色
    ///   - alignment: 对齐方式
    ///   - numberOfLines: 行数
    convenience init(text: String? = nil, font: UIFont? = UIFont.systemFont(ofSize: 14), style: UIFont.TextStyle? = nil, textColor: UIColor? = .black, alignment: NSTextAlignment? = .center, numberOfLines: Int? = 1) {
        self.init()
        self.text = text
        if let style = style {
            self.font = UIFont.preferredFont(forTextStyle: style)
        } else
        if let font = font {
            self.font = font
        }
        self.textColor = textColor
        self.textAlignment = alignment ?? .center
        self.numberOfLines = numberOfLines ?? 1
    }
}

public extension UILabel {
    func setText(_ text: String?, lineSpacing: CGFloat) {
        guard let text = text else { return }
        guard lineSpacing >= 0.01 else {
            self.text = text
            return
        }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing;  //设置行间距
        paragraphStyle.lineBreakMode = self.lineBreakMode
        paragraphStyle.alignment = self.textAlignment
        
        let attributedString = NSMutableAttributedString.init(string: text)
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: text.utf16.count))
        self.attributedText = attributedString
    }
    
    /// 添加中横线
    func addStrikeThrough() {
        guard let text = self.text, text.count > 0  else {
            return
        }
        let attributeStr = NSMutableAttributedString(string: text)
        attributeStr.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSNumber.init(value: 1), range: NSRange(location: 0, length: text.count))
        self.attributedText = attributeStr
    }
    
    /// 设置标签列表，不超过一行宽度，超过限定宽度的标签不显示，不出现...
    /// - Parameters:
    ///   - tagList: 标签列表
    ///   - joinString: 间隔的字符串
    func setTagListText(_ tagList: [String]?, joinString: String) {
        guard let list = tagList, list.count > 0 else {
            self.text = ""
            return
        }
        
        // 第一个标签超出一行也不显示，如果要显示的需要把第一个标签放出来判断
//        var textString = list.first ?? ""
//        var lastString = String.init(textString)
//        self.text = textString
//        self.setNeedsLayout()
//        self.layoutIfNeeded()
//        if self.intrinsicContentSize.width > self.width { return }

        var textString = ""
        var lastString = ""
        
        for (index, string) in list.enumerated() {
            if index == 0 {
                textString.append(string)
            } else {
                textString.append(joinString)
                textString.append(string)
            }
            
            self.text = textString
            self.setNeedsLayout()
            self.layoutIfNeeded()
            if self.intrinsicContentSize.width > self.width {
                self.text = lastString
                return
            }
            if index == 0 {
                lastString.append(string)
            } else {
                lastString.append(joinString)
                lastString.append(string)
            }
        }
        self.text = textString
    }
}
