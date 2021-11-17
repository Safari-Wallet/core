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
        public let page: Int
        public let total_pages: Int
        public let items_on_page: Int
        public let total_txs: Int
        public let transactions: [TokenTransaction]
    }
    
    public struct TokenTransaction: Codable {
        public let hash: String
        public let from: Address
        public let to: Address?
        public let fee: String
        public let date: Int
        public let status: String
        public let type: String?
        public let value: String
        public let description: String
        public let blockNumber: Int
        
        enum CodingKeys: String, CodingKey {
            case hash = "id"
            case from
            case to
            case fee
            case date
            case status
            case type
            case value
            case description
            case blockNumber = "block"
        }
    }
    
}
