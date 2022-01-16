//
//  Account.swift
//  
//
//  Created by Ronald Mannak on 11/1/21.
//

import Foundation
import MEWwalletKit

public struct Account {

    private let privateKey: PrivateKeyEth1
    public let addresss: Address
    public let client: EthereumClient?
    
    public init(bip39: BIP39, derivationIndex: Int, client: EthereumClient? = nil) async throws {
        
        guard let seed = try bip39.seed() else { throw WalletError.emptySeed }
        let wallet = try Wallet<PrivateKeyEth1>(seed: seed)
        self.privateKey = try await wallet.privateKeyFor(index: derivationIndex)
        guard let address = privateKey.address() else { throw WalletCoreError.addressGenerationError }
        self.addresss = address
        self.client = client
    }
    
    public init(privateKey: PrivateKeyEth1, client: EthereumClient? = nil) throws {
        self.privateKey = privateKey
        guard let address = privateKey.address() else { throw WalletCoreError.addressGenerationError }
        self.addresss = address
        self.client = client
    }
    
    public func signMessage(hexString: String) throws -> String {
        guard let data = Data(hex: hexString).hashPersonalMessage() else {
            throw WalletCoreError.invalidHexString(hexString)
        }
        guard let signedMessage = data.sign(key: privateKey, leadingV: false)?.toHexString().addHexPrefix() else {
            throw WalletCoreError.signingError
        }
        return signedMessage
    }
    
    // See: https://blog.mycrypto.com/new-transaction-types-on-ethereum
    // And https://eips.ethereum.org/EIPS/eip-712#arbitrary-messages
    
//    public func sign(tx: Transaction) throws -> String {
//        sign
//    }
    
//    public func gasEIP1559
    
    
    /// See https://medium.com/alchemy-api/the-developer-eip-1559-prep-kit-72dbe5c44545
    ///
    /// Steps to sign an EIP1559 transaction:
    /// 1) init EthereumClient
    /// 2) 
    /// 3) set nonce using return value of client.ethTransactionCount()
    /// 4) Send raw transaction client.
    ///
    /// - Parameter tx: <#tx description#>
    /// - Returns: <#description#>
    public func signEIP1559(tx: EIP1559Transaction) async throws -> Data {
        
        guard let client = client as? AlchemyClient else {
            throw WalletCoreError.incompatibleClient
        }
        
//        let nonce = try await client.ethTransactionCount(address: self.addresss)
//        tx.nonce = try await client.ethTransactionCount(address: self.addresss)
        
        
        try tx.sign(key: self.privateKey)
        let sig = tx.serialize()
        
//        try tx.sign(key: privateKey)
//        guard let data = tx.serialize(), let string = String(data: data, encoding: .utf8)?.addHexPrefix() else {
//            throw WalletCoreError.signingError
//        }
//        return string
        return Data()
    }
    
    public func sign(_ transaction: Transaction) -> Data {
        return Data()
    }
    
    public func encrypt(cleartext: Data) -> Data {
        return Data()
    }


    
}
