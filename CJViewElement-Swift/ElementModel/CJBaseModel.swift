//
//  CJBaseModel.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/12/15.
//

import Foundation

// 定义协议，用于多态解码
//public protocol CJBaseModel: Codable {
//    init()
//}

public protocol CJBaseModel: Codable, Equatable {
    init()
}


// 定义协议和默认实现
protocol DefaultInitializable {
    init()
}
