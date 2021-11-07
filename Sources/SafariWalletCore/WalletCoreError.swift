//
//  WalletCoreError.swift
//  
//
//  Created by Ronald Mannak on 10/31/21.
//

import Foundation

public enum WalletCoreError: Error {
    case unexpectedResponse(String)
    case noMethod
    case invalidMethod
    case invalidParams
    case noParameters
    case unknownMethod(String)
    case addressGenerationError
    case notImplemented
    case noDefaultAccount
    case noDefaultWallet
    case noClient
    case noCoreDelegate
}
