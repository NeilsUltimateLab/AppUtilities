//
//  File.swift
//  
//
//  Created by Neil Jain on 3/26/21.
//

import UIKit

/// Provides a container for `UITextField`, `UITextView` or any `UIKeyInput` class configuration.
public struct FieldValue: Hashable {
    public var title: String
    public var placeholder: String?
    public var value: String?
    public var keyboardType: UIKeyboardType = .default
    public var isSelectable: Bool = false
    public var formatter: NumberFormatter? = nil
    public var maxCharacters: Int?
}

public extension FieldValue {
    init(title: String, placeholder: String?, value: String?) {
        self.title = title
        self.placeholder = placeholder
        self.value = value
    }
}
