//
//  File.swift
//  
//
//  Created by Neil Jain on 8/8/21.
//

import Foundation

public extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}
