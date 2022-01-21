//
//  ENSService.swift
//  Wallet (iOS)
//
//  Created by Stefano on 14.01.22.
//

import Foundation
import MEWwalletKit

public protocol ENSReverseResolvable {
    func resolve(address: String) async throws -> String
}

public extension ENSReverseResolvable {
    
    func resolve(address: Address) async throws -> String {
        try await resolve(address: address.address)
    }
}

public protocol ENSResolvable {
    func resolve(ens: String) async throws -> String
}

public extension ENSResolvable {
    
    func resolve(ens: String) async throws -> Address {
        let rawAddress = try await resolve(ens: ens)
        return Address(raw: rawAddress)
    }
}

public final class ENSResolver {
    
    private let client: EthereumClient?
    private let ensContract: ENSContract
    private let network: Network
    
    public init(network: Network, provider: NodeProvider) {
        self.network = network
        self.client = EthereumClient(network: network, provider: provider)
        self.ensContract = ENSContract(network: network)
    }
}

// MARK: - ENSReverseResolvable

extension ENSResolver: ENSReverseResolvable {
    
    public func resolve(address: String) async throws -> String {
        guard let client = client else { throw ENSError.clientError }
        
        // Normalise and hash the name
        let hashedName = hash(address: address)
        
        // Call resolver() on the ENS registry. This returns the address of the resolver responsible for the name.
        let resolverAddressHex = try await resolver(forName: hashedName)
        
        guard resolverAddressHex != .nullAddress else { throw ENSError.resolverContractUnknown }
        let resolverAddress = decode(address: resolverAddressHex)
        
        // Resolve the ENS name with the returned resolver
        let nameCall = ensContract.nameResolver.name(hashedName, contractAddress: Address(raw: resolverAddress))
        let ensNameHex: String = try await client.ethCall(call: nameCall)
        
        guard let ensName = decode(ensName: ensNameHex) else {
            throw ENSError.failedDecoding
        }
        
        guard !ensName.isEmpty else { throw ENSError.ensUnknown }
        
        return ensName
    }
    
    private func hash(address: String) -> String {
        let ensReverse = address.lowercased().stripHexPrefix() + ".addr.reverse"
        return hash(name: ensReverse).addHexPrefix()
    }
    
    private func decode(ensName hex: String) -> String? {
        return ABIDecoder.decodeSignleType(type: .string, data: Data(hex: hex)).value as? String
    }
}

// MARK: - ENSResolvable

extension ENSResolver: ENSResolvable {
    
    public func resolve(ens: String) async throws -> String {
        guard let client = client else { throw ENSError.clientError }
        
        // Normalise and hash the name
        let hashedName = hash(name: ens).addHexPrefix()
        
        // Call resolver() on the ENS registry. This returns the address of the resolver responsible for the name.
        let resolverAddressHex = try await resolver(forName: hashedName)
        
        // Resolve the address with the returned resolver
        guard resolverAddressHex != .nullAddress else { throw ENSError.resolverContractUnknown }
        let resolverAddress = decode(address: resolverAddressHex)
        
        let addrCall = ensContract.addrResolver.addr(hashedName, contractAddress: Address(raw: resolverAddress))
        let addressHex: String = try await client.ethCall(call: addrCall)
        let address = decode(address: addressHex)
        
        guard address != .nullAddress else { throw ENSError.ensUnknown }
        
        return address
    }
}

// MARK: - Private

private extension ENSResolver {
    
    func hash(name: String) -> String {
        let ensComponents = name.components(separatedBy: ".")
        let hashedEns = ensComponents.reversed().reduce(Data(count: 32)) { data, component in
            var data = data
            let componentData = component.data(using: .utf8) ?? Data()
            data.append(componentData.sha3(.keccak256))
            return data.sha3(.keccak256)
        }
        return hashedEns.toHexString()
    }
    
    func resolver(forName name: String) async throws -> String {
        guard let client = client else { throw ENSError.clientError }
        let resolverCall = ensContract.registry.resolver(name)
        let resolverAddressHex: String = try await client.ethCall(call: resolverCall)
        return resolverAddressHex
    }
    
    func decode(address hex: String) -> String {
        let index = hex.index(hex.endIndex, offsetBy: -40)
        let rawAddress = String(hex[index...]).addHexPrefix()
        return rawAddress
    }
}

private extension String {
    
    static let nullAddress = "0x0000000000000000000000000000000000000000000000000000000000000000"
}

public enum ENSError: Error {
    case invalidName
    case ensUnknown
    case resolverContractUnknown
    case failedDecoding
    case clientError
}
