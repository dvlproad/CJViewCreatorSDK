//
//  CJStringExtension.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/12/15.
//

import Foundation

public extension String {
    /// 截取规定下标之后的字符串
    func subStringFrom(index: Int) -> String {
        let temporaryString: String = self
        let temporaryIndex = temporaryString.index(temporaryString.startIndex, offsetBy: index)
        return String(temporaryString[temporaryIndex...])
    }
    
    /// 截取规定下标之前的字符串
    func subStringTo(index: Int) -> String {
        let temporaryString = self
        let temporaryIndex = temporaryString.index(temporaryString.startIndex, offsetBy: index)
        return String(temporaryString[...temporaryIndex])
        
    }
}
