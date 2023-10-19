//
//  Convert UIColor.swift
//  TickerApp
//
//  Created by Serj on 14.10.2023.
//

import Foundation
import UIKit

public func encodeUIColor(color: UIColor) -> String {
    let colorData = try? NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)
    let colorString = colorData?.base64EncodedString()
    return colorString ?? ""
}

public func decodeUIColor(colorString: String?) -> UIColor? {
    guard let colorString = colorString else { return nil }
    let data = Data(base64Encoded: colorString)
    guard let data = data else { return nil }
    let color = try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data)
    return color
}
