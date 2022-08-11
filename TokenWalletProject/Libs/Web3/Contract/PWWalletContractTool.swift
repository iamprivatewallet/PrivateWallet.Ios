////
////  PWWalletContractTool.swift
////  TokenWalletProject
////
////  Created by mnz on 2022/6/17.
////  Copyright © 2022 . All rights reserved.
////
//
//import UIKit
//import BigInt
//import web3
//
//class PWWalletContractTool: NSObject {
//    static var sharedObj = PWWalletContractTool()
//    private var client: EthereumClient?
//    private var erc20: ERC20?
//    private var erc721: ERC721?
//    private var erc721Metadata: ERC721Metadata?
//    @objc public class func shared() -> PWWalletContractTool {
//        let defaultUrlStr = kETHRPCUrl;
//        let urlStr = SettingManager.sharedInstance().getCurrentNode().first as? String ?? defaultUrlStr
//        if(sharedObj.client?.url.absoluteString != urlStr){
//            sharedObj = PWWalletContractTool()
//        }
//        return sharedObj
//    }
//    override init() {
//        let defaultUrlStr = kETHRPCUrl;
//        let urlStr = SettingManager.sharedInstance().getCurrentNode().first as? String ?? defaultUrlStr
//        self.client = EthereumClient(url: URL(string: urlStr)!)
//        self.erc20 = ERC20(client: client!)
//        self.erc721 = ERC721(client: client!)
//        self.erc721Metadata = ERC721Metadata(client: client!, metadataSession: URLSession.shared)
//    }
//    @objc
//    public func estimateGas(toAddress: String?, completionHandler: @escaping ((_ gasPrice: String?, _ gas: String?, _ errorDesc: String?)->())) {
//        estimateGas(toAddress: toAddress, extraData: nil, completionHandler: completionHandler)
//    }
//    @objc
//    public func estimateGas(toAddress: String?, extraData: Data?, completionHandler: ((_ gasPrice: String?, _ gas: String?, _ errorDesc: String?)->())?) {
//        var to = EthereumAddress(EthereumAddress.zero.toChecksumAddress())
//        if (toAddress ?? "").count != 0 {
//            to = EthereumAddress(toAddress ?? "")
//        }
//        let transaction = EthereumTransaction(to: to, data: extraData ?? Data())
//        client?.eth_gasPrice(completionHandler: { [weak self] gasPrice in
//            self?.client?.eth_estimateGas(transaction, completionHandler: { gas in
//                do {
//                    let gasPrice = try gasPrice.get()
//                    let gas = try gas.get()
//                    DispatchQueue.main.async {
//                        completionHandler?("\(gasPrice)","\(gas)",nil)
//                    }
//                } catch let error {
//                    debugPrint("estimateGas"+error.localizedDescription)
//                    DispatchQueue.main.async {
//                        completionHandler?(nil,nil,error.localizedDescription)
//                    }
//                }
//            })
//        })
//    }
//    @objc
//    public func estimateGasToken(toAddress: String?, token: String?, completionHandler: @escaping ((_ gasPrice: String?, _ gas: String?, _ errorDesc: String?)->())) {
//        estimateGasToken(toAddress: toAddress, token: token, extraData: nil, completionHandler: completionHandler)
//    }
//    @objc
//    public func estimateGasToken(toAddress: String?, token: String?, extraData: Data?, completionHandler: ((_ gasPrice: String?, _ gas: String?, _ errorDesc: String?)->())?) {
//        var to = EthereumAddress(EthereumAddress.zero.toChecksumAddress())
//        if (toAddress ?? "").count != 0 {
//            to = EthereumAddress(toAddress ?? "")
//        }
//        let walletAddress = SettingManager.sharedInstance().getCurrentAddress()
//        client?.eth_gasPrice(completionHandler: { [weak self] gasPrice in
//            let function = TransferToken(wallet: EthereumAddress(walletAddress ?? ""),
//                                         token: EthereumAddress(token ?? ""),
//                                         to: to,
//                                         amount: 1,
//                                         data: extraData ?? Data(),
//                                         gasPrice: nil,
//                                         gasLimit: nil)
//            let transaction = (try? function.transaction()) ?? EthereumTransaction(to: to, data: extraData ?? Data())
//            self?.client?.eth_estimateGas(transaction, completionHandler: { gas in
//                do {
//                    let gasPrice = try gasPrice.get()
//                    let gas = try gas.get()
//                    DispatchQueue.main.async {
//                        completionHandler?("\(gasPrice)","\(gas * 3)",nil)
//                    }
//                } catch let error {
//                    debugPrint("estimateGasToken"+error.localizedDescription)
//                    DispatchQueue.main.async {
//                        completionHandler?(nil,nil,error.localizedDescription)
//                    }
//                }
//            })
//        })
//    }
//    @objc
//    public func balance(address: String, completionHandler: ((_ result: String?, _ errorDesc: String?)->())?) {
//        if address == "" {
//            completionHandler?(nil,"error")
//            return
//        }
//        client?.eth_getBalance(address: EthereumAddress(address), block: .Latest, completionHandler: { result in
//            do {
//                let balance = try result.get()
//                DispatchQueue.main.async {
//                    completionHandler?("\(balance)",nil)
//                }
//            } catch let error {
//                debugPrint("balance"+error.localizedDescription)
//                DispatchQueue.main.async {
//                    completionHandler?(nil,error.localizedDescription)
//                }
//            }
//        })
//    }
//    @objc
//    public func balanceERC20(address: String, contractAddress: String, completionHandler: ((_ result: String?, _ errorDesc: String?)->())?) {
//        if contractAddress.count == 0 || address == "" {
//            completionHandler?(nil,"error")
//            return
//        }
//        erc20?.balanceOf(tokenContract: EthereumAddress(contractAddress), address: EthereumAddress(address), completionHandler: { result in
//            do {
//                let balance = try result.get()
//                DispatchQueue.main.async {
//                    completionHandler?("\(balance)",nil)
//                }
//            } catch let error {
//                debugPrint("balance"+error.localizedDescription)
//                DispatchQueue.main.async {
//                    completionHandler?(nil,error.localizedDescription)
//                }
//            }
//        })
//    }
//    // 获取代币符号
//    @objc
//    public func symbolERC20(contractAddress: String, completionHandler: ((_ result: String?, _ errorDesc: String?)->())?) {
//        if contractAddress == "" {
//            completionHandler?(nil,"error")
//        }
//        erc20?.symbol(tokenContract: EthereumAddress(contractAddress), completionHandler: { result in
//            do {
//                let symbol = try result.get()
//                DispatchQueue.main.async {
//                    completionHandler?(symbol,nil)
//                }
//            } catch let error {
//                debugPrint("symbol"+error.localizedDescription)
//                DispatchQueue.main.async {
//                    completionHandler?(nil,error.localizedDescription)
//                }
//            }
//        })
//    }
//    // 获取代币小数位
//    @objc
//    public func decimalsERC20(contractAddress: String, completionHandler: ((_ result: Int, _ errorDesc: String?)->())?) {
//        if contractAddress == "" {
//            completionHandler?(0,"error")
//        }
//        erc20?.decimals(tokenContract: EthereumAddress(contractAddress), completionHandler: { result in
//            do {
//                let decimals = try result.get()
//                DispatchQueue.main.async {
//                    completionHandler?(Int(decimals),nil)
//                }
//            } catch let error {
//                debugPrint("decimals"+error.localizedDescription)
//                DispatchQueue.main.async {
//                    completionHandler?(0,error.localizedDescription)
//                }
//            }
//        })
//    }
//}
//
//// ERC721
//extension PWWalletContractTool {
//    @objc
//    public func balanceERC721(contract: String?, address: String?, completionHandler: ((_ result: String?, _ errorDesc: String?)->())?) {
//        guard let contract = contract, let address = address else {
//            completionHandler?(nil,"error")
//            return;
//        }
//        if contract == "" || address == "" {
//            completionHandler?(nil,"error")
//            return;
//        }
//        erc721?.balanceOf(contract: EthereumAddress(contract), address: EthereumAddress(address), completionHandler: { result in
//            do {
//                let balance = try result.get()
//                DispatchQueue.main.async {
//                    completionHandler?("\(balance)",nil)
//                }
//            } catch let error {
//                debugPrint("balanceOf"+error.localizedDescription)
//                DispatchQueue.main.async {
//                    completionHandler?(nil,error.localizedDescription)
//                }
//            }
//        })
//    }
//    @objc
//    public func nameERC721(address: String?, completionHandler: ((_ result: String?, _ errorDesc: String?)->())?) {
//        guard let address = address else {
//            completionHandler?(nil,"error")
//            return;
//        }
//        if address == "" {
//            completionHandler?(nil,"error")
//            return;
//        }
//        erc721Metadata?.name(contract: EthereumAddress(address), completionHandler: { result in
//            do {
//                let name = try result.get()
//                DispatchQueue.main.async {
//                    completionHandler?(name,nil)
//                }
//            } catch let error {
//                debugPrint("name"+error.localizedDescription)
//                DispatchQueue.main.async {
//                    completionHandler?(nil,error.localizedDescription)
//                }
//            }
//        })
//    }
//    @objc
//    public func symbolERC721(address: String?, completionHandler: ((_ result: String?, _ errorDesc: String?)->())?) {
//        guard let address = address else {
//            completionHandler?(nil,"error")
//            return;
//        }
//        if address == "" {
//            completionHandler?(nil,"error")
//            return;
//        }
//        erc721Metadata?.symbol(contract: EthereumAddress(address), completionHandler: { result in
//            do {
//                let symbol = try result.get()
//                DispatchQueue.main.async {
//                    completionHandler?(symbol,nil)
//                }
//            } catch let error {
//                debugPrint("symbol"+error.localizedDescription)
//                DispatchQueue.main.async {
//                    completionHandler?(nil,error.localizedDescription)
//                }
//            }
//        })
//    }
//    @objc
//    public func tokenURIERC721(address: String?, tokenID: String?, completionHandler: ((_ result: String?, _ errorDesc: String?)->())?) {
//        guard let address = address, let tokenID = tokenID, let tId = BigUInt(tokenID) else {
//            completionHandler?(nil,"error")
//            return;
//        }
//        if address == "" {
//            completionHandler?(nil,"error")
//            return;
//        }
//        erc721Metadata?.tokenURI(contract: EthereumAddress(address), tokenID: tId, completionHandler: { result in
//            do {
//                let URL = try result.get()
//                DispatchQueue.main.async {
//                    completionHandler?(URL.absoluteString,nil)
//                }
//            } catch let error {
//                debugPrint("symbol"+error.localizedDescription)
//                DispatchQueue.main.async {
//                    completionHandler?(nil,error.localizedDescription)
//                }
//            }
//        })
//    }
//}