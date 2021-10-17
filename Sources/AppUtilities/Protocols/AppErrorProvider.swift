//
//  File.swift
//  
//
//  Created by Neil Jain on 3/26/21.
//

import UIKit

/// Provides an user inteface for `Error`.
public protocol AppErrorProvider: Error {
    
    /// A title to be shown in UIAlert's title or in title of error ui.
    var title: String { get }
    
    /// An optional image to show the graphical representation of error.
    var image: UIImage? { get }
    
    /// Message to show the error reason and possible recovery tips.
    var message: String { get }
}
