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
    func privateKey(account: String) -> Account
    func client() -> Client
    func network() -> Network
}

public class SafariWalletCore {
    
    public static let shared = SafariWalletCore()
    
    private (set) var delegate: SafariWalletCoreDelegate? = nil

    private init() { }
}
