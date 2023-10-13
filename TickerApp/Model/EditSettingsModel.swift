//
//  File.swift
//  TickerApp
//
//  Created by Serj on 07.10.2023.
//

import Foundation
import UIKit


enum EditSettingsModelType {
    case effect
    case text
    case background
}


struct EditSettingsModel {
    let editSettingsModelType: EditSettingsModelType
    let sections: [EditSettingsSection]
    
}

// Data Model
struct EditSettingsSection {
    let sectionTitle: String?
    let sectionCells: [CellSectionType]
}

enum CellSectionType {
    case regularCell(model: RegularCell)
}

struct RegularCell {
    let title: String? 
    let iconSystemName: String?
    let bgColor: UIColor?
    let fontName: String?
    let handler: (() -> Void)
}
