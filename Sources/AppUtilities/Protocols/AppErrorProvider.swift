//
//  File.swift
//  
//
//  Created by Neil Jain on 3/26/21.
//

import UIKit

public protocol AppErrorProvider: Error {
    var title: String { get }
    var image: UIImage? { get }
    var message: String { get }
}
