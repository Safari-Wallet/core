//
//  AddressBundle.swift
//  Wallet
//
//  Created by Ronald Mannak on 11/17/21.
//

import Foundation
import MEWwalletKit

public class AddressBundle: Identifiable, ObservableObject, Codable {
    
    public var id: UUID
    
    /// Human readable, end-user defined name
    @Published public var walletName: String?
    
    @Published public private (set) var addresses: [AddressItem]
    
    @Published public var defaultAddressIndex: Int = 0
    
    public let type: PrivateKeyType
    
    public let network: Network // Supported: "Ropsten", "Ethereum", "Ethereum - Ledger Live"
    
    /// Initialize new address bundle
    /// - Parameters:
    ///   - walletName: Human readable name (e.g. "Ledger 1 Wallet")
    ///   - type: Private key type (keystore, hardware, etc)
    ///   - network: Network (e.g. Ethereum or Ropston)
    ///   - addresses: AddressItems
    public init(id: UUID, walletName: String? = nil, type: PrivateKeyType, network: Network = .ethereum, addresses: [AddressItem]) {
        self.id = id
        self.walletName = walletName
        self.addresses = addresses
        self.type = type
        self.network = network
    }
    
    public init(id: UUID, type: PrivateKeyType, network: Network = .ethereum, addresses: [MEWwalletKit.Address]) {
        self.id = id
        self.type = type
        self.network = network
        self.addresses = []
        let items = addresses.enumerated().map { (index, address) in
            AddressItem(address: address, derivationIndex: index, bundleUUID: id, accountName: nil)
        }
        self.addresses = items
    }
    
    public enum CodingKeys: CodingKey {
        case id
        case walletName
        case addresses
        case type
        case network
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        walletName = try container.decode(String?.self, forKey: .walletName)
        addresses = try container.decode([AddressItem].self, forKey: .addresses)
        type = try container.decode(PrivateKeyType.self, forKey: .type)
        network = try container.decode(Network.self, forKey: .network)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(walletName, forKey: .walletName)
        try container.encode(addresses, forKey: .addresses)
        try container.encode(type, forKey: .type)
        try container.encode(network, forKey: .network)
    }
}

extension AddressBundle: Equatable {
    
    public static func == (lhs: AddressBundle, rhs: AddressBundle) -> Bool {
        lhs.id == rhs.id
    }
}

extension AddressBundle {

    public enum PrivateKeyType: Codable {
        case keystorePassword
        case keystoreSecureEnclave
        case viewOnly
        case nanoLedgerX(id: String, bip44: Bool)
        case nanoLedgerS(id: String, bip44: Bool)
        case trezor(id: String)
    }
}
