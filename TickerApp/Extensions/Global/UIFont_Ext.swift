//
//  Handjet_Setting.swift
//  TickerApp
//
//  Created by Serj on 10.12.2023.
//

import Foundation
import UIKit


// MARK: - Font
public extension UIFont {
    
    static func fontHandjet(_ size: CGFloat, axis: [Int: Float]) -> UIFont {
        let uiFontDescriptor = UIFontDescriptor(fontAttributes: [.name: "Handjet", kCTFontVariationAttribute as UIFontDescriptor.AttributeName: axis])
        let newUIFont = UIFont(descriptor: uiFontDescriptor, size: size)
        return newUIFont
    }
    
    
}
