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
    @Persisted var dateAdded: Date?
    
    @Persisted var inputText: String?
    // MARK: - Effect
//    General
//    LED
//    Sparkle
    @Persisted var textSpeed: Double?
    
    // MARK: - Text
    @Persisted var fontSize: Double?
    @Persisted var fontName: String?
    @Persisted var textColor: String?
    @Persisted var stroke: Double?
    @Persisted var shadow: Double?
    
    // MARK: - Background
    @Persisted var bgColor: String?
    @Persisted var bgImage: String?
    // Animation scheme
    // frame
    
    
    // Select
    @Persisted var selectedEffectIndexData: Data = (encodeIndexPath(indexPathArr: [[0, 2]]))
    @Persisted var selectedTextIndexData: Data = (encodeIndexPath(indexPathArr: [[0, 1], [2, 2], [1, 1]]))
    @Persisted var selectedBackgroundIndexData: Data = (encodeIndexPath(indexPathArr: [[0, 0]]))
    
    // Selected Data 
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
    
    // Model
    convenience init(
        dateAdded: Date,
        inputText: String,
        textColor: String,
        textSpeed: Double,
        bgColor: String,
        bgImage: String,
        fontName: String,
        fontSize: Double,
        stroke: Double,
        shadow: Double
    ) {
        self.init()
        self.dateAdded = dateAdded
        self.inputText = inputText
        self.textColor = textColor
        self.textSpeed = textSpeed
        self.bgColor = bgColor
        self.bgImage = bgImage
        self.fontName = fontName
        self.fontSize = fontSize
        self.stroke = stroke
        self.shadow = shadow
    }
}



