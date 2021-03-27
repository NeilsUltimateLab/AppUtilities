//
//  File.swift
//  
//
//  Created by Neil Jain on 3/26/21.
//

import UIKit

open class AppTextView: UITextView {
    
    var onTextChange: ((String?)->Void)?
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        observeTextChanges()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        observeTextChanges()
    }
    
    private func observeTextChanges() {
        NotificationCenter.default.addObserver(forName: UITextView.textDidChangeNotification, object: nil, queue: nil) { [weak self] (notification) in
            guard let textView = notification.object as? UITextView, textView === self else { return }
            self?.onTextChange?(textView.text)
        }
    }
    
    open override var canResignFirstResponder: Bool {
        return true
    }

}

