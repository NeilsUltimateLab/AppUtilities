//
//  File.swift
//  
//
//  Created by Neil Jain on 3/26/21.
//

import UIKit

public struct FieldValue {
    var title: String
    var placeholder: String?
    var value: String?
    var keyboardType: UIKeyboardType = .default
    var isSelectable: Bool = false
    var formatter: NumberFormatter? = nil
    var maxCharacters: Int?
}

public extension FieldValue {
    init(title: String, placeholder: String?, value: String?) {
        self.title = title
        self.placeholder = placeholder
        self.value = value
    }
}
