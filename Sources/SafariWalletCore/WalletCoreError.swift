//
//  WalletCoreError.swift
//  
//
//  Created by Ronald Mannak on 10/31/21.
//

import Foundation

enum WalletCoreError: Error {
    case unexpectedResponse(String)
    case noMethod
    case invalidMethod
    case noParameters
    case unknownMethod(String)
    case addressGenerationError
}
