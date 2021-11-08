//
//  File.swift
//  
//
//  Created by Tassilo von Gerlach on 11/6/21.
//

import Foundation

public enum Covalent {
    
    public struct Transaction: Codable, Hashable, Identifiable {
        public var id = UUID()
        public var block_signed_at: Date?
        public var block_height: Int?
        public var tx_hash: String?
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
        // TODO - implement logEvents array
    }
    
}
