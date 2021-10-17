//
//  File.swift
//  
//
//  Created by Neil Jain on 4/11/21.
//

import SwiftUI

/// SwiftUI representation of ``AppTextView``.
public struct AppTextEditor: UIViewRepresentable {
    
    /// Text value for the textView to edit.
    @Binding public var text: String
    
    /// Sets the fonts of ``AppTextView``.
    public var font: UIFont = .systemFont(ofSize: 17)
    
    /// Sets scrolling enable/disable of ``AppTextView``.
    public var isScrollEnabled: Bool = true
    
    /// Callback for the instant text change.
    public var onTextChange: ((String?)->Void)?
    
    /// Callback for keyboard presentation.
    public var onBecomeResponder: (()->Void)?
    
    /// Callback for keyboard dismissal.
    public var onResignResponder: (()->Void)?
    
    public init(text: Binding<String>, font: UIFont = .systemFont(ofSize: 17), isScrollEnabled: Bool = true, onTextChange: ((String?)->Void)? = nil, onBecomeResponder: (()->Void)? = nil, onResignResponder: (()->Void)? = nil) {
        self._text = text
        self.font = font
        self.isScrollEnabled = isScrollEnabled
        self.onTextChange = onTextChange
        self.onBecomeResponder = onBecomeResponder
        self.onResignResponder = onResignResponder
    }
    
    public typealias UIViewType = AppTextView
    
    public func makeUIView(context: Context) -> AppTextView {
        let view = AppTextView(frame: .zero)
        view.backgroundColor = .clear
        view.onTextChange = { string in
            if let string = string {
                self.text = string
                self.onTextChange?(string)
            }
        }
        view.onBecomeFirstResponder = onBecomeResponder
        view.onResignFirstResponder = onResignResponder
        view.isScrollEnabled = isScrollEnabled
        view.font = font
        return view
    }
    
    public func updateUIView(_ uiView: AppTextView, context: Context) {
        uiView.text = text
        uiView.isScrollEnabled = isScrollEnabled
        uiView.backgroundColor = .clear
    }

}
