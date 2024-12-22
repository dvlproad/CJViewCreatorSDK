//
//  LunarDatePickerSheet.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/9/23.
//

import SwiftUI
import CQDemoKit

struct LunarDatePickerSheet: View {
    
    var originalDate: Date = Date()
    
    @State var isLunarDate: Bool = false
    
    /// 是否显示农历日期选择
    var isShowLunarDate: Bool = true
    var completion: ((_ date: Date) -> Void)?
    var isLunarChanged: ((_ isLunar: Bool) -> Void)?
    var isValidateHandler: ((Date) -> (Bool, String))?
    
    @Binding var isPresented: Bool
    @State private var showPanels: Bool = false
    @State private var backgroundOpacity: Double = 0
    @State private var selectedDate: Date = Date()
    
    var dismissHandler: (() -> Void)?
    
    var body: some View {
        if isPresented {
            ZStack {
                Color.clear.edgesIgnoringSafeArea(.all)
                Color.black
                    .opacity(backgroundOpacity)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        dismiss()
                    }
                    .onAppear {
                        withAnimation {
                            backgroundOpacity = 0.4
                            showPanels = true
                        }
                    }
                VStack {
                    Spacer()
                    if showPanels {
                        ZStack {
                            CCDatePickerSwiftUIView(selectedDate: $selectedDate,
                                                isLunarDate: $isLunarDate, cancelClourse: {
                                dismiss()
                            }, onValueChangeOfDate: { date in
                                selectedDate = date
                            }, doneClourse: { selectedDate in
                                if let isValidateHandler = isValidateHandler {
                                    let result = isValidateHandler(selectedDate)
                                    if result.0 {
                                        completion?(selectedDate)
                                        dismiss()
                                    } else {
                                        CJUIKitToastUtil.showMessage(result.1)
                                        dismiss()
                                    }
                                } else {
                                    completion?(selectedDate)
                                    dismiss()
                                }
                            })
                            .frame(width: UIScreen.main.bounds.width, height: 311)
                            .background(Color.white)
//                            .cornerRadius(14, corners: [.topLeft, .topRight])
                            .onChange(of: isLunarDate) { isLunar in
                                isLunarChanged?(isLunar)
                            }
                            
                            if isShowLunarDate {
                                VStack {
                                    Spacer()
                                    
                                    HStack(spacing: 3) {
                                        Spacer().frame(width: 0.05)
                                        let options: [String] = ["公历", "农历"]
                                        ForEach(0..<options.count, id: \.self) { index in
                                            let selected = ((isLunarDate && 1 == index) || (!isLunarDate && 0 == index))
                                            Text(options[index])
                                                .font(.system(size: 13, weight: .medium))
                                                .foregroundColor(Color(hex: selected ? "#333333" : "#666666"))
                                                .frame(width: 58, height: 26, alignment: .center)
                                                .background(selected ? Color.white : Color.clear)
                                                .cornerRadius(14)
                                                .onTapGesture {
                                                    isLunarDate = index == 1
                                                }
                                        }
                                        Spacer().frame(width: 0.05)
                                    }
                                    .frame(height: 32)
                                    .background(Color(hex: "#F5F5F5"))
                                    .cornerRadius(16)
                                    
                                    Spacer().frame(height: 259)
                                }.frame(height: 311)
                            }
                        }
                        .transition(.move(edge: .bottom))
                        .animation(.easeInOut, value: showPanels)
                    }
                }.edgesIgnoringSafeArea(.all)
            }
            .onAppear {
                selectedDate = originalDate
            }
        }
        
    }
    
    func dismiss() {
        withAnimation {
            showPanels = false
            backgroundOpacity = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            isPresented = false
            dismissHandler?()
        })
    }
}



#Preview {
    @State var isPresented: Bool = true
    return LunarDatePickerSheet(isPresented: $isPresented)
}
