//
//  File.swift
//  TickerApp
//
//  Created by Serj on 07.10.2023.
//

import Foundation
import UIKit

// Cell Model

// Type
enum EditSettingsModelType {
    case effect
    case text
    case background
}
// Sections
struct EditSettingsModel {
    let editSettingsModelType: EditSettingsModelType
    let sections: [EditSettingsSection]
    
}
// Section
struct EditSettingsSection {
    let sectionTitle: String?
    let sectionCells: [CellSectionType]
}
// Cell Type
enum CellSectionType {
    case regularCell(model: RegularCell)
}
// Cell
struct RegularCell {
    let title: String? 
    let iconSystemName: String?
    let bgColor: UIColor?
    let fontName: String?
    let handler: (() -> Void)
}
