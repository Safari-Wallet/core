//
//  UnmarshalModels.swift
//  
//
//  Created by Tassilo von Gerlach on 11/8/21.
//

import Foundation
import MEWwalletKit

public enum Unmarshal {
    
    public struct TokenTransactionsResponse: Codable {
        let page: Int
        let total_pages: Int
        let items_on_page: Int
        let total_txs: Int
        let transactions: [TokenTransaction]
    }
    
    public struct TokenTransaction: Codable {
        let transactionId: String
        let from: Address
        let to: Address
        let fee: String
        let date: Int
        let status: String
        let type: String
        let value: String
        let description: String
        
        enum CodingKeys: String, CodingKey {
            case transactionId = "id"
            case from
            case to
            case fee
            case date
            case status
            case type
            case value
            case description
        }
    }
    
}
