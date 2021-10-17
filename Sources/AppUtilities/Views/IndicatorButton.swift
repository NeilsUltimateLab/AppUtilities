//
//  File.swift
//  
//
//  Created by Neil Jain on 6/6/21.
//

import UIKit

/// Shows the indicator view in button.
open class IndicatorButton: UIButton {
    
    /// Sets color of progress bar of ``MaskedProgressLabelView/progressTintColor``.
    open var progressTintColor: UIColor = .blue {
        didSet {
            self.progressView.progressTintColor = progressTintColor
        }
    }
    
    /// A optional text to show when ``isAnimating``
    open var loadingText: String = ""
    
    /// A callback to indicate for animation start or stop.
    ///
    /// Called with `true` when ``startAnimating()`` and
    /// `false` when ``stopAnimating()``.
    public var onAnimating: ((Bool)->Void)?
    
    private var indicatingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var loadingLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    /// Shows when ``startAnimating()`` and hides at ``stopAnimating()``.
    ///
    /// - Defaults :
    ///     - style: `UIActivityIndicatorView.Style.medium`
    ///     - `hidesWhenStopped = true`
    public var indicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .medium)
        aiv.hidesWhenStopped = true
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.isUserInteractionEnabled = false
        return aiv
    }()
    
    /// Sets a progress bar when invoked ``updateProgress(progress:)``.
    ///
    /// This does not allow user interaction.
    ///
    /// - Defaults :
    ///     - ``MaskedProgressLabelView/textColor`` = `self.tintColor`
    ///     - ``MaskedProgressLabelView/textAlignment`` = `.center`
    public lazy var progressView: MaskedProgressLabelView = {
        let progressView = MaskedProgressLabelView(frame: .zero)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.isUserInteractionEnabled = false
        progressView.textAlignment = .center
        progressView.textColor = self.tintColor
        return progressView
    }()
    
    /// A flag to show if button is animating.
    ///
    /// this returns `true`/`false` when `UIActivityIndicatorView.isAnimating`.
    public var isAnimating: Bool {
        return indicatorView.isAnimating
    }
    
    private var previousText: String?
    private var previousImage: UIImage?
    private var imageInset: UIEdgeInsets = .zero
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        self.layer.shadowColor = UIColor.clear.cgColor
        self.layer.cornerRadius = 8
        self.previousText = currentTitle
        self.addSubview(indicatingStackView)
        self.addSubview(progressView)
        indicatingStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        indicatingStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        indicatingStackView.addArrangedSubview(indicatorView)
        indicatorView.color = self.tintColor
        indicatingStackView.addArrangedSubview(loadingLabel)
        
        progressView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        progressView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        progressView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        progressView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        progressView.progressTintColor = progressTintColor
        self.sendSubviewToBack(progressView)
    }
    
    /// Sets the title (if not empty) and store it to restore title when ``stopAnimating()``.
    ///
    /// this function will return without an effect when ``isAnimating``.
    /// - Parameters:
    ///   - title: Optional title
    ///   - state: UIControl state in which title to be shown.
    public override func setTitle(_ title: String?, for state: UIControl.State) {
        guard !isAnimating else { return }
        super.setTitle(title, for: state)
        if title?.isEmpty ?? true {
            return
        }
        self.previousText = title
    }
    
    /// This hides title and image and shows ``indicatorView``.
    ///
    /// `isEnabled` sets to `false`.
    ///
    /// ``onAnimating`` is called with `true`.
    open func startAnimating() {
        self.previousImage = self.imageView?.image
        self.imageInset = self.imageEdgeInsets
        self.imageEdgeInsets = .zero
        self.setTitle("", for: .normal)
        if loadingText.optionalString == nil {
            loadingLabel.isHidden = true
        } else {
            loadingLabel.isHidden = false
            loadingLabel.text = loadingText
        }
        indicatorView.startAnimating()
        self.setImage(nil, for: [])
        self.isEnabled = false
        self.onAnimating?(true)
    }
    
    /// Hides the ``indicatorView`` and restores the previous title, image.
    ///
    /// `isEnabled` sets to `true`
    ///
    /// ``onAnimating`` is called with `false`.
    open func stopAnimating() {
        self.isEnabled = true
        self.imageEdgeInsets = imageInset
        self.indicatorView.stopAnimating()
        if let previousImage = previousImage {
            self.imageView?.image = previousImage
            self.setImage(previousImage, for: [])
        }
        self.setTitle(previousText, for: .normal)
        self.onAnimating?(false)
    }
    
    /// Sets the ``progressView`` mask.
    /// - Parameter progress: progress in range of 0...1
    ///
    /// this sets the progress view with title `"Updating \(progress * 100)%"`
    /// and clears the title when progress reaches to 1.
    open func updateProgress(progress: Double) {
        self.loadingLabel.text = ""
        
        if progress > 0 {
            self.progressView.text = "Updating \(Int(progress * 100))%"
            //self.loadingLabel.text = "Updating \(Int(progress * 100))%"
        } else {
            self.loadingLabel.text = ""
        }
        
        if progress >= 1 {
            self.progressView.text = ""
        }
        
        self.progressView.percentage = CGFloat(progress)
    }
}


// MARK: - Preview
#if DEBUG
import SwiftUI
struct IndicatorButton_Preview: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            let v = IndicatorButton(frame: CGRect(x: 0, y: 0, width: 100, height: 54))
            v.backgroundColor = .systemBlue
            v.setTitle("Continue", for: .normal)
            v.tintColor = .white
            v.stopAnimating()
            v.indicatorView.color = .white
            v.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                v.startAnimating()
            }
            return v
        }
        .frame(width: 100, height: 54)
    }
}
#endif
