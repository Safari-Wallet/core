//
//  EthereumClient.swift
//  
//
//  Created by Tassilo von Gerlach on 11/6/21.
//

import Foundation
import MEWwalletKit
import BigInt

public class EthereumClient: BaseClient {
   
    public override init?(network: Network = .ethereum, provider: NodeProvider) {
      super.init(network: network, provider: provider)
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
   public func ethGetBalance(address: String, blockNumber: Block = .latest) async throws -> Wei {
       let result = try await jsonRpcClient.makeRequest(method: "eth_getBalance", params: [address, blockNumber.stringValue], resultType: String.self)
       guard let balance = Wei(hexString: result) else { throw WalletCoreError.unexpectedResponse(result) }
       return balance
   }
    
    /// https://eth.wiki/json-rpc/API#eth_call
    /// - Parameter params: <#params description#>
    /// - Returns: <#description#>
    public func ethCall(params: Call, blockNumber: Block = .latest) async throws -> Any {
        return Data()
//        let params: [Codable] = [params, blockNumber]
//        let result = jsonRpcClient.makeRequest(method: "eth_call", params: params, resultType: ???)
//        return result
//        
//        /* Return types:
//         Int
//         String
//         Dictionary (object in JavaScript)
//         Tuple of the above
//         Array of the above
//         */
    }
   
}
