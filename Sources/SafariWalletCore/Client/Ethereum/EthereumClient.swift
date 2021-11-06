//
//  EthereumClient.swift
//  
//
//  Created by Tassilo von Gerlach on 11/6/21.
//

import Foundation
import BigInt

public class EthereumClient: BaseClient {
   
   public init?(provider: NodeProvider) {
      super.init(network: .ethereum, provider: provider)
   }
   
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
   public func ethGetBalance(address: String, blockNumber: Block = .latest) async throws -> BigUInt {
       let result = try await jsonRpcClient.makeRequest(method: "eth_getBalance", params: [address, blockNumber.stringValue], resultType: String.self)
       guard let balance = BigUInt(result.stripHexPrefix(), radix: 16) else { throw WalletCoreError.unexpectedResponse(result) }
       return balance
   }
   
}
