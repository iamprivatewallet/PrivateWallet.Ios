//
//  PWWalletTool.swift
//  TokenWalletProject
//
//  Created by mnz on 2023/2/28.
//  Copyright © 2023 . All rights reserved.
//

import Foundation
import web3
import BigInt

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
    @objc class func getGasPrice(rpcUrl: String?) async -> String? {
        guard let rpcUrl = rpcUrl, let clientUrl = URL(string: rpcUrl) else { return nil }
        let client = EthereumHttpClient(url: clientUrl)
        let gasPrice = try? await client.eth_gasPrice()
        return "\(gasPrice ?? 0)"
    }
    @objc class func sendRawTransaction(rpcUrl: String?, privateKey: String, to: String, value: String?, dataStr: String?, gasPrice: String, gasLimit: String, completionHandler: ((_ hash: String?, _ errStr: String?) -> ())?) {
        guard var dataStr = dataStr else {
            completionHandler?(nil,"error")
            return;
        }
        if(dataStr.hasPrefix("0x")){
            dataStr = String(dataStr[dataStr.index(dataStr.startIndex, offsetBy: 2)...])
        }
        let account = try? EthereumAccount(keyStorage: TestEthereumKeyStorage(privateKey: privateKey))
        guard let rpcUrl = rpcUrl, let account = account, let clientUrl = URL(string: rpcUrl), let value = BigUInt(value ?? "0"), let data = dataStr.hexadecimal(), let gasPrice = BigUInt(gasPrice), let gasLimit = BigUInt(gasLimit) else {
            completionHandler?(nil,"error")
            return;
        }
        let client = EthereumHttpClient(url: clientUrl)
        let transaction = EthereumTransaction(from: account.address, to: EthereumAddress(to), value:value, data: data, gasPrice: gasPrice, gasLimit: gasLimit)
        client.eth_sendRawTransaction(transaction, withAccount: account, completionHandler: { result in
            do {
                let hash = try result.get()
                completionHandler?(hash,nil)
            } catch let err {
                completionHandler?(nil,err.localizedDescription)
            }
        })
//        return try? await client.eth_sendRawTransaction(transaction, withAccount: account)
    }
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
