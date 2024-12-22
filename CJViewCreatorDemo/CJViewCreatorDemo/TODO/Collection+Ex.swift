//
//  Collection+Ex.swift
//  WidgetIsland
//
//  Created by One on 2024/8/19.
//

import Foundation

extension Collection {

    /// A Boolean value indicating whether the range contains no elements.
    ///
    /// Because a closed range cannot represent an empty range, this property is
    /// always `false`.
    @inlinable public var isNotEmpty: Bool { !isEmpty }
}
