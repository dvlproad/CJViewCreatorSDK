//
//  DatePickerUtil.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/12/16.
//

import SwiftUI

struct DatePickerUtil {
    static func showDatePicker(
        title: String = "选择日期",
        initialDate: Date = Date(),
        onDateSelected: @escaping (Date) -> Void
    ) {
        DatePickerManager.shared.present(
            title: title,
            initialDate: initialDate,
            onDateSelected: onDateSelected
        )
    }
}

// 管理全局的日期选择器显示
class DatePickerManager: ObservableObject {
    static let shared = DatePickerManager()
    
    @Published var isPresented = false
    @Published var title: String = ""
    @Published var initialDate: Date = Date()
    @Published var onDateSelected: (Date) -> Void = { _ in }
    
    func present(
        title: String,
        initialDate: Date,
        onDateSelected: @escaping (Date) -> Void
    ) {
        self.title = title
        self.initialDate = initialDate
        self.onDateSelected = onDateSelected
        withAnimation {
            isPresented = true
        }
    }
    
    func dismiss() {
        withAnimation {
            isPresented = false
        }
    }
}

private struct DatePickerOverlay: View {
    @ObservedObject var manager = DatePickerManager.shared
    @State private var selectedDate: Date
    
    init() {
        _selectedDate = State(initialValue: DatePickerManager.shared.initialDate)
    }
    
    var body: some View {
        if manager.isPresented {
            ZStack {
                // 半透明背景
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        manager.dismiss()
                    }
                
                // 日期选择器内容
                VStack(spacing: 0) {
                    HStack {
                        Button("取消") {
                            manager.dismiss()
                        }
                        Spacer()
                        Text(manager.title)
                            .font(.headline)
                        Spacer()
                        Button("确定") {
                            manager.onDateSelected(selectedDate)
                            manager.dismiss()
                        }
                    }
                    .padding()
                    .background(Color.white)
                    
                    Divider()
                    
                    DatePicker(
                        "",
                        selection: $selectedDate,
                        displayedComponents: [.date]
                    )
                    .datePickerStyle(WheelDatePickerStyle())
                    .labelsHidden()
                    .frame(height: 216)
                    .background(Color.white)
                    .cornerRadius(16)
                }
                .padding()
            }
            .transition(.move(edge: .bottom)) // 从底部弹出
        }
    }
}


struct GlobalOverlayModifier: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            content
            DatePickerOverlay()
        }
    }
}

extension View {
    func withGlobalOverlay() -> some View {
        self.modifier(GlobalOverlayModifier())
    }
}
