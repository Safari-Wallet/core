//
//  Client.swift
//  Wallet
//
//  Created by Ronald Mannak on 10/24/21.
//

import Foundation
import MEWwalletKit
import Network
import BigInt

public class Client {
    
    
    /// The number of times the client will attempt to resend a rate limited request before giving up. Default: 3.
    /// See https://docs.alchemy.com/alchemy/documentation/alchemy-web3#maxretries
    var maxRetries = 3
    
    /// The minimum time waited between consecutive retries, in milliseconds. Default: 1000.
    /// See https://docs.alchemy.com/alchemy/documentation/alchemy-web3#retryinterval
    var retryInterval = 1000
        
    /// A random amount of time is added to the retry delay to help avoid additional rate errors caused by too many concurrent connections,
    /// chosen as a number of milliseconds between 0 and this value. Default: 250.
    /// See https://docs.alchemy.com/alchemy/documentation/alchemy-web3#retryjitter
    var retryJitter = 250
        
    private (set) var isConnected: Bool = false
    
    let jsonRpcClient: JsonRpcClient
    let network: Network
    let monitor = NWPathMonitor()
    
    public init?(network: Network = .ethereum, baseURL: ClientBaseURL) {
        guard let baseURL = baseURL.baseURL(for: network) else { return nil }
        self.jsonRpcClient = JsonRpcClient(url: baseURL)
        self.network = network
        self.monitor.pathUpdateHandler = { self.isConnected = ($0.status == .satisfied) }
        self.monitor.start(queue: DispatchQueue.global(qos: .background))
    }
    
    deinit {
        self.monitor.cancel()
    }
}

// MARK: - Web3 API
extension Client {
    
    
    /*
     curl https://eth-mainnet.alchemyapi.io/v2/your-api-key \
     -X POST \
     -H "Content-Type: application/json" \
     -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":0}'
     */
    public func ethBlockNumber() async throws -> Int {
        let response = try await jsonRpcClient.makeRequest(method: "eth_blockNumber", resultType: String.self)
        guard let blockHeight = Int(response.stripHexPrefix(), radix: 16) else {
            throw WalletCoreError.unexpectedResponse(response)
        }
        return blockHeight
    }
    
    /*
     curl https://eth-mainnet.alchemyapi.io/v2/your-api-key \
     -X POST \
     -H "Content-Type: application/json" \
     -d '{"jsonrpc":"2.0","method":"eth_getBalance","params":["0xc94770007dda54cF92009BFF0dE90c06F603a09f", "latest"],"id":0}'
     */
    public func ethGetBalance(address: String, blockNumber: Block = .latest) async throws -> Wei {
        let result = try await jsonRpcClient.makeRequest(method: "eth_getBalance", params: [address, blockNumber.stringValue], resultType: String.self)
        guard let balance = Wei(hexString: result) else { throw WalletCoreError.unexpectedResponse(result) }
        return balance
    }
    
    
    /// https://eth.wiki/json-rpc/API#eth_call
    /// - Parameter params: <#params description#>
    /// - Returns: <#description#>
    public func ethCall(method: String, params: Any) async throws -> Any {
        return try await jsonRpcClient.makeRequest(method: method, dictParams: params)
    }
    
}
