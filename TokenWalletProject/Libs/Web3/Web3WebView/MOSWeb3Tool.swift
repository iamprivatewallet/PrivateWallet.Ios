//
//  MOSWeb3Tool.swift
//  MOS_Client_IOS
//
//  Created by mnz on 2020/11/30.
//  Copyright © 2020 WangQJ. All rights reserved.
//

import UIKit
import web3swift
import BigInt

extension String {
    func stripHexPrefix() -> String {
        if self.hasPrefix("0x") {
            let indexStart = self.index(self.startIndex, offsetBy: 2)
            return String(self[indexStart...])
        }
        return self
    }
}
class MOSWeb3Tool: NSObject {
    @objc
    public class func toChecksum(address: String) -> String? {
        return EthereumAddress.toChecksumAddress(address)
    }
    @objc
    public class func checkImportWallet() {
        SettingManager.sharedInstance().checkImportWallet();
    }
    @objc
    public class func changeOrImportWallet(address: String, mnemonics: String, privateKey: String, password: String) {
        if(!MOSWalletTool.hasWallet() || MOSWalletTool.getCurrentAddress() != address) {
            MOSWalletTool.logoutWallet();
            var address: String? = "";
            if(mnemonics == nil||mnemonics.count==0) {
                address = MOSWalletTool.importWallet(privateKey, password: password)
            }else{
                address = MOSWalletTool.createOrImportWallet(mnemonics, password: password)
            }
            WQJLog(address)
        }
    }
    @objc
    public class func sendTransaction(_ transactionJSON: [String: Any], password: String, completionBlock: @escaping ((_ hash: String?, _ errorDesc: String?)->())) {
        guard var transaction = EthereumTransaction.fromJSON(transactionJSON), let options = TransactionOptions.fromJSON(transactionJSON) else {
            completionBlock(nil, "必要信息丢失")
            return
        }
        transaction.value = transaction.value != nil ? transaction.value! : BigUInt(0)
        if let gas = transactionJSON["gas"] as? String, let gasBiguint = BigUInt(gas.stripHexPrefix().lowercased(), radix: 16) {
            transaction.gasLimit = gasBiguint
        } else if let gasLimit = transactionJSON["gasLimit"] as? String, let gasgasLimitBiguint = BigUInt(gasLimit.stripHexPrefix().lowercased(), radix: 16) {
            transaction.gasLimit = gasgasLimitBiguint
        } else {
            //以太坊转账gaslimit基本只要21000左右，ERC20代币4-50000左右。
            transaction.gasLimit = BigUInt(21000)
        }
        if let gasPrice = transactionJSON["gasPrice"] as? String, let gasPriceBiguint = BigUInt(gasPrice.stripHexPrefix().lowercased(), radix: 16) {
            transaction.gasPrice = gasPriceBiguint
        } else {
            transaction.gasPrice = BigUInt(20000000000)
        }
        var transactionOptions = TransactionOptions.defaultOptions
        transactionOptions.from = options.from
        transactionOptions.to = transaction.to
        transactionOptions.value = transaction.value
        transactionOptions.gasLimit = TransactionOptions.GasLimitPolicy.manual(transaction.gasLimit)
        transactionOptions.gasPrice = TransactionOptions.GasPricePolicy.manual(transaction.gasPrice)
        transactionOptions.nonce = options.nonce
        self.checkImportWallet();
        DispatchQueue.global(qos: .background).async {
            do {
                let result = try MOSWalletTool.shared().web3.eth.sendTransaction(transaction, transactionOptions: transactionOptions, password: password)
                DispatchQueue.main.async {
                    completionBlock(result.hash, nil)
                }
            } catch let error {
                if let web3Error = error as? Web3Error {
                    WQJLog("====="+web3Error.errorDescription)
                    DispatchQueue.main.async {
                        completionBlock(nil, web3Error.errorDescription)
                    }
                }else{
                    WQJLog("====="+error.localizedDescription)
                    DispatchQueue.main.async {
                        completionBlock(nil, error.localizedDescription)
                    }
                }
            }
        }
    }
    @objc
    public class func signPersonalMessage(message: String, address: String, password: String, completionBlock: @escaping ((_ hash: String?, _ errorDesc: String?)->())) {
        guard let data = message.data(using: .utf8), let from = EthereumAddress(address) else {
            completionBlock(nil, "必要信息丢失")
            return
        }
        self.checkImportWallet()
        DispatchQueue.global(qos: .background).async {
            do {
                let result = try MOSWalletTool.shared().web3.personal.signPersonalMessage(message: data, from: from, password: password)
                DispatchQueue.main.async {
                    completionBlock(result.toHexString(), nil)
                }
            } catch let error {
                if let web3Error = error as? Web3Error {
                    WQJLog("====="+web3Error.errorDescription)
                    DispatchQueue.main.async {
                        completionBlock(nil, web3Error.errorDescription)
                    }
                }else{
                    WQJLog("====="+error.localizedDescription)
                    DispatchQueue.main.async {
                        completionBlock(nil, error.localizedDescription)
                    }
                }
            }
        }
    }
    @objc
    public class func signPersonalMessage(dict: [String: Any], address: String, password: String, completionBlock: @escaping ((_ hash: String?, _ errorDesc: String?)->())) {
        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted), let from = EthereumAddress(address) else {
            completionBlock(nil, "必要信息丢失")
            return
        }
        self.checkImportWallet();
        DispatchQueue.global(qos: .background).async {
            do {
                let result = try MOSWalletTool.shared().web3.personal.signPersonalMessage(message: data, from: from, password: password)
                DispatchQueue.main.async {
                    completionBlock(result.toHexString(), nil)
                }
            } catch let error {
                if let web3Error = error as? Web3Error {
                    WQJLog("====="+web3Error.errorDescription)
                    DispatchQueue.main.async {
                        completionBlock(nil, web3Error.errorDescription)
                    }
                }else{
                    WQJLog("====="+error.localizedDescription)
                    DispatchQueue.main.async {
                        completionBlock(nil, error.localizedDescription)
                    }
                }
            }
        }
    }
}

