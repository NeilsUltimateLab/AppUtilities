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
