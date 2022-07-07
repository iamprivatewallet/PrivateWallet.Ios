//
//  PW_BigIntTool.swift
//  TokenWalletProject
//
//  Created by mnz on 2022/7/7.
//  Copyright © 2022 . All rights reserved.
//

import Foundation
import BigInt

class PW_BigIntTool: NSObject {
    @objc class func to10(hex: String) -> String {
        var str = hex
        if(str.hasPrefix("0x")){
            let index = str.index(str.startIndex, offsetBy: 2)
            str = String(str[index...])
        }
        let value = BigInt(str, radix: 16) ?? 0
        return String(value, radix: 10)
    }
    @objc class func to16(val: String) -> String {
        if(val.hasPrefix("0x")){
            return val
        }
        let value = BigInt(val, radix: 10) ?? 0
        return String(value, radix: 16)
    }
}
