//
//  File.swift
//  
//
//  Created by Neil Jain on 7/4/21.
//

import UIKit

open class AppTextField: UITextField {
    
    open var onTextChange: ((String?)->Void)?
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

    deinit {
        if let token = self.textDidChangeToken {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
}


