//
//  PW_Solana.swift
//  TokenWalletProject
//
//  Created by mnz on 2022/4/26.
//  Copyright © 2022 . All rights reserved.
//

import Solana

class PW_Solana: NSObject {
    static let network: Network = .mainnetBeta
    static let router = NetworkingRouter(endpoint: .mainnetBetaSolana)
//    static let network: Network = .devnet
//    static let router = NetworkingRouter(endpoint: .devnetSolana)
    private static let AccountErrorTip = "account empty";
    private static let LackInfoTip = "lack of information";
    class var solana: Solana {
        Solana(router: PW_Solana.router)
    }
    class func getAccount(secretKey: String?) -> Account? {
        if let secretKey = secretKey, let data = Data(base64Encoded: secretKey), let account = Account(secretKey: data) {
            return account
        }
        return nil
    }
    @objc
    class func createAccount() -> [String: Any]? {
        let seedPhrase = ConcreteSeedPhrase()
        return self.restoreAccount(phrase: seedPhrase.getSeedPhrase())
    }
    @objc
    class func restoreAccount(phrase: [String]) -> [String: String]? {
        let seedPhrase = ConcreteSeedPhrase()
        if (seedPhrase.isValid(wordlist: phrase)) {
            if let account = Account(phrase: phrase, network: PW_Solana.network, derivablePath: .default) {
                return self.accountToDict(account: account)
            }
        }
        return nil
    }
    @objc
    class func restoreAccount(secretKey: String) -> [String: String]? {//no phrase
        if let account = getAccount(secretKey: secretKey) {
            return self.accountToDict(account: account, noPhrase: true)
        }
        return nil
    }
    class func accountToDict(account: Account, noPhrase: Bool = false) -> [String: String] {
        let secretKey = account.secretKey.base64EncodedString();
        let phrase: [String] = noPhrase ? [] : account.phrase;
        return ["phrase":phrase.joined(separator: " "),"publicKey":account.publicKey.base58EncodedString,"secretKey":secretKey]
    }
    @objc
    class func airdrop(account: String, completionBlock: @escaping ((_ result: String?, _ errorDesc: String?)->())) {
        PW_Solana.solana.api.requestAirdrop(account: account, lamports: 1000000000, commitment: .none) { result in
            do {
                let success = try result.get()
                completionBlock(success,nil)
            }catch let error {
                completionBlock(nil,error.localizedDescription)
            }
        };
    }
    @objc
    class func getAccountInfo(account: String, completionBlock: @escaping ((_ result: [String: Any]?, _ errorDesc: String?)->())) {
        PW_Solana.solana.api.getAccountInfo(account: account, decodedTo: AccountInfo.self) { result in
            do {
                let info = try result.get()
                let data: [String: Any] = ["owner":info.owner,"lamports":info.lamports,"executable":info.executable,"rentEpoch":info.rentEpoch]
                completionBlock(data,nil)
            }catch let error {
                completionBlock(nil,error.localizedDescription)
            }
        }
    }
    @objc
    class func getBalance(account: String, completionBlock: @escaping ((_ result: String?, _ errorDesc: String?)->())) {
        PW_Solana.solana.api.getBalance(account: account, commitment: nil) { result in
            do {
                let balance = try result.get()
                completionBlock(String(balance),nil)
            }catch let error {
                completionBlock(nil,error.localizedDescription)
            }
        }
    }
    @objc
    class func sendSOL(secretKey: String, to: String, amount: UInt64, completionBlock: @escaping ((_ result: String?, _ errorDesc: String?)->())) {
        if let data = Data(base64Encoded: secretKey), let account = Account(secretKey: data) {
            PW_Solana.solana.action.sendSOL(to: to, from: account, amount: amount) { result in
                do {
                    let hash = try result.get()
                    completionBlock(hash,nil)
                }catch let error {
                    completionBlock(nil,error.localizedDescription)
                }
            }
        }else{
            completionBlock(nil,AccountErrorTip)
        }
    }
    @objc
    class func sendSPL(mintAddress: String?,
                secretKey: String?,
                to: String?,
                amount: UInt64,
                completionBlock: @escaping ((_ result: String?, _ errorDesc: String?)->())) {
        if let account = getAccount(secretKey: secretKey), let mintAddress = mintAddress, let to = to {
            PW_Solana.solana.action.sendSPLTokens(mintAddress: mintAddress, from: account.publicKey.base58EncodedString, to: to, amount: amount, payer: account) { result in
                do {
                    let hash = try result.get()
                    completionBlock(hash,nil)
                }catch let error {
                    completionBlock(nil,error.localizedDescription)
                }
            }
        }else{
            completionBlock(nil,AccountErrorTip)
        }
    }
    @objc
    class func getTokenWallets(account: String?, completionBlock: @escaping ((_ wallets: [String: Any]?, _ errorDesc: String?)->())) {
        if let account = account {
            PW_Solana.solana.action.getTokenWallets(account: account) { result in
                do {
                    let wallets = try result.get()
//                    completionBlock(wallets,nil)
                }catch let error {
                    completionBlock(nil,error.localizedDescription)
                }
            }
        }else{
            completionBlock(nil,AccountErrorTip)
        }
    }
    @objc
    class func createTokenAccount(mintAddress: String?, secretKey: String?, completionBlock: @escaping ((_ result: [String: String]?, _ errorDesc: String?)->())) {
        if let account = PW_Solana.getAccount(secretKey: secretKey), let mintAddress = mintAddress {
            PW_Solana.solana.action.createTokenAccount(mintAddress: mintAddress, payer: account) { result in
                do {
                    let (signature,newPubkey) = try result.get()
                    completionBlock(["signature":signature,"newPubkey":newPubkey],nil)
                }catch let error {
                    completionBlock(nil,error.localizedDescription)
                }
            }
        }else{
            completionBlock(nil,AccountErrorTip)
        }
    }
    @objc
    class func closeTokenAccount(tokenPubkey: String, secretKey: String, completionBlock: @escaping ((_ result: String?, _ errorDesc: String?)->())) {
        if let account = PW_Solana.getAccount(secretKey: secretKey) {
            PW_Solana.solana.action.closeTokenAccount(account: account, tokenPubkey: tokenPubkey) { result in
                do {
                    let hash = try result.get()
                    completionBlock(hash,nil)
                }catch let error {
                    completionBlock(nil,error.localizedDescription)
                }
            }
        }else{
            completionBlock(nil,AccountErrorTip)
        }
    }
    @objc
    class func findSPLTokenDestinationAddress(mintAddress: String?, destinationAddress: String?, completionBlock: @escaping ((_ result: String?, _ errorDesc: String?)->())) {
        if let mintAddress = mintAddress, let destinationAddress = destinationAddress {
            PW_Solana.solana.action.findSPLTokenDestinationAddress(mintAddress: mintAddress, destinationAddress: destinationAddress) { result in
                do {
                    let spl = try result.get()
                    completionBlock(spl.destination.base58EncodedString,nil)
                }catch let error {
                    completionBlock(nil,error.localizedDescription)
                }
            }
        }else{
            completionBlock(nil,LackInfoTip)
        }
    }
    @objc
    class func getOrCreateAssociatedTokenAccount(secretKey: String, mintAddress: String, completionBlock: @escaping ((_ result: [String: String]?, _ errorDesc: String?)->())) {
        if let account = PW_Solana.getAccount(secretKey: secretKey), let tokenMint = PublicKey(string: mintAddress) {
            PW_Solana.solana.action.getOrCreateAssociatedTokenAccount(owner: account.publicKey, tokenMint: tokenMint, payer: account) { result in
                do {
                    let (transactionId,associatedTokenAddress) = try result.get()
                    completionBlock(["hash":transactionId?.description ?? "","address":associatedTokenAddress.base58EncodedString],nil)
                }catch let error {
//                    completionBlock(nil,error.localizedDescription)
                    WQJLog("getOrCreateAssociatedTokenAccount error"+error.localizedDescription)
                    PW_Solana.solana.action.createAssociatedTokenAccount(for: account.publicKey, tokenMint: tokenMint, payer: account) { result in
                        do {
                            let transactionId = try result.get()
                            completionBlock(["hash":transactionId.description],nil)
                        }catch let error {
                            completionBlock(nil,error.localizedDescription)
                        }
                    };
                }
            }
        }else{
            completionBlock(nil,AccountErrorTip)
        }
    }
}
