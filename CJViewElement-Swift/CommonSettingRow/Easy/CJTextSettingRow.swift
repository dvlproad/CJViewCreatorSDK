//
//  CJTextSettingRow.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/12/15.
//

import SwiftUI

public struct CJTextSettingRow: View {
    public var title: String
    @Binding public var text: String
    public var placeHolder: String = "请输入内容"
    public var lineLimit: Int = 1
    public var textFieldWidth: CGFloat?
    public var textFieldHeight: CGFloat?
    public var textDidChange: ((String) -> Void)
    
    public init(title: String, text: Binding<String>, placeHolder: String, lineLimit: Int, textFieldWidth: CGFloat? = nil, textFieldHeight: CGFloat? = nil, textDidChange: @escaping (String) -> Void) {
        self.title = title
        self._text = text
        self.placeHolder = placeHolder
        self.lineLimit = lineLimit
        self.textFieldWidth = textFieldWidth
        self.textFieldHeight = textFieldHeight
        self.textDidChange = textDidChange
    }
    
    public var body: some View {
        contentView()
    }
    
    @ViewBuilder
    func contentView() -> some View {
        HStack(alignment: .center, spacing: 10) {
            Text(title)
                .foregroundColor(Color(hex: "#333333"))
                .font(.system(size: 15.5, weight: .medium))
                .frame(height: 30)
            
            Spacer()
            
            if lineLimit == 1 {
                textField()
                    .frame(width: textFieldWidth)
            } else {
                textEditor()
            }
        }
    }
    
    func textEditor() -> some View {
        TextEditor(text: $text)
            .font(.system(size: 13.5, weight: .regular))
            .multilineTextAlignment(.leading)
            .lineLimit(lineLimit)
            .padding(.leading, 8)
            .frame(height: textFieldHeight ?? 100)
            .overlay(
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .stroke(Color(hex: "#EEEEEE").opacity(1), lineWidth: 1)
            )
            .onChange(of: text, { oldValue, newValue in
                textDidChange(text)
            })
    }
    
    
    func textField() -> some View {
        HStack(spacing: 0, content: {
            ZStack {
                TextField(placeHolder, text: $text, onEditingChanged: { isEditing in
                    
                })
                .font(.system(size: 13.5, weight: .regular))
                .foregroundColor(Color.red)
                .multilineTextAlignment(.leading)
                .padding(.leading, 10)
                .onChange(of: text, { oldValue, newValue in
                    textDidChange(text)
                })
            }
            
            Button(action: {
                /// 清空文本
                text = ""
            }, label: {
                Image("field_close_gray")
                    .resizable()
                    .frame(width: 15, height: 15)
                
            })
            .frame(width: 30, height: 30)
            .background(.clear)
            .cornerRadius(0)
            .opacity(text.count > 0 ? 1 : 0)
        })
        .frame(height: textFieldHeight ?? 30)
        .overlay(
            RoundedRectangle(cornerRadius: 5, style: .continuous)
                .stroke(Color(hex: "#EEEEEE").opacity(1), lineWidth: 1)
        )
    }
}
