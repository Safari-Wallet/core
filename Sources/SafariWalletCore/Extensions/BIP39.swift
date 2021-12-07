//
//  BIP39.swift
//  
//
//  Created by Ronald Mannak on 12/6/21.
//

import Foundation
import MEWwalletKit

extension BIP39 {
    
    convenience init(mnemonic: String) throws {
        self.init(mnemonic: mnemonic.components(separatedBy: " "))
    }
}
