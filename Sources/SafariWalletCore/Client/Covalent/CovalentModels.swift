//
//  File.swift
//  
//
//  Created by Tassilo von Gerlach on 11/6/21.
//

import Foundation

public enum Covalent {
    
    public struct CovalentResponse<D: Codable>: Codable {
        let data: D
        let error: Bool
        let error_message: String?
        let error_code: Int?
    }
    
    public struct GetTransactionsResponseData: Codable {
        let address: String
        
        //Leaving these are strings for now since iso8601 decoding fails
        //Covalent also don't spcifiy why date format is expected
        let updated_at: String
        let next_update_at: String
        
        let quote_currency: String
        let chain_id: Int
        let items: [Transaction]
    }
    
    public struct Transaction: Codable, Hashable, Identifiable {
        public var id: String {
            return tx_hash
        }
        public var block_signed_at: Date
        public var block_height: Int?
        public var tx_hash: String
        public var tx_offset: Int?
        public var successful: Bool?
        public var from_address: String?
        public var from_address_label: String?
        public var to_address: String?
        public var to_address_label: String?
        public var value: String?
        public var value_quote: Double?
        public var gas_offered: Double?
        public var gas_spent: Double?
        public var gas_price: Double?
        public var gas_quote: Double?
        public var gas_quote_rate: Double?
    }
    
}
