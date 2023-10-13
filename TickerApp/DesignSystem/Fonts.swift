//
//  SFProRounded.swift
//  TickerApp
//
//  Created by Serj on 03.10.2023.
//

import Foundation
import UIKit

struct SFProRounded {
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

//struct LED24 {
//    static func set(fontSize: CGFloat) -> UIFont {
//        return UIFont(name: "24Led-LE4D", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
//    }
//}
//
//
//extension UIFont {
//    struct Led24_LE4D {
//        var fontName: String {
//            return "24Led-LE4D"
//        }
//    }
//    
//    convenience init(font: Led24_LE4D, size: CGFloat) {
//        self.init(name: font.fontName, size: size)!
//    }
//}
