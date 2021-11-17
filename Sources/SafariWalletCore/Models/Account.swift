//
//  Account.swift
//  
//
//  Created by Ronald Mannak on 11/1/21.
//

import Foundation
import MEWwalletKit

public struct Account {
    
    public let addresss: Address
    public let publicKey: PublicKeyEth1
    public let privateKey: PrivateKeyEth1
    public let wallet: String
    public let derivationpath: String
    
    public init(privateKey: PrivateKeyEth1, wallet: String, derivationpath: String) throws {
        self.privateKey = privateKey
        self.publicKey = try privateKey.publicKey()
        guard let address = privateKey.address() else { throw WalletCoreError.addressGenerationError }
        self.addresss = address
        self.wallet = wallet
        self.derivationpath = derivationpath
    }
    
    public func sign(hexString: String) throws -> String {
        guard let data = Data(hex: hexString).hashPersonalMessage() else {
            throw WalletCoreError.invalidHexString(hexString)
        }
        guard let signedMessage = data.sign(key: privateKey, leadingV: false)?.toHexString().addHexPrefix() else {
            throw WalletCoreError.signingError
        }
        return signedMessage
    }
}
