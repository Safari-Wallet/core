//
//  Int.swift
//  
//
//  Created by Ronald Mannak on 10/31/21.
//

import Foundation

extension Int {
    var hexString: String {
        return "0x" + String(self, radix: 16, uppercase: true)
    }
}
