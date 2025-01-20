//
//  CJTextSettingRow.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/12/15.
//

import SwiftUI

public struct CJTextSettingRow: View {
    public var title: String
    public var titleWidth: CGFloat? // 如果非空，则会固定title视图的宽度
    
    @Binding public var text: String
    public var placeHolder: String = "请输入内容"
    let isEditable: Bool
    public var lineLimit: Int = 1
    public var textFieldHeight: CGFloat?
    public var textDidChange: ((String) -> Void)
    
    public init(
        title: String,
        titleWidth: CGFloat? = nil,
        text: Binding<String>,
        placeHolder: String,
        isEditable: Bool = true,
        lineLimit: Int,
        textFieldHeight: CGFloat? = nil,
        textDidChange: @escaping (String) -> Void
    ) {
        self.title = title
        self.titleWidth = titleWidth
        
        self._text = text
        self.placeHolder = placeHolder
        self.isEditable = isEditable
        self.lineLimit = lineLimit
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
                .frame(width: titleWidth, height: 30)
            
            Spacer()
            
            CJTextInputView(
                text: $text,
                placeHolder: placeHolder,
                isEditable: isEditable,
                lineLimit: lineLimit,
//                textFieldHeight: textFieldHeight,
                textDidChange: textDidChange
            )
        }
    }
}

public struct CJTextInputView: View {
    @Binding public var text: String
    public var placeHolder: String = "请输入内容"
    let isEditable: Bool                // 控制是否可以编辑
    public var lineLimit: Int = 1
//    public var textFieldHeight: CGFloat?
    public var textDidChange: ((String) -> Void)
    
    public init(
        text: Binding<String>,
        placeHolder: String,
        isEditable: Bool = true,
        lineLimit: Int,
        textDidChange: @escaping (String) -> Void
    ) {
        self._text = text
        self.placeHolder = placeHolder
        self.isEditable = isEditable
        self.lineLimit = lineLimit
//        self.textFieldHeight = textFieldHeight
        self.textDidChange = textDidChange
    }
    
    public var body: some View {
        if lineLimit == 1 {
            textField()
        } else {
            textEditor()
        }
    }
    
    func textField() -> some View {
        HStack(spacing: 0, content: {
            ZStack {
                TextField(placeHolder, text: $text, onEditingChanged: { isEditing in
                    debugPrint("isEditing: \(isEditing)")
                }, onCommit: {
                    debugPrint("onCommit")
                })
                .font(.system(size: 13.5, weight: .regular))
                .foregroundColor(isEditable ? Color.red : Color(hex: "#EEEEEE"))
                .multilineTextAlignment(.leading)
                .padding(.leading, 10)
                .onChange(of: text, { oldValue, newValue in
                    debugPrint("onChange: \(oldValue) -> \(newValue)")
                    textDidChange(text)
                })
                .disabled(!isEditable)
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
            .opacity(isEditable ? (text.count > 0 ? 1 : 0) : 0)
        })
//        .frame(height: textFieldHeight ?? 30)
        .overlay(
            RoundedRectangle(cornerRadius: 5, style: .continuous)
                .stroke(Color(hex: "#EEEEEE").opacity(1), lineWidth: 1)
        )
    }
    
    func textEditor() -> some View {
        TextEditor(text: $text)
            .font(.system(size: 13.5, weight: .regular))
            .multilineTextAlignment(.leading)
            .lineLimit(lineLimit)
            .padding(.leading, 8)
//            .frame(height: textFieldHeight ?? 100)
            .overlay(
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .stroke(Color(hex: "#EEEEEE").opacity(1), lineWidth: 1)
            )
            .onChange(of: text, { oldValue, newValue in
                textDidChange(text)
            })
            .disabled(!isEditable)
    }
}
