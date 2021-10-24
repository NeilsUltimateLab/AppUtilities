//
//  File.swift
//  
//
//  Created by Neil Jain on 10/24/21.
//

import Foundation
import XCTest
import UIKit
@testable import AppUtilities

final class CGAffineTransformExtensionTests: XCTestCase {
    
    func testScaledTranslateNativeTranform() {
        let sourceRect = CGRect(x: 0, y: 0, width: 100, height: 100)
        let view = UIView(frame: sourceRect)
        let destinationRect = CGRect(x: 20, y: 40, width: 10, height: 10)
        
        let scale = CGAffineTransform(scaleX: 0.1, y: 0.1)
        let translate = CGAffineTransform(translationX: 20-45, y: 40-45)
        view.transform = scale.concatenating(translate)
        XCTAssertEqual(view.frame, destinationRect)
    }
    
    func testScaledTransform() {
        let sourceRect = CGRect(x: 0, y: 0, width: 100, height: 100)
        let destinationRect = CGRect(x: 20, y: 40, width: 10, height: 10)
        
        let view = UIView(frame: sourceRect)
        
        let scale = CGAffineTransform(from: sourceRect, to: destinationRect)
        view.transform = scale
        XCTAssertEqual(view.frame, destinationRect)
    }
    
    func testScaledTranslateTransform2() {
        let sourceRect = CGRect(x: 50, y: 307, width: 290, height: 230)
        let destinationRect = CGRect(x: 278, y: 317, width: 30, height: 30)
        let view = UIView(frame: destinationRect)
        let tranform = CGAffineTransform(from: destinationRect, to: sourceRect)
        view.transform = tranform
        XCTAssertEqual(view.frame, sourceRect)
    }
    
    static var allTests = [
        ("testScaledTranslateNativeTranform", testScaledTranslateNativeTranform),
        ("testScaledTransform", testScaledTransform),
        ("testScaledTranslateTransform2", testScaledTranslateTransform2)
    ]
}

