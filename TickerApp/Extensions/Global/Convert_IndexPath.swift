//
//  Convert IndexPath.swift
//  TickerApp
//
//  Created by Serj on 18.10.2023.
//

import Foundation



public func encodeIndexPath(indexPathArr: [IndexPath] ) -> Data {
    let indexPathData = try? NSKeyedArchiver.archivedData(withRootObject: indexPathArr, requiringSecureCoding: false)
    let data = indexPathData?.base64EncodedData()
    return data ?? Data()
}

public func decodeIndexPath(indexPathData: Data) -> [IndexPath] {
    guard let data = Data(base64Encoded: indexPathData) else { return [] }
    let indexPathArr = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [IndexPath]
    guard let indexPathArr else { return [] }
    return indexPathArr
}
