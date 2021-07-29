//
//  File.swift
//  
//
//  Created by Neil Jain on 3/26/21.
//

import UIKit

open class AppTextView: UITextView, UITextViewDelegate {
    
    public var maxCharacters: Int?
    
    public var onTextChange: ((String?)->Void)?
    public var onBecomeFirstResponder: (()->Void)?
    public var onResignFirstResponder: (()->Void)?
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
    open override func becomeFirstResponder() -> Bool {
        let can = super.becomeFirstResponder()
        if can {
            self.onBecomeFirstResponder?()
        }
        return can
    }
    
    @discardableResult
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

