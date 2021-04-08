//
//  File.swift
//  
//
//  Created by Neil Jain on 3/29/21.
//

import UIKit

public extension UIView {
    func anchor(_ view: UIView, edge: UIRectEdge = .all) {
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        if edge.contains(.left) {
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        }
        if edge.contains(.right) {
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        }
        if edge.contains(.top) {
            view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        }
        if edge.contains(.bottom) {
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        }
    }
}

public extension UILayoutGuide {
    func anchor(_ view: UIView, in parentView: UIView, edge: NSEdgeConstraint = .all) {
        parentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        if edge.rectEdge.contains(.left) {
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: edge.constant).isActive = true
        }
        if edge.rectEdge.contains(.right) {
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: edge.constant).isActive = true
        }
        if edge.rectEdge.contains(.top) {
            view.topAnchor.constraint(equalTo: self.topAnchor, constant: edge.constant).isActive = true
        }
        if edge.rectEdge.contains(.bottom) {
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: edge.constant).isActive = true
        }
    }
}

public struct NSEdgeConstraint: OptionSet {
    public var rawValue: UInt
    
    var rectEdge: UIRectEdge
    var constant: CGFloat
    
    public init(rawValue: UInt) {
        self.rawValue = rawValue
        self.rectEdge = UIRectEdge(rawValue: rawValue)
        self.constant = 0
    }
    
    public init(rectEdge: UIRectEdge, constant: CGFloat) {
        self.rawValue = rectEdge.rawValue
        self.rectEdge = rectEdge
        self.constant = constant
    }
}

public extension NSEdgeConstraint {
    static func leading(spacing constant: CGFloat = 0) -> NSEdgeConstraint {
        NSEdgeConstraint(rectEdge: .left, constant: constant)
    }
    static func trailing(spacing constant: CGFloat = 0) -> NSEdgeConstraint {
        NSEdgeConstraint(rectEdge: .right, constant: -constant)
    }
    static func top(spacing constant: CGFloat = 0) -> NSEdgeConstraint {
        NSEdgeConstraint(rectEdge: .top, constant: constant)
    }
    static func bottom(spacing constant: CGFloat = 0) -> NSEdgeConstraint {
        NSEdgeConstraint(rectEdge: .bottom, constant: -constant)
    }
    static func all(spacing constant: CGFloat = 0) -> NSEdgeConstraint {
        NSEdgeConstraint(rectEdge: .all, constant: constant)
    }
    
    static var all: NSEdgeConstraint {
        Self.all(spacing: 0)
    }
    static var leading: NSEdgeConstraint {
        Self.leading(spacing: 0)
    }
    static var trailing: NSEdgeConstraint {
        Self.trailing(spacing: 0)
    }
    static var top: NSEdgeConstraint {
        Self.top(spacing: 0)
    }
    static var bottom: NSEdgeConstraint {
        Self.bottom(spacing: 0)
    }
}
