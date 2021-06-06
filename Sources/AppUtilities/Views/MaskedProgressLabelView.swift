//
//  File.swift
//  
//
//  Created by Neil Jain on 6/6/21.
//

import UIKit

public class MaskedProgressLabelView: UIView {
        
    public var text: String = "" {
        didSet {
            self.underlayTextLabel.text = self.text
            self.maskedLabel.text = self.text
        }
    }
    
    public var font: UIFont = UIFont.systemFont(ofSize: UIFont.labelFontSize) {
        didSet {
            self.maskedLabel.font = self.font
            self.underlayTextLabel.font = self.font
        }
    }
    
    public var textColor: UIColor = .black {
        didSet {
            self.underlayTextLabel.textColor = self.textColor
        }
    }
    
    public var textAlignment: NSTextAlignment = .center {
        didSet {
            self.maskedLabel.textAlignment = self.textAlignment
            self.underlayTextLabel.textAlignment = self.textAlignment
        }
    }
    
    public var percentage: CGFloat = 0 {
        didSet {
            self.update(percentage: percentage)
        }
    }
    
    public var progressTintColor: UIColor = UIColor.systemBlue {
        didSet {
            self.progressView.backgroundColor = self.progressTintColor
        }
    }
    
    private lazy var underlayTextLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = self.font
        label.textAlignment = self.textAlignment
        label.textColor = self.textColor
        return label
    }()
    
    private lazy var maskedLabel: UILabel = {
        let label = UILabel(frame: self.bounds)
        label.font = self.font
        label.textAlignment = self.textAlignment
        return label
    }()
    
    private lazy var progressView: UIView = {
        let view = UIView(frame: self.bounds)
        view.backgroundColor = self.progressTintColor
        return view
    }()
    
    private lazy var maskedProgressView: UIView = {
        let view = UIView(frame: self.bounds)
        view.backgroundColor = .white
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.addSubview(underlayTextLabel)
        underlayTextLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        underlayTextLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        underlayTextLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        underlayTextLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        self.addSubview(progressView)
        progressView.frame = self.bounds
        
        self.addSubview(maskedProgressView)
        maskedProgressView.frame = self.bounds
        
        maskedProgressView.mask = maskedLabel
        maskedLabel.textColor = .white
        self.update(percentage: self.percentage)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.maskedLabel.frame = self.bounds
        self.progressView.frame.size.height = self.bounds.height
        self.maskedProgressView.frame.size.height = self.bounds.height
    }
    
    private func update(percentage: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.maskedProgressView.frame.size.width = self.bounds.width * percentage
            self.progressView.frame.size.width = self.bounds.width * percentage
        }
    }

}

