//
//  PW_TronContractTool.swift
//  TronWalletDemo
//
//  Created by mnz on 2022/7/8.
//

import Foundation
import BigInt
import TronWebSwift
import BIP39swift
import BIP32Swift

class PW_TronContractTool: NSObject {
    static private let obj = PW_TronContractTool()
    private let provider = TronWebHttpProvider(URL(string: "https://trx.mytokenpocket.vip")!)!
    private var tronWeb: TronWeb { return TronWeb(provider: provider) }
    private let LackInfoTip = "lack of information";
    @objc class func shared() -> PW_TronContractTool {
        return obj
    }
    @objc public class func generateAccount(completionHandler: ((_ result: [String: String]?, _ errorDesc: String?)->())?) {
        let language: BIP39Language = .english
        let mnemonics = try? BIP39.generateMnemonics(bitsOfEntropy: 128, language: language)
        self.import(mnemonics: mnemonics, language: language, completionHandler: completionHandler)
    }
    @objc public class func `import`(mnemonics: String?, completionHandler: ((_ result: [String: String]?, _ errorDesc: String?)->())?) {
        self.import(mnemonics: mnemonics, language: .english, completionHandler: completionHandler)
    }
    public class func `import`(mnemonics: String?, language: BIP39Language = .english, completionHandler: ((_ result: [String: String]?, _ errorDesc: String?)->())?) {
        DispatchQueue.global().async {
            let path = "m/44'/195'/0'/0/0"
            guard let mnemonics = mnemonics,
                    let seed = BIP39.seedFromMmemonics(mnemonics, language: language),
                    let node = HDNode(seed: seed),
                    let treeNode = node.derive(path: path),
                    let privateKey = treeNode.privateKey,
                    let singner = try? TronSigner(privateKey: privateKey) else {
                DispatchQueue.main.async {
                    completionHandler?(nil,"error")
                }
                return
            }
            let result = [
                "address": singner.address.address,
                "privateKey": singner.privateKey.toHexString(),
                "mnemonics": mnemonics,
            ]
            DispatchQueue.main.async {
                completionHandler?(result,nil)
            }
        }
    }
    @objc public class func `import`(privateKey: String?, completionHandler: ((_ result: [String: String]?, _ errorDesc: String?)->())?) {
        DispatchQueue.global().async {
            guard let privateKey = privateKey,
                    let singner = try? TronSigner(privateKey: Data(hex: privateKey)) else {
                DispatchQueue.main.async {
                    completionHandler?(nil,"error")
                }
                return
            }
            let result = [
                "address": singner.address.address,
                "privateKey": singner.privateKey.toHexString(),
                "mnemonics": "",
            ]
            DispatchQueue.main.async {
                completionHandler?(result,nil)
            }
        }
    }
}

extension PW_TronContractTool {
    @objc public func transfer(privateKey: String?, address: String?, amount: Int64, completionHandler: ((_ result: Bool, _ hash: String?, _ errorDesc: String?)->())?) {
        guard let privateKey = privateKey, let address = address, let signer = try? TronSigner(privateKey: Data(hex: privateKey)), let toAddress = TronAddress(address) else {
            completionHandler?(false,nil,LackInfoTip)
            return
        }
        DispatchQueue.global().async {
            do {
                let contract = Protocol_TransferContract.with {
                    $0.ownerAddress = signer.address.data
                    $0.toAddress = toAddress.data
                    $0.amount = amount
                }
                let tx =  try self.provider.createTransaction(contract).wait()
                let signedTx = try tx.sign(signer)
                let response = try self.provider.broadcastTransaction(signedTx).wait()
                debugPrint(response)
                DispatchQueue.main.async {
                    completionHandler?(response.result,response.txid,nil)
                }
            } catch let error {
                debugPrint(error.localizedDescription)
                DispatchQueue.main.async {
                    completionHandler?(false,nil,error.localizedDescription)
                }
            }
        }
    }
    @objc public func transferTRC20(privateKey: String?, address: String?, contractAddress: String?, amount: Int64, completionHandler: ((_ result: Bool, _ hash: String?, _ errorDesc: String?)->())?) {
        guard let privateKey = privateKey,
                let address = address,
                let contractAddress = contractAddress,
                let signer = try? TronSigner(privateKey: Data(hex: privateKey)),
                let toAddress = TronAddress(address),
                let contract = TronAddress(contractAddress),
                let c = self.tronWeb.contract(TronWeb.Utils.trc20ABI, at: contract)else {
            completionHandler?(false,nil,LackInfoTip)
            return
        }
        DispatchQueue.global().async {
            do {
                var opts = TronTransactionOptions.defaultOptions
                opts.ownerAddress = signer.address
                opts.feeLimit = 15000000
                let parameters = [toAddress, BigUInt(amount)] as [AnyObject]
                let response = try c.write("transfer", parameters: parameters, signer: signer, transactionOptions: opts).wait()
                debugPrint(response)
                DispatchQueue.main.async {
                    completionHandler?(response.result,response.txid,nil)
                }
            } catch let error {
                debugPrint(error.localizedDescription)
                DispatchQueue.main.async {
                    completionHandler?(false,nil,error.localizedDescription)
                }
            }
        }
    }
}

extension PW_TronContractTool {
    @objc public func getAccount(address: String?, completionHandler: ((_ result: [String: Any]?, _ errorDesc: String?)->())?) {
        guard let address = address, let fromAddress = TronAddress(address) else {
            completionHandler?(nil,LackInfoTip)
            return
        }
        DispatchQueue.global().async {
            do {
                let account = try self.provider.getAccount(fromAddress).wait()
                debugPrint("account", account)
                let result: [String: Any] = [
                    "balance": account.balance,
                    "create_time": account.createTime,
                    "latest_opration_time": account.latestOprationTime,
                ]
                DispatchQueue.main.async {
                    completionHandler?(result,nil)
                }
            } catch let error {
                debugPrint(error.localizedDescription)
                DispatchQueue.main.async {
                    completionHandler?(nil,error.localizedDescription)
                }
            }
        }
    }
    @objc public func trc20Info(address: String?, contractAddress: String?, completionHandler: ((_ result: [String: String]?, _ errorDesc: String?)->())?) {
        guard let address = address, let contractAddress = contractAddress else {
            completionHandler?(nil,LackInfoTip)
            return
        }
        let fromAddress = TronAddress(address)
        let cAddress = TronAddress(contractAddress)
        guard let c = self.tronWeb.contract(TronWeb.Utils.trc20ABI, at: cAddress), let params = [fromAddress] as? [AnyObject] else {
            completionHandler?(nil,LackInfoTip)
            return
        }
        DispatchQueue.global().async {
            do {
                let balanceOf = try c.read("balanceOf", parameters: params).wait()
                let decimals = try c.read("decimals").wait()
                let symbol = try c.read("symbol").wait()
                let result = [
                    "balance": "\(balanceOf["0"] ?? "0")",
                    "decimals": "\(decimals["0"] ?? "0")",
                    "symbol": "\(symbol["0"] ?? "")",
                ]
                DispatchQueue.main.async {
                    completionHandler?(result,nil)
                }
            } catch let error {
                debugPrint(error.localizedDescription)
                DispatchQueue.main.async {
                    completionHandler?(nil,error.localizedDescription)
                }
            }
        }
    }
    @objc public func balanceOf(address: String?, contractAddress: String?, completionHandler: ((_ result: String?, _ errorDesc: String?)->())?) {
        guard let address = address, let contractAddress = contractAddress else {
            completionHandler?(nil,LackInfoTip)
            return
        }
        let fromAddress = TronAddress(address)
        let cAddress = TronAddress(contractAddress)
        guard let c = self.tronWeb.contract(TronWeb.Utils.trc20ABI, at: cAddress), let params = [fromAddress] as? [AnyObject] else {
            completionHandler?(nil,LackInfoTip)
            return
        }
        DispatchQueue.global().async {
            do {
                let balanceOf = try c.read("balanceOf", parameters: params).wait()
                debugPrint(balanceOf)
                DispatchQueue.main.async {
                    completionHandler?("\(balanceOf["0"] ?? "0")",nil)
                }
            } catch let error {
                debugPrint(error.localizedDescription)
                DispatchQueue.main.async {
                    completionHandler?(nil,error.localizedDescription)
                }
            }
        }
    }
    @objc public func symbol(contractAddress: String?, completionHandler: ((_ result: String?, _ errorDesc: String?)->())?) {
        guard let contractAddress = contractAddress, let cAddress = TronAddress(contractAddress), let c = self.tronWeb.contract(TronWeb.Utils.trc20ABI, at: cAddress) else {
            completionHandler?(nil,LackInfoTip)
            return
        }
        DispatchQueue.global().async {
            do {
                let symbol = try c.read("symbol").wait()
                DispatchQueue.main.async {
                    completionHandler?("\(symbol["0"] ?? "")",nil)
                }
            } catch let error {
                debugPrint(error.localizedDescription)
                DispatchQueue.main.async {
                    completionHandler?(nil,error.localizedDescription)
                }
            }
        }
    }
    @objc public func decimals(contractAddress: String?, completionHandler: ((_ result: String?, _ errorDesc: String?)->())?) {
        guard let contractAddress = contractAddress, let cAddress = TronAddress(contractAddress), let c = self.tronWeb.contract(TronWeb.Utils.trc20ABI, at: cAddress) else {
            completionHandler?(nil,LackInfoTip)
            return
        }
        DispatchQueue.global().async {
            do {
                let decimals = try c.read("decimals").wait()
                DispatchQueue.main.async {
                    completionHandler?("\(decimals["0"] ?? "")",nil)
                }
            } catch let error {
                debugPrint(error.localizedDescription)
                DispatchQueue.main.async {
                    completionHandler?(nil,error.localizedDescription)
                }
            }
        }
    }
}
