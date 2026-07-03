//
//  CJDefaultDatePickerSheet.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2026/5/8.
//

import SwiftUI

struct CJDefaultDatePickerSheet: View {
    let request: CJDatePickerRequest
    let onDismiss: () -> Void

    @State private var selectedDate: Date
    @State private var dateStringIsLunarType: Bool
    @State private var validateMessage: String?

    init(request: CJDatePickerRequest, onDismiss: @escaping () -> Void) {
        self.request = request
        self.onDismiss = onDismiss
        _selectedDate = State(initialValue: request.date)
        _dateStringIsLunarType = State(initialValue: request.dateStringIsLunarType)
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button("取消") {
                    onDismiss()
                }

                Spacer()

                Text(request.title)
                    .font(.headline)
                    .foregroundColor(.primary)

                Spacer()

                Button("确定") {
                    commit()
                }
            }
            .padding(.horizontal, 20)
            .frame(height: 52)

            Divider()

            if request.isPickerSupportLunar {
                Toggle("农历展示", isOn: $dateStringIsLunarType)
                    .padding(.horizontal, 20)
                    .frame(height: 48)
            }

            DatePicker(
                "",
                selection: $selectedDate,
                displayedComponents: [.date]
            )
            .datePickerStyle(WheelDatePickerStyle())
            .labelsHidden()
            .frame(maxWidth: .infinity)
            .frame(height: 216)

            if let validateMessage, !validateMessage.isEmpty {
                Text(validateMessage)
                    .font(.system(size: 13))
                    .foregroundColor(.red)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 12)
            }
        }
    }

    private func commit() {
        if let isValidateHandler = request.isValidateHandler {
            let result = isValidateHandler(selectedDate)
            guard result.0 else {
                validateMessage = result.1
                return
            }
        }

        request.onChangeOfDate(selectedDate)
        request.onChangeOfDateStringIsLunarType(dateStringIsLunarType)
        onDismiss()
    }
}
