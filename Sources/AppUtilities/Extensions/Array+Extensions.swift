//
//  File.swift
//  
//
//  Created by Neil Jain on 3/26/21.
//

import Foundation

public extension Array {
    subscript(safe index: Index) -> Element? {
        get {
            if index < self.count, index >= 0 {
                return self[index]
            }
            return nil
        }
        set {
            if index < self.count, index >= 0, let newVal = newValue {
                self[index] = newVal
            }
        }
    }
    
    func grouped(into size: Int) -> [Array] {
        stride(from: 0, to: count, by: size).map{
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}
