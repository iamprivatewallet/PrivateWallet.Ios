//
//  MOSWalletContractTool.swift
//  MOS_Client_IOS
//
//  Created by mnz on 2020/12/3.
//  Copyright © 2020 WangQJ. All rights reserved.
//

import UIKit
import web3swift
import BigInt

class MOSWalletContractTool: NSObject {
    //转账
    @objc
    class func transfer(toAddress: String, amount: String, password: String, completionBlock: @escaping ((_ hash: String?, _ errorDesc: String?)->())) {
        guard let walletAddress = EthereumAddress(MOSWalletTool.getCurrentAddress()), let sendToAddress = EthereumAddress(toAddress) else {
            completionBlock(nil, "必要信息丢失")
            return
        }
        var transactionOptions = TransactionOptions.defaultOptions
        transactionOptions.from = walletAddress
        transactionOptions.to = sendToAddress
        transactionOptions.value = Web3.Utils.parseToBigUInt(amount, units: .eth)
        transactionOptions.gasLimit = .automatic
        transactionOptions.gasPrice = .automatic
        DispatchQueue.global(qos: .background).async {
            do {
                let contract = MOSWalletTool.shared().web3.contract(Web3.Utils.coldWalletABI, at: sendToAddress)
                let intermediate = contract?.method("fallback", transactionOptions: transactionOptions)
                let result = try intermediate?.send(password: password)
                DispatchQueue.main.async {
                    completionBlock(result?.hash, nil)
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
    //在ERC20上转账代币
    @objc
    public class func sendERC20(contractAddress: String, toAddress: String, amount: String, password: String, completionBlock: @escaping ((_ hash: String?, _ errorDesc: String?)->())) {
        guard let walletAddress = EthereumAddress(MOSWalletTool.getCurrentAddress()), let sendToAddress = EthereumAddress(toAddress), let ethContractAddress = EthereumAddress(contractAddress) else {
            completionBlock(nil, "必要信息丢失")
            return
        }
        self.readERC20ContractMethod(contractAddress: contractAddress, method: "decimals", extraData: nil) { (result, errorDesc) in
            if(errorDesc != nil){
                completionBlock(nil, errorDesc)
            }else{
                let decimals = Int("\(result?["0"] ?? "0")") ?? 0
                let amount = Web3.Utils.parseToBigUInt(amount, decimals: decimals) ?? BigUInt(0)
                var options = TransactionOptions.defaultOptions
                options.value = amount
                options.from = walletAddress
                options.gasPrice = .automatic
                options.gasLimit = .automatic
                let method = "transfer"
                DispatchQueue.global(qos: .background).async {
                    do {
                        let contract = MOSWalletTool.shared().web3.contract(Web3.Utils.erc20ABI, at: ethContractAddress)
                        let tx = contract?.write(
                            method,
                            parameters: [sendToAddress, amount] as [AnyObject],
                            extraData: Data(),
                            transactionOptions: options)
                        let result = try tx?.send(password: password)
                        DispatchQueue.main.async {
                            completionBlock(result?.hash, nil)
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
    }
    @objc
    public class func estimateGas(toAddress: String?, value: String?, completionBlock: @escaping ((_ gasPrice: String?, _ gas: String?, _ errorDesc: String?)->())) {
        let address = MOSWalletTool.getCurrentAddress()
        estimateGas(toAddress: toAddress ?? address, value: value, extraData: nil, completionBlock: completionBlock)
    }
    @objc
    public class func estimateGas(toAddress: String, value: String?, extraData: Data?, completionBlock: @escaping ((_ gasPrice: String?, _ gas: String?, _ errorDesc: String?)->())) {
        let to = EthereumAddress(toAddress) ?? EthereumAddress.contractDeploymentAddress()
        let newExtraData = extraData ?? Data()
        var options = TransactionOptions.defaultOptions
        if let valueStr = value {
            let valueBiguint = BigUInt(valueStr.stripHexPrefix().lowercased(), radix: 16)
            options.value = valueBiguint
        }
//        options.from = EthereumAddress(fromAddress ?? "")
        options.to = EthereumAddress(toAddress)
        DispatchQueue.global(qos: .background).async {
            do {
                let gasPrice = try MOSWalletTool.shared().web3.eth.getGasPrice()
                options.gasPrice = TransactionOptions.GasPricePolicy.manual(gasPrice)
                let ethTransaction = EthereumTransaction(to: to, data: newExtraData)
                let gas = try MOSWalletTool.shared().web3.eth.estimateGas(ethTransaction, transactionOptions: options)
                DispatchQueue.main.async {
                    completionBlock("\(gasPrice)","\(gas)", nil)
                }
            } catch let error {
                if let web3Error = error as? Web3Error {
                    WQJLog("====="+web3Error.errorDescription)
                    DispatchQueue.main.async {
                        completionBlock(nil, nil, web3Error.errorDescription)
                    }
                }else{
                    WQJLog("====="+error.localizedDescription)
                    DispatchQueue.main.async {
                        completionBlock(nil, nil, error.localizedDescription)
                    }
                }
            }
        }
    }
    /// 获取主链币余额
    /// - Parameter completionBlock: 回调
    @objc
    public class func getBalance(completionBlock: @escaping ((_ balance: String?)->())) {
        let address = MOSWalletTool.getCurrentAddress()
        if let ethAddress = EthereumAddress(address), let balanceResult = try? MOSWalletTool.shared().web3.eth.getBalance(address: ethAddress) {
            let result = Web3.Utils.formatToEthereumUnits(balanceResult, toUnits: .eth, decimals: 8) ?? ""
            DispatchQueue.main.async {
                completionBlock(result)
            }
        }else{
            completionBlock(nil)
        }
    }
    /// 获取ERC20合约地址代币余额
    /// - Parameters:
    ///   - contractAddressString: contractAddressString
    ///   - extraData: extraData
    ///   - completionBlock: completionBlock
    @objc
    public class func getBalanceERC20(contractAddress: String, completionBlock: @escaping ((_ balance: String?, _ errorDesc: String?)->())) {
        let address = MOSWalletTool.getCurrentAddress()
        if contractAddress.count == 0 || address == "" {
            completionBlock(nil, "必要信息丢失")
            return
        }
        self.readERC20ContractMethod(contractAddress: contractAddress, method: "balanceOf", params: [address], extraData: nil) { (result, errorDesc) in
            completionBlock("\(result?["0"] ?? "0")", errorDesc)
        }
    }
    // 获得代币名称
    @objc
    public class func getNameERC20(contractAddress: String, completionBlock: @escaping ((_ value: String?, _ errorDesc: String?)->())) {
        self.readERC20ContractMethod(contractAddress: contractAddress, method: "name", extraData: nil) { (result, errorDesc) in
            completionBlock("\(result?["0"] ?? "")", errorDesc)
        }
    }
    // 获取代币符号
    @objc
    public class func getSymbolERC20(contractAddress: String, completionBlock: @escaping ((_ value: String?, _ errorDesc: String?)->())) {
        self.readERC20ContractMethod(contractAddress: contractAddress, method: "symbol", extraData: nil) { (result, errorDesc) in
            completionBlock("\(result?["0"] ?? "")", errorDesc)
        }
    }
    // 获取代币小数位
    @objc
    public class func getDecimalsERC20(contractAddress: String, completionBlock: @escaping ((_ decimals: Int, _ errorDesc: String?)->())) {
        self.readERC20ContractMethod(contractAddress: contractAddress, method: "decimals", extraData: nil) { (result, errorDesc) in
            completionBlock(Int("\(result?["0"] ?? "0")") ?? 0, errorDesc)
        }
    }
    // 获取代币总量
    @objc
    public class func getTotalSupplyERC20(contractAddress: String, completionBlock: @escaping ((_ value: String?, _ errorDesc: String?)->())) {
        self.readERC20ContractMethod(contractAddress: contractAddress, method: "totalSupply", extraData: nil) { (result, errorDesc) in
            completionBlock("\(result?["0"] ?? "")", errorDesc)
        }
    }
    @objc
    public class func readERC20ContractMethod(contractAddress: String, method: String, params: [Any] = [], extraData: Data?, completionBlock: @escaping ((_ result: [String: Any]?, _ errorDesc: String?)->())) {
        guard let ethContractAddress = EthereumAddress(contractAddress) else {
            completionBlock(nil, "必要信息丢失")
            return
        }
        let newExtraData = extraData ?? Data()
        var transactionOptions = TransactionOptions.defaultOptions
        transactionOptions.callOnBlock = .latest
        DispatchQueue.global(qos: .background).async {
            do {
                if(MOSWalletTool.shared().web3.provider.network != nil&&(MOSWalletTool.shared().web3.provider.network?.chainID ?? 0) != SettingManager.sharedInstance().getNodeChainId()){
                    DispatchQueue.main.async {
                        completionBlock(nil, "chainId error")
                    }
                    return
                }
                let contract = MOSWalletTool.shared().web3.contract(Web3.Utils.erc20ABI, at: ethContractAddress)
//                let result = try contract?.read(contractMethod, parameters: [], extraData: extraData, transactionOptions: transactionOptions)?.call(transactionOptions: transactionOptions)
                let result = try contract?.method(method, parameters: params as [AnyObject], extraData: newExtraData, transactionOptions: transactionOptions)?.call(transactionOptions: transactionOptions)
                DispatchQueue.main.async {
                    completionBlock(result, nil)
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
    /// 编写交易并调用智能合约方法
    /// - Parameters:
    ///   - contractABI: contractABI
    ///   - abiVersion: abiVersion
    ///   - contractAddress: contractAddressString
    ///   - method: method
    ///   - parameters: parameters
    ///   - extraData: 合约方法的额外数据
    ///   - amount: 金额
    ///   - password: 钱包密码
    ///   - completionBlock: 完成block
    @objc
    public class func callContractMethod(contractABI: String, contractAddress: String, method: String, parameters: [AnyObject] = [], extraData: Data?, amount: String?, password: String, completionBlock: @escaping ((_ hash: String?, _ errorDesc: String?)->())) {
        guard let walletAddress = EthereumAddress(MOSWalletTool.getCurrentAddress()), let ethContractAddress = EthereumAddress(contractAddress) else {
            completionBlock(nil, "必要信息丢失")
            return
        }
        let newExtraData = extraData ?? Data()
        self.readERC20ContractMethod(contractAddress: contractAddress, method: "decimals", extraData: nil) { (result, errorDesc) in
            if(errorDesc != nil){
                completionBlock(nil, errorDesc)
            }else{
                let decimals = Int("\(result?["0"] ?? "0")") ?? 0
                var options = TransactionOptions.defaultOptions
                if let amountStr = amount {
                    let amount = Web3.Utils.parseToBigUInt(amountStr, decimals: decimals)
                    options.value = amount
                }
                options.from = walletAddress
                DispatchQueue.global(qos: .background).async {
                    do {
                        let contract = MOSWalletTool.shared().web3.contract(contractABI, at: ethContractAddress)
                        let tx = contract?.write(
                            method,
                            parameters: parameters,
                            extraData: newExtraData,
                            transactionOptions: options)
                        let result = try tx?.send(password: password)
                        DispatchQueue.main.async {
                            completionBlock(result?.hash, nil)
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
    }
}
