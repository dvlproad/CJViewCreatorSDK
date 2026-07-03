//
//  CJImageExtension.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/12/15.
//

import Foundation

extension Bundle {
    public static var cjViewElement: Bundle {
        let bundleName = "CJViewElement-Swift"
        if let bundleURL = Bundle(for: CJViewElement_BundleToken.self).url(forResource: bundleName, withExtension: "bundle") {
            return Bundle(url: bundleURL) ?? .main
        }
        return .main
    }
}

private class CJViewElement_BundleToken {}

