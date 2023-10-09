//
//  SFProRounded.swift
//  TickerApp
//
//  Created by Serj on 03.10.2023.
//

import Foundation
import UIKit

struct SFProRounded {
    
//    private static
    static func set(fontSize: CGFloat, weight: UIFont.Weight) -> UIFont {
        
        let systemFont = UIFont.systemFont(ofSize: fontSize, weight: weight)
        let roundedFont: UIFont
        if let descriptor = systemFont.fontDescriptor.withDesign(.rounded) {
            roundedFont = UIFont(descriptor: descriptor, size: fontSize)
        } else {
            roundedFont = systemFont
        }
        
        return roundedFont
    }
}
