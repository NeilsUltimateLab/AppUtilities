//
//  File.swift
//  
//
//  Created by Neil Jain on 7/4/21.
//

import UIKit

/// A `UITextField` subclass to provide an instant text change callback.
///
///
/// ```swift
/// class AppTextFieldCell: UITableViewCell {
///
///     private lazy var textField: AppTextField = {
///         let field = AppTextField(frame: .zero)
///         field.translatesAutoresizingMaskIntoConstraints = false
///         field.onTextChange = { [weak self] text in
///             print(text)
///         }
///         return field
///     }()
///
/// }
/// ```
open class AppTextField: UITextField {
    
    open var onTextChange: ((String?)->Void)?
    open var onBecomeFirstResponder: (()->Void)?
    open var onResignFirstResponder: (()->Void)?
    private var textDidChangeToken: Any?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        observeTextChanges()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        observeTextChanges()
    }
    
    private func observeTextChanges() {
        self.textDidChangeToken = NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: nil, queue: nil) { [weak self] (notification) in
            guard let textView = notification.object as? UITextField, textView === self else { return }
            self?.onTextChange?(textView.text)
        }
    }
    
    open override var canResignFirstResponder: Bool {
        return true
    }
    
    open override func becomeFirstResponder() -> Bool {
        let canBecome = super.becomeFirstResponder()
        if canBecome {
            self.onBecomeFirstResponder?()
        }
        return canBecome
    }
    
    open override func resignFirstResponder() -> Bool {
        let canResign = super.resignFirstResponder()
        if canResign {
            self.onResignFirstResponder?()
        }
        return canResign
    }

    deinit {
        if let token = self.textDidChangeToken {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
}


