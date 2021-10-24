//
//  File.swift
//  
//
//  Created by Neil Jain on 10/24/21.
//

import UIKit

public extension CGAffineTransform {
    init(from source: CGRect, to destination: CGRect) {
        let t = CGAffineTransform.identity
            .translatedBy(x: destination.midX - source.midX, y: destination.midY - source.midY)
            .scaledBy(x: destination.width / source.width, y: destination.height / source.height)
        self.init(a: t.a, b: t.b, c: t.c, d: t.d, tx: t.tx, ty: t.ty)
    }
}
