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
    
    public func sign(message: Data) -> Data {
        return Data()
    }
    
    public func encrypt(cleartext: Data) -> Data {
        return Data()
    }
    
    public func sign(_ transaction: Transaction) -> Data {
        return Data()
    }   
}
