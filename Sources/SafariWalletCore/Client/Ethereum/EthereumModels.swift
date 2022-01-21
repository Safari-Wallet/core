//
//  File.swift
//  
//
//  Created by Ronald Mannak on 11/8/21.
//

import Foundation
import MEWwalletKit

public struct Call: Codable {
    public let from: Address?
    public let to: Address
    public let gas: Int? // BigInt?
    public let gasPrice: Wei?
    public let value: Wei?
    public let data: String?
    
    public init(
        from: Address? = nil,
        to: Address,
        gas: Int? = nil,
        gasPrice: Wei? = nil,
        value: Wei? = nil,
        data: String? = nil
    ) {
        self.from = from
        self.to = to
        self.gas = gas
        self.gasPrice = gasPrice
        self.value = value
        self.data = data
    }
    
}

public struct CallWrapper: Codable {
    
    let call: Call
    let block: Block

    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(call)
        try container.encode(block)
     }

}
