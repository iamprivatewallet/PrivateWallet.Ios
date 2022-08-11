//
//  PWWalletERC721ContractTool.swift
//  TokenWalletProject
//
//  Created by mnz on 2022/8/11.
//  Copyright © 2022 . All rights reserved.
//

import Foundation
import BigInt
import Web3

class PWWalletERC721ContractTool: NSObject {
    static var sharedObj = PWWalletERC721ContractTool()
    private var web3: Web3
    @objc public class func shared() -> PWWalletERC721ContractTool {
        let defaultUrlStr = kETHRPCUrl;
        let urlStr = SettingManager.sharedInstance().getCurrentNode().first as? String ?? defaultUrlStr
        let provider = sharedObj.web3.provider as? Web3HttpProvider
        if(provider?.rpcURL != urlStr){
            sharedObj = PWWalletERC721ContractTool()
        }
        return sharedObj
    }
    override init() {
        let defaultUrlStr = kETHRPCUrl;
        let urlStr = SettingManager.sharedInstance().getCurrentNode().first as? String ?? defaultUrlStr
        web3 = Web3(rpcURL: urlStr)
    }
    @objc
    public func balanceOf(contract: String?, address: String?, completionHandler: ((_ result: String?, _ errorDesc: String?)->())?) {
        guard let contract = contract, let address = address else { completionHandler?(nil,"error"); return }
        if contract == "" || address == "" { completionHandler?(nil,"error"); return }
        guard let ethAddress = EthereumAddress(hexString: address) else { completionHandler?(nil,"error"); return }
        let erc721 = GenericERC721Contract(address: EthereumAddress(hexString: contract), eth: web3.eth)
        erc721.balanceOf(address: ethAddress).call { result, error in
            debugPrint("\(result)===\(error?.localizedDescription)")
            completionHandler?("\(result?["_balance"] ?? 0)",error?.localizedDescription)
        }
    }
    @objc
    public func approve(privateKey: String?, contract: String?, to: String?, tokenId: String?, gas: String?, gasPrice: String?, completionHandler: ((_ result: String?, _ errorDesc: String?)->())?) {
        guard let contract = contract, let privateKey = privateKey, let to = to, let tokenId = tokenId, let gas = gas, let gasPrice = gasPrice else { completionHandler?(nil,"error"); return }
        if contract == "" || privateKey == "" || to == "" { completionHandler?(nil,"error"); return }
        guard let fromPrivateKey = try? EthereumPrivateKey(hexPrivateKey: privateKey), let ethToAddress = EthereumAddress(hexString: to) else { completionHandler?(nil,"error"); return }
        let erc721 = GenericERC721Contract(address: EthereumAddress(hexString: contract), eth: web3.eth)
        firstly {
            web3.eth.getTransactionCount(address: fromPrivateKey.address, block: .latest)
        }.then { nonce in
            try erc721.approve(to: ethToAddress, tokenId: BigUInt(stringLiteral: tokenId)).createTransaction(
                nonce: nonce,
                from: fromPrivateKey.address,
                value: 0,
                gas: EthereumQuantity(quantity: BigUInt(stringLiteral: gas)),
                gasPrice: EthereumQuantity(quantity: BigUInt(stringLiteral: gasPrice).gwei)
            )!.sign(with: fromPrivateKey).promise
        }.then { [self] tx in
            web3.eth.sendRawTransaction(transaction: tx)
        }.done { txHash in
            debugPrint(txHash.hex())
            completionHandler?(txHash.hex(), nil)
        }.catch { error in
            debugPrint(error)
            completionHandler?(nil, error.localizedDescription)
        }
    }
    @objc
    public func getApproved(contract: String?, tokenId: String?, completionHandler: ((_ result: String?, _ errorDesc: String?)->())?) {
        guard let contract = contract, let tokenId = tokenId else { completionHandler?(nil,"error"); return }
        if contract == "" { completionHandler?(nil,"error"); return }
        let erc721 = GenericERC721Contract(address: EthereumAddress(hexString: contract), eth: web3.eth)
        erc721.getApproved(tokenId: BigUInt(stringLiteral: tokenId)).call { result, error in
            let approved = (result?["_approved"] as? EthereumAddress)?.hex(eip55: false) ?? ""
            debugPrint("\(approved)===\(error?.localizedDescription)")
            completionHandler?(approved,error?.localizedDescription)
        }
    }
    @objc
    public func transfer(privateKey: String?, contract: String?, to: String?, tokenId: String?, gas: String?, gasPrice: String?, completionHandler: ((_ result: String?, _ errorDesc: String?)->())?) {
        guard let contract = contract, let privateKey = privateKey, let to = to, let tokenId = tokenId, let gas = gas, let gasPrice = gasPrice else { completionHandler?(nil,"error"); return }
        if contract == "" || privateKey == "" || to == "" { completionHandler?(nil,"error"); return }
        guard let fromPrivateKey = try? EthereumPrivateKey(hexPrivateKey: privateKey), let ethToAddress = EthereumAddress(hexString: to) else { completionHandler?(nil,"error"); return }
        let erc721 = GenericERC721Contract(address: EthereumAddress(hexString: contract), eth: web3.eth)
        firstly {
            web3.eth.getTransactionCount(address: fromPrivateKey.address, block: .latest)
        }.then { nonce in
            try erc721.transfer(to: ethToAddress, tokenId: BigUInt(stringLiteral: tokenId)).createTransaction(
                nonce: nonce,
                from: fromPrivateKey.address,
                value: 0,
                gas: EthereumQuantity(quantity: BigUInt(stringLiteral: gas)),
                gasPrice: EthereumQuantity(quantity: BigUInt(stringLiteral: gasPrice).gwei)
            )!.sign(with: fromPrivateKey).promise
        }.then { [self] tx in
            web3.eth.sendRawTransaction(transaction: tx)
        }.done { txHash in
            debugPrint(txHash.hex())
            completionHandler?(txHash.hex(), nil)
        }.catch { error in
            debugPrint(error)
            completionHandler?(nil, error.localizedDescription)
        }
    }
}
