//
//  File.swift
//  TickerApp
//
//  Created by Serj on 07.10.2023.
//

import Foundation
import UIKit

// MARK: - Cell Model

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
    case regularCell(model: RegularCellModel)
}
// Cell
struct RegularCellModel {
    let title: String? 
    let iconSystemName: String?
    let bgColor: UIColor?
    let fontName: String?
    let bgImageName: String?
    let isPremium: Bool
    let handler: (() -> Void)?
    let infoMessage: String?
}
