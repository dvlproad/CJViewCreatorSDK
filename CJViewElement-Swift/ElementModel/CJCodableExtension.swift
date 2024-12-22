//
//  CJCodableExtension.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/12/15.
//

import Foundation

extension KeyedDecodingContainer {
//    // 只有json中一定有该值，且该值解析失败才能抛出失败
//    func decodeCGFloat(forKey key: KeyedDecodingContainer<Key>.Key) throws -> CGFloat {
////        do {
////            let value = try decodeCGFloatIfPresent(forKey: key)
////            if value == nil {
////                
////                //debugPrint("Error: No value associated with key  \(key).")
////                throw DecodingError.keyNotFound(key, DecodingError.Context(codingPath: self.codingPath, debugDescription: "No value associated with key  $key)."))
////            }
////        } catch {
////            debugPrint("❌Error:\(key)对应的数字转化失败\(error)")
////            throw DecodingError.keyNotFound(key, DecodingError.Context(codingPath: self.codingPath, debugDescription: "No value associated with key  $key)."))
////        }
//        // 直接调用 decodeCGFloatIfPresent(forKey:) 并处理返回的可选值
//            let value = try decodeCGFloatIfPresent(forKey: key) ?? {
//                // 如果返回 nil，则抛出 keyNotFound 错误
//                throw DecodingError.keyNotFound(key, DecodingError.Context(codingPath: self.codingPath, debugDescription: "No value associated with key  $key)."))
//            }()
//            return value
//    }
//    
//    func decodeCGFloatIfPresent(forKey key: KeyedDecodingContainer<Key>.Key) throws -> CGFloat? {
//        if let cgFloat = try? self.decode(CGFloat.self, forKey: key) {
//            return cgFloat
//        } else if let float = try? self.decode(Float.self, forKey: key) {
//            return CGFloat(float)
//        } else if let double = try? self.decode(Double.self, forKey: key) {
//            return CGFloat(double)
//        } else if let int = try? self.decode(Int.self, forKey: key) {
//            return CGFloat(int)
//        } else {
//            return nil
//        }
//    }
    
    func decodeCGFloatIfPresent(forKey key: KeyedDecodingContainer<Key>.Key) throws -> CGFloat? {
        if let cgFloat = try? self.decodeIfPresent(CGFloat.self, forKey: key) {
            return cgFloat
        } else if let float = try? self.decodeIfPresent(Float.self, forKey: key) {
            return CGFloat(float)
        } else if let double = try? self.decodeIfPresent(Double.self, forKey: key) {
            return CGFloat(double)
        } else if let int = try? self.decodeIfPresent(Int.self, forKey: key) {
            return CGFloat(int)
        } else {
            return nil
        }
    }
    
    func decodeCGFloat(forKey key: KeyedDecodingContainer<Key>.Key) throws -> CGFloat {
        if let cgFloat = try? self.decode(CGFloat.self, forKey: key) {
            return cgFloat
        } else if let float = try? self.decode(Float.self, forKey: key) {
            return CGFloat(float)
        } else if let double = try? self.decode(Double.self, forKey: key) {
            return CGFloat(double)
        } else if let int = try? self.decode(Int.self, forKey: key) {
            return CGFloat(int)
        } else {
            throw DecodingError.keyNotFound(key, DecodingError.Context(codingPath: self.codingPath, debugDescription: "Key '\(key.stringValue)' not found or cannot be converted to CGFloat"))
        }
    }
}
