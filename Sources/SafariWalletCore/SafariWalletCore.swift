//
//  SafariWalletCore.swift
//
//
//  Created by Ronald Mannak on 10/30/21.
//

import MEWwalletKit

public protocol SafariWalletCoreDelegate {
    func addresses() -> [Address]
    func defaultAddress() -> Address
    func privateKey(account: String) -> PrivateKeyEth1 //Account
    func network() -> Network
}

public class SafariWalletCore {
    
    public static let shared = SafariWalletCore()
    
    private (set) var delegate: SafariWalletCoreDelegate? = nil
    private (set) var client: Client? = nil
    
    public func setup(delegate: SafariWalletCoreDelegate, key: String) {
        self.delegate = delegate
        client = AlchemyClient(network: delegate.network(), key: key)
    }

    private init() { }
}
