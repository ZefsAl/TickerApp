//
//  File.swift
//  TickerApp
//
//  Created by Serj on 07.10.2023.
//

import Foundation
import UIKit

// Data Model
struct EditSettingsModel {
    let sectionTitle: String?
    let sectionCells: [CellSectionType]
}

enum CellSectionType {
    case regularCell(model: RegularCell)
}

struct RegularCell {
    let title: String?
    let iconSystemName: String?
    let iconColor: UIColor?
    let handler: (() -> Void)
}
