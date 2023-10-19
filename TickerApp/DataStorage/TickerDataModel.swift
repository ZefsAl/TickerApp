//
//  DataModel.swift
//  TickerApp
//
//  Created by Serj on 13.10.2023.
//

import Foundation
import RealmSwift
import UIKit


// Будем хранить конфиг для TickerVIew
class TickerDataModel: Object {
    
    @Persisted(primaryKey: true) var _id: ObjectId

    @Persisted var inputText: String?
    @Persisted var textColor: String?
    @Persisted var textSpeed: Double?
    @Persisted var bgColor: String? 
    @Persisted var fontName: String?
    @Persisted var fontSize: Double?
    
    @Persisted var selectedEffectIndexData: Data = (encodeIndexPath(indexPathArr: [[0, 2]]) )
    @Persisted var selectedTextIndexData: Data = (encodeIndexPath(indexPathArr: [[0, 1], [2, 2], [1, 1]]) )
    @Persisted var selectedBackgroundIndexData: Data = (encodeIndexPath(indexPathArr: [[0, 0]]) )
    
    convenience init(
        selectedEffectIndexData: Data,
        selectedTextIndexData: Data,
        selectedBackgroundIndexData: Data
    ) {
        self.init()
        self.selectedEffectIndexData = selectedEffectIndexData
        self.selectedTextIndexData = selectedTextIndexData
        self.selectedBackgroundIndexData = selectedBackgroundIndexData
    }
    
    convenience init(
        inputText: String,
        textColor: String,
        textSpeed: Double,
        bgColor: String,
        fontName: String,
        fontSize: Double
    ) {
        self.init()
        self.inputText = inputText
        self.textColor = textColor
        self.textSpeed = textSpeed
        self.bgColor = bgColor
        self.fontName = fontName
        self.fontSize = fontSize
    }
}



