//
//  CovalentClient.swift
//  
//
//  Created by Tassilo von Gerlach on 11/6/21.
//

import Foundation
import Network
import MEWwalletKit
import Alamofire

public final class CovalentClient {
    
    let network: Network
    let covalentKey: String
    
    public init?(network: Network = .ethereum, covalentKey: String) {
        self.network = network
        self.covalentKey = covalentKey
    }
    
    public func getTransactions(chain: String,
                                address: String,
                                currency: String,
                                symbol: String) async throws -> [Covalent.Transaction] {
        let req = AF.request(
            "https://api.covalenthq.com/v1/\(self.network.chainID)/address/\(address)/transactions_v2/",
            method: .get,
            parameters: [
                "key": covalentKey,
                "quote-currency": currency
            ]
        )
        
        return try await withCheckedThrowingContinuation({ continuation in
            req.responseDecodable(of: Covalent.CovalentResponse<Covalent.GetTransactionsResponseData>.self) { dataResponse in
                switch dataResponse.result {
                    case .success(let transactionResponse):
                        return continuation.resume(with: .success(transactionResponse.data.items))
                    case .failure(let error):
                        print("Tassi - ERROR")
                        print(error)
                        return continuation.resume(throwing: error)
                }
            }
        })
        
//
//            req.responseData { responseData in
//                switch dataResponse.result {
//                    case .success(let data):
//                        return continuation.resume(with: .success(transactionResponse.items))
//                    case .failure(let error):
//                        return continuation.resume(throwing: error)
//                }
//                let jsonRpcResponse = try JSONDecoder().decode(JsonRpcResponse<R>.self, from: data)
//            }
            
//            req.responseDecodable(of: Covalent.CovalentResponse<Covalent.GetTransactionsResponse>) { dataResponse in
//                switch dataResponse.result {
//                    case .success(let transactionResponse):
//                        return continuation.resume(with: .success(transactionResponse.items))
//                    case .failure(let error):
//                        print("Tassi - ERROR")
//                        print(error)
//                        return continuation.resume(throwing: error)
//                }
//            }
//            req.responseJSON { res in
//                var transactions: [Covalent.Transaction] = []
//                if let json = res.value as? [String: Any] {
//                    if let data = json["data"] as? [String: Any] {
//                        if let items = data["items"] as? [[String: Any]] {
//                            let dateformatter = DateFormatter()
//                            dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
//                            for item in items {
//                                var tx = Covalent.Transaction()
//
//                                tx.block_signed_at = dateformatter.date(from: (item["block_signed_at"] as? String)!)!
//                                tx.block_height = item["block_height"] as? Int
//                                tx.tx_hash = item["tx_hash"] as? String
//                                tx.tx_offset = item["tx_offset"] as? Int
//                                tx.successful = item["successful"] as? Bool
//                                tx.from_address = item["from_address"] as? String
//                                tx.from_address_label = item["from_address_label"] as? String
//                                tx.to_address = item["to_address"] as? String
//                                tx.to_address_label = item["to_address_label"] as? String
//                                tx.value = item["value"] as? String
//                                tx.value_quote = item["value_quote"] as? Double
//                                tx.gas_offered = item["gas_offered"] as? Double
//                                tx.gas_spent = item["gas_spent"] as? Double
//                                tx.gas_price = item["gas_price"] as? Double
//                                tx.gas_quote = item["gas_quote"] as? Double
//                                tx.gas_quote_rate = item["gas_quote_rate"] as? Double
//
//                                transactions.append(tx)
//                            }
//                        } else {
//                            print("Error fetching transactions. Please check")
//                        }
//                    } else {
//                        print("Error fetching transactions. Please check")
//                    }
//                } else {
//                    print("Error fetching transactions. Please check")
//                }
//                return continuation.resume(with: .success(transactions))
//            }
    }
   
}
