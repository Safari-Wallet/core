//
//  File.swift
//  
//
//  Created by Ronald Mannak on 11/8/21.
//

import Foundation
import MEWwalletKit

public struct Call: Codable {
    let from: Address?
    let to: Address
    let gas: Int? // BigInt?
    let gasPrice: Wei?
    let value: Wei?
    let data: String?
}
