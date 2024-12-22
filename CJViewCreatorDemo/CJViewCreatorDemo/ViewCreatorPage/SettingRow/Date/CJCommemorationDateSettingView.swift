//
//  CJCommemorationDateSettingView.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/12/23.
//

import Foundation
import SwiftUI
import CJViewElement_Swift


struct CJCommemorationDateSettingView: View {
    @Binding var commemorationDateModel: CJCommemorationDataModel
    var onChangeOfDateChooseModel: ((_ newCommemorationDateModel: CJCommemorationDataModel ) -> Void)
    var actionClosure: ((CJSheetActionType) -> Void)
    
    //@Binding var shouldUpdateDateSettingView: Bool
    @EnvironmentObject var dateSettingViewUpdateObserver: UIUpdateModel
    
    // MARK: - Update
    //@State var shouldUpdateUI = false
    @StateObject var uiUpdateObserver = UIUpdateModel()
    func updateUI() {
        ///shouldUpdateUI.toggle()
        uiUpdateObserver.updateListeners()
        
        self.onChangeOfDateChooseModel(commemorationDateModel)
    }
    
    var body: some View {
        VStack {
            let date: Binding<Date> = Binding(get: { commemorationDateModel.date }, set: { commemorationDateModel.date = $0 })
            let dateStringIsLunarType: Binding<Bool> = Binding(get: { commemorationDateModel.dateStringIsLunarType }, set: { commemorationDateModel.dateStringIsLunarType = $0 })
            CJDateChooseRow(title: "目标日", date: date, dateStringIsLunarType:dateStringIsLunarType, dateFormaterHandle: { date in
                //return CCBaseDateUtil.getYYMMDDDateString(date: date)
                return commemorationDateModel.stringForDateChooseRow()
            }, isPickerSupportLunar: true, onChangeOfDate: { date in
//                commemorationDateModel.date = date
                self.updateUI()
            }, onChangeOfDateStringIsLunarType: { isLunar in
//                commemorationDateModel.dateStringIsLunarType = isLunar
                self.updateUI()
            }, isValidateHandler: { date in
                return (true, "")
            }, actionClosure: { actionType in
                self.actionClosure(actionType)
            }).onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            .environmentObject(uiUpdateObserver)
            

            CJDateRepateRow(cycleType: commemorationDateModel.cycleType, onChangeOfCycleType: { newCycleType in
                commemorationDateModel.cycleType = newCycleType
                self.updateUI()
            })
            
            if commemorationDateModel.date < Date() {
                let toggleModel: CJSwitchSettingModel = CJSwitchSettingModel(isOn: commemorationDateModel.includeTodayIsOn, isHidden: commemorationDateModel.includeTodayChangeEnable)
                CJSwitchSettingRow(title: "是否包含当天", toggleModel: toggleModel, onChangeOfValue: { value in
                    commemorationDateModel.includeTodayIsOn = value
                    self.updateUI()
                })
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            }
        }
    }
}

