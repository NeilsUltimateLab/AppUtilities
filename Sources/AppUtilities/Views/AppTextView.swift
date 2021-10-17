//
//  File.swift
//  
//
//  Created by Neil Jain on 3/26/21.
//

import UIKit

/// A `UITextView` subclass to provide an instant text change callback.
///
///
/// ```swift
/// class AppTextViewCell: UITableViewCell {
///
///     private lazy var textView: AppTextView = {
///         let field = AppTextView(frame: .zero)
///         field.translatesAutoresizingMaskIntoConstraints = false
///         field.onTextChange = { [weak self] text in
///             print(text)
///         }
///         return field
///     }()
///
/// }
/// ```

open class AppTextView: UITextView, UITextViewDelegate {
    
    /// Sets the limit for the numbers of characters.
    ///
    /// this parameter is considered when provided non-nil value.
    public var maxCharacters: Int?
    
    /// A callback for the text change.
    ///
    /// This is called with latest value from `UITextView.textDidChangeNotification` notification.
    public var onTextChange: ((String?)->Void)?
    
    /// A callback for keyboard arrival.
    public var onBecomeFirstResponder: (()->Void)?
    
    /// A callback for keyboard dismissal.
    public var onResignFirstResponder: (()->Void)?
    
    /// Allows the return keyboard press action.
    ///
    /// Default is `false`
    public var shouldResignOnReturnKeypress: ()->Bool = { false }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        observeTextChanges()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        observeTextChanges()
    }
    
    private func observeTextChanges() {
        self.delegate = self
        NotificationCenter.default.addObserver(forName: UITextView.textDidChangeNotification, object: nil, queue: nil) { [weak self] (notification) in
            guard let textView = notification.object as? UITextView, textView === self else { return }
            self?.onTextChange?(textView.text)
        }
    }
    
    
    @discardableResult
    /// Calls ``onBecomeFirstResponder`` if super class allows.
    /// - Returns: returns the value from super class.
    open override func becomeFirstResponder() -> Bool {
        let can = super.becomeFirstResponder()
        if can {
            self.onBecomeFirstResponder?()
        }
        return can
    }
    
    
    @discardableResult
    /// Calls ``onResignFirstResponder`` if super class allows.
    /// - Returns: returns the value from super class.
    open override func resignFirstResponder() -> Bool {
        let can = super.resignFirstResponder()
        if can {
            self.onResignFirstResponder?()
        }
        return can
    }
    
    open override var canResignFirstResponder: Bool {
        return true
    }
    
    /// Adjusts the text characters for return keyboard via ``shouldResignOnReturnKeypress`` and character limit via ``maxCharacters``.
    /// - Parameters:
    ///   - textView: textView instance
    ///   - range: range of the replacement text
    ///   - text: replacement text
    /// - Returns: return `false` if `return` button from keyboard is pressed and ``shouldResignOnReturnKeypress`` allowed and if ``maxCharacters`` limit reached.
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard (text as NSString).rangeOfCharacter(from: .newlines).location == NSNotFound, shouldResignOnReturnKeypress()
        else {
                self.resignFirstResponder()
                return false
        }
        if let maxCharacters = self.maxCharacters {
            
            let currentText = textView.text ?? ""
               // attempt to read the range they are trying to change, or exit if we can't
               guard let stringRange = Range(range, in: currentText) else { return false }

               // add their new text to the existing text
               let updatedText = currentText.replacingCharacters(in: stringRange, with: text)

               // make sure the result is under 16 characters
               return updatedText.count <= maxCharacters
        }
        return true
    }
}

