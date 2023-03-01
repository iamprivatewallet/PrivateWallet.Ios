//
//  PWWalletTool.swift
//  TokenWalletProject
//
//  Created by mnz on 2023/2/28.
//  Copyright © 2023 . All rights reserved.
//

import Foundation
import web3

class TestEthereumKeyStorage: EthereumSingleKeyStorageProtocol {
    
    private var privateKey: String

    init(privateKey: String) {
        self.privateKey = privateKey
    }

    func storePrivateKey(key: Data) throws {
    }

    func loadPrivateKey() throws -> Data {
        return privateKey.web3.hexData!
    }
}

class PWWalletTool:NSObject {
    @objc class func signMessage(privateKey: String, msg: String) -> String? {
        let message = self.getMessage(msg: msg)
        guard let message = message else { return nil }
        let account = try? EthereumAccount(keyStorage: TestEthereumKeyStorage(privateKey: privateKey))
        guard let data = message.data(using: .ascii) else { return nil }
        return try? account?.signMessage(message: data)
    }
    @objc class func getMessage(msg: String) -> String? {
        var content = msg
        if(content.hasPrefix("0x")){
            content = String(content[content.index(content.startIndex, offsetBy: 2)...])
        }
        let res = content.hexadecimal()
        guard let res = res else { return nil }
        return String(data: res, encoding: .utf8)
    }
}

extension String {
    func hexadecimal() -> Data? {
        var data = Data(capacity: self.count / 2)

        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: self, range: NSMakeRange(0, utf16.count)) { match, flags, stop in
            let byteString = (self as NSString).substring(with: match!.range)
            var num = UInt8(byteString, radix: 16)!
            data.append(&num, count: 1)
        }

        guard data.count > 0 else { return nil }

        return data
    }

}
