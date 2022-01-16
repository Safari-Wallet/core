//
//  File.swift
//  
//
//  Created by Ronald Mannak on 10/31/21.
//

import Foundation

fileprivate var hexPrefix = "0x"

extension String {
    
    public func stripHexPrefix() -> String {
        var hex = self
        if hex.hasPrefix(hexPrefix) {
            hex = String(hex.dropFirst(hexPrefix.count))
        }
        return hex
    }
    
    public func addHexPrefix() -> String {
        return hexPrefix.appending(self)
    }
        
    public func toHexString(uppercase: Bool = false, prefix: String? = nil) -> String {
        return unicodeScalars.map { prefix ?? "" + .init($0.value, radix: 16, uppercase: uppercase) }.joined()
    }
}
