//
//  CJTextSettingRow.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/12/15.
//

import SwiftUI

public struct CJTextInputView: View {
    @Binding public var text: String
    public var placeHolder: String = "请输入内容"
    public var multilineTextAlignment: TextAlignment
    let isEditable: Bool                // 是否可以编辑
    public var lineLimit: Int = 1
    public var textDidChange: ((String) -> Void)
    
    public init(
        text: Binding<String>,
        placeHolder: String,
        multilineTextAlignment: TextAlignment = .leading,
        isEditable: Bool = true,
        lineLimit: Int,
        textDidChange: @escaping (String) -> Void
    ) {
        self._text = text
        self.placeHolder = placeHolder
        self.multilineTextAlignment = multilineTextAlignment
        self.isEditable = isEditable
        self.lineLimit = lineLimit
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
        GeometryReader { geometry in
            HStack(spacing: 0, content: {
                ZStack {
                    TextField(placeHolder, text: $text, onEditingChanged: { isEditing in
                        //debugPrint("isEditing: \(isEditing)")
                    }, onCommit: {
                        //debugPrint("onCommit")
                    })
                    .frame(height: geometry.size.height)
                    .font(.system(size: 13.5, weight: .regular))
                    .foregroundColor(isEditable ? Color(hex: "#333333") : Color(hex: "#EEEEEE"))
                    .multilineTextAlignment(multilineTextAlignment)
                    .onChange(of: text, perform: { newValue in
                        textDidChange(text)
                    })
                    .disabled(!isEditable)
                }
                
                if isEditable, text.count > 0 {
                    Button(action: {
                        text = ""   // 清空文本
                    }, label: {
                        Image("field_close_gray")
                            .resizable()
                            .frame(width: 15, height: 15)
                    })
                    .frame(width: 30, height: 30)
                }
            })
        }
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
