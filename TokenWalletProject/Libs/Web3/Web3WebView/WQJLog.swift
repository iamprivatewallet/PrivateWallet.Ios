//
//  WQJLog.swift
//  MOS_Client_IOS
//
//  Created by mnz on 2020/8/28.
//  Copyright © 2020 WangQJ. All rights reserved.
//

import Foundation

public func WQJLog(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
    items.forEach {
        Swift.print($0, separator: separator, terminator: terminator)
    }
    #endif
}
