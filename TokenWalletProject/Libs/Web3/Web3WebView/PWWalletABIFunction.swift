////
////  PWWalletABIFunction.swift
////  TokenWalletProject
////
////  Created by mnz on 2022/6/27.
////  Copyright © 2022 . All rights reserved.
////
//
//import Foundation
//import web3
//import BigInt
//
//struct TransferToken: ABIFunction {
//    static let name = "transferToken"
//    let contract = EthereumAddress("0xe4f5384d96cc4e6929b63546082788906250b60b")
//    let from: EthereumAddress? = EthereumAddress("0xe4f5384d96cc4e6929b63546082788906250b60b")
//
//    let wallet: EthereumAddress
//    let token: EthereumAddress
//    let to: EthereumAddress
//    let amount: BigUInt
//    let data: Data
//
//    let gasPrice: BigUInt?
//    let gasLimit: BigUInt?
//
//    func encode(to encoder: ABIFunctionEncoder) throws {
//        try encoder.encode(wallet)
//        try encoder.encode(token)
//        try encoder.encode(to)
//        try encoder.encode(amount)
//        try encoder.encode(data)
//    }
//}
