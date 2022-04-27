//
//  PW_Solana.swift
//  TokenWalletProject
//
//  Created by mnz on 2022/4/26.
//  Copyright © 2022 . All rights reserved.
//

import Solana
import KeychainSwift

class PW_Solana: NSObject {
    static let network: Network = .devnet//.mainnetBeta
    static let router = NetworkingRouter(endpoint: .devnetSolana)//.mainnetBetaSolana)
    class var solana: Solana {
        Solana(router: PW_Solana.router)
    }
    @objc
    class func createAccount() -> [String: Any]? {
        let seedPhrase = ConcreteSeedPhrase()
        return self.restoreAccount(phrase: seedPhrase.getSeedPhrase())
    }
    @objc
    class func restoreAccount(phrase: [String]) -> [String: Any]? {
        let seedPhrase = ConcreteSeedPhrase()
        if (seedPhrase.isValid(wordlist: phrase)) {
            if let account = Account(phrase: phrase, network: PW_Solana.network, derivablePath: .default) {
                return self.accountToDict(account: account)
            }
        }
        return nil
    }
    @objc
    class func restoreAccount(secretKey: String) -> [String: Any]? {//no phrase
        if let data = Data(base64Encoded: secretKey), let account = Account(secretKey: data) {
            return self.accountToDict(account: account, noPhrase: true)
        }
        return nil
    }
    class func accountToDict(account: Account, noPhrase: Bool = false) -> [String: Any] {
        let secretKey = account.secretKey.base64EncodedString();
        let phrase: [String] = noPhrase ? [] : account.phrase;
        return ["phrase":phrase,"publicKey":account.publicKey.base58EncodedString,"secretKey":secretKey]
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
            completionBlock(nil,"account empty")
        }
    }
    @objc
    class func sendSPL(mintAddress: String,
                secretKey: String,
                to: String,
                amount: UInt64,
                completionBlock: @escaping ((_ result: String?, _ errorDesc: String?)->())) {
        if let data = Data(base64Encoded: secretKey), let account = Account(secretKey: data) {
            PW_Solana.solana.action.sendSPLTokens(mintAddress: mintAddress, from: account.publicKey.base58EncodedString, to: to, amount: amount, payer: account) { result in
                do {
                    let hash = try result.get()
                    completionBlock(hash,nil)
                }catch let error {
                    completionBlock(nil,error.localizedDescription)
                }
            }
        }else{
            completionBlock(nil,"account empty")
        }
    }
}
