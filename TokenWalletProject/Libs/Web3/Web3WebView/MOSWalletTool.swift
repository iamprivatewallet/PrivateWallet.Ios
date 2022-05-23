//
//  MOSWalletTool.swift
//  MOS_Client_IOS
//
//  Created by mnz on 2020/11/29.
//  Copyright © 2020 WangQJ. All rights reserved.
//

import UIKit
import web3swift
import BigInt
import CocoaSecurity

fileprivate let mnemonicsKey = "mnemonicsKey"
class MOSWalletTool: NSObject {
    private let rpcType: Networks = .Mainnet
    @objc
    private let rpcAccessToken = "9aa3d95b3bc440fa88ea12eaa4456161"
    @objc
    private var rpcHost: String {
        get {
            return self.web3.provider.url.host ?? ""
        }
    }
    @objc
    public var rpcUrl: String {
        get {
            return self.web3.provider.url.absoluteString
        }
    }
    @objc
    public var rpcWssUrl: String {
        get {
            return "wss://\(rpcHost)/ws/v3/\(rpcAccessToken)"
        }
    }
    @objc var chainID: UInt {
        get {
            return UInt(self.web3.provider.network?.chainID ?? 0)
        }
    }
    static var entity : MOSWalletTool?
    @objc
    public class func shared() -> MOSWalletTool{
        if entity == nil{
            entity = MOSWalletTool()
        }
        return entity ?? MOSWalletTool()
    }
    private var isHDWallet: Bool {
        get {
            guard let data = NSData(contentsOfFile:  MOSWalletTool.keyStoreFilePath()) else {return false}
            let dict = try? JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers) as? [String: Any]
            let isHDWallet = dict?["isHDWallet"] as? Bool ?? false
            return isHDWallet
        }
    }
    private static var entityWeb3: web3?
    public var web3: web3 {
        get {
//        do {
//            let userDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
//            var keystoreManager = KeystoreManager.managerForPath(userDir + "/keystore")
//            var ks: EthereumKeystoreV3?
//            if (keystoreManager?.addresses?.count == 0) {
//                ks = try EthereumKeystoreV3(password: MOSWalletTool.shared().password)
//                let keydata = try JSONEncoder().encode(ks!.keystoreParams)
//                FileManager.default.createFile(atPath: userDir + "/keystore"+"/key.json", contents: keydata, attributes: nil)
//                keystoreManager = KeystoreManager.managerForPath(userDir + "/keystore")
//            }
//            guard let sender = keystoreManager?.addresses![0] else {return nil}
//            WQJLog(sender)
//            let provider = InfuraProvider(rpcType, accessToken: rpcAccessToken)!
//            let provider = Web3HttpProvider(URL(string: "https://bsc-dataseed1.binance.org")!)
            let defaultUrlStr = kETHRPCUrl;
            let urlStr = SettingManager.sharedInstance().getCurrentNode().first as? String ?? defaultUrlStr
            var url = URL(string: urlStr)
            if(url==nil||urlStr.hasPrefix("http://")) {
                url = URL(string: defaultUrlStr)
            }
            if (MOSWalletTool.entityWeb3 == nil || MOSWalletTool.entityWeb3?.provider.url.absoluteString != url?.absoluteString){
                let semaphore = DispatchSemaphore(value: 1)
                semaphore.wait()
                guard let provider = Web3HttpProvider(url!) else {
                    var web3 = try? Web3.new(URL(string: urlStr)!)
                    if web3==nil {
                        web3 = try! Web3.new(URL(string: defaultUrlStr)!)
                    }
                    MOSWalletTool.entityWeb3 = web3
                    semaphore.signal()
                    return web3!
                }
                let web3 = web3swift.web3(provider: provider)
                web3.addKeystoreManager(keystoreManager)
                MOSWalletTool.entityWeb3 = web3
                semaphore.signal()
                return web3
            }else{
                return MOSWalletTool.entityWeb3!
            }
//        }catch{
//            WQJLog(error)
//        }
        }
    }
    private var keystoreManager: KeystoreManager? {
        get {
//        let data = wallet.data
//        let keystoreManager: KeystoreManager
//        if wallet.isHD {
//            let keystore = BIP32Keystore(data)!
//            keystoreManager = KeystoreManager([keystore])
//        } else {
//            let keystore = EthereumKeystoreV3(data)!
//            keystoreManager = KeystoreManager([keystore])
//        }
            let keystoreManager = KeystoreManager.managerForPath(MOSWalletTool.keyStorePath(), scanForHDwallets: MOSWalletTool.shared().isHDWallet, suffix: nil)
            return keystoreManager
        }
    }
    private class func keyStorePath() -> String {
        if let userDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            return userDir + "/keystore"
        }
        return ""
    }
    private class func keyStoreFilePath() -> String {
        return keyStorePath() + "/key.json"
    }
    //是否有钱包
    class func hasWallet() -> Bool {
        return (MOSWalletTool.shared().keystoreManager?.addresses?.count ?? 0) > 0
    }
    //随机生成
    class func randomMnemonics() -> String? {
        let mnemonics = try? BIP39.generateMnemonics(bitsOfEntropy: 128)
        if let mnemonics = mnemonics {
            return mnemonics
        }
        return nil
    }
    //根据助记词导入
    @objc
    class func createOrImportWallet(_ mnemonics: String, password: String) -> String? {
        // 助记词转换为随机种子
        guard let seed = BIP39.seedFromMmemonics(mnemonics) else {return nil}
        if let keystore = try? BIP32Keystore(seed: seed, password: password) {
            let keydata = try? JSONEncoder().encode(keystore.keystoreParams)
            let filePath = keyStoreFilePath()
            if FileManager.default.fileExists(atPath: filePath) {
                try? FileManager.default.removeItem(atPath: filePath)
            }
            FileManager.default.createFile(atPath: filePath, contents: keydata, attributes: nil)
            guard let sender = keystore.addresses?.first else {return nil}
            //保存助记词
            if let mnemonicsValue = CocoaSecurity.aesEncrypt(mnemonics, key: password)?.base64 {
                UserDefaults.standard.set(mnemonicsValue, forKey: mnemonicsKey)
                UserDefaults.standard.synchronize()
            }
            WQJLog(sender)
            return sender.address
        }
        return nil
    }
    //获取助记词
    class func mnemonicsWithWallet(password: String) -> String? {
        if (MOSWalletTool.shared().keystoreManager?.addresses?.first) != nil {
            if MOSWalletTool.shared().isHDWallet {
                let mnemonicsValue = UserDefaults.standard.string(forKey: mnemonicsKey)
                return CocoaSecurity.aesDecrypt(withBase64: mnemonicsValue, key: password)?.utf8String
            }else{
                return nil
            }
        }
        return nil
    }
    //创建V3钱包
    class func createV3Wallet(password: String) -> String? {
        if let keystore = try? EthereumKeystoreV3(password: password) {
            let keydata = try? JSONEncoder().encode(keystore.keystoreParams)
            let filePath = keyStoreFilePath()
            if FileManager.default.fileExists(atPath: filePath) {
                try? FileManager.default.removeItem(atPath: filePath)
            }
            FileManager.default.createFile(atPath: filePath, contents: keydata, attributes: nil)
            guard let sender = keystore.addresses?.first else {return nil}
            WQJLog(sender)
            return sender.address
        }
        return nil
    }
    //根据私钥导入
    class func importWallet(_ privateKey: String, password: String) -> String? {
        let formattedKey = privateKey.trimmingCharacters(in: .whitespacesAndNewlines)
        if let data = Data.fromHex(formattedKey), let keystore = try? EthereumKeystoreV3(privateKey: data, password: password) {
            let keydata = try? JSONEncoder().encode(keystore.keystoreParams)
            let filePath = keyStoreFilePath()
            if FileManager.default.fileExists(atPath: filePath) {
                try? FileManager.default.removeItem(atPath: filePath)
            }
            FileManager.default.createFile(atPath: filePath, contents: keydata, attributes: nil)
            guard let sender = keystore.addresses?.first else {return nil}
            WQJLog(sender)
            return sender.address
        }
        return nil
    }
    //获取私钥
    class func getPrivateKey(password: String) -> String? {
        if let account = MOSWalletTool.shared().keystoreManager?.addresses?.first {
            if MOSWalletTool.shared().isHDWallet {
                let privateKey = try? MOSWalletTool.shared().keystoreManager?.bip32keystores.first?.UNSAFE_getPrivateKeyData(password: password, account: account)
                return privateKey?.toHexString()
            }else{
                let privateKey = try? MOSWalletTool.shared().keystoreManager?.keystores.first?.UNSAFE_getPrivateKeyData(password: password, account: account)
                return privateKey?.toHexString()
            }
        }
        return nil
    }
    //获取当前账号
    @objc
    class func getCurrentAddress() -> String {
        return MOSWalletTool.shared().keystoreManager?.addresses?.first?.address ?? SettingManager.sharedInstance().getCurrentAddress() ?? ""
    }
    //查询余额
    @objc
    class func getCurrentBalance(completionHandler: @escaping ((_ balance: String?)->())) {
        DispatchQueue.global(qos: .background).async {
            if let account = MOSWalletTool.shared().keystoreManager?.addresses?.first, let balanceResult = try? MOSWalletTool.shared().web3.eth.getBalance(address: account) {
                let result = Web3.Utils.formatToEthereumUnits(balanceResult, toUnits: .eth, decimals: 8) ?? ""
                DispatchQueue.main.async {
                    completionHandler(result)
                }
            }else{
                DispatchQueue.main.async {
                    completionHandler(nil)
                }
            }
        }
    }
    //收款码
    class func qrImage() -> UIImage? {
        if let account = MOSWalletTool.shared().keystoreManager?.addresses?.first {
            var eip67Data = Web3.EIP67Code(address: account)
            eip67Data.gasLimit = BigUInt(21000)
            eip67Data.amount = BigUInt("1000000000000000000")
            let encoding = eip67Data.toImage(scale: 10.0)
            return UIImage(ciImage: encoding)
        }
        return nil
    }
    //退出钱包
    class func logoutWallet() {
        //删除助记词
        UserDefaults.standard.removeObject(forKey: mnemonicsKey)
        UserDefaults.standard.synchronize()
        //删除本地json
        let filePath = keyStoreFilePath()
        if FileManager.default.fileExists(atPath: filePath) {
            try? FileManager.default.removeItem(atPath: filePath)
        }
    }
}
