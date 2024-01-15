//
//  AppSettingsModel.swift
//  TickerApp
//
//  Created by Serj on 22.10.2023.
//

import Foundation
import UIKit

struct AppSettingsSection {
    let sectionTitle: String?
    let sectionCells: [CellSectionType]
}

enum AppSettingsCellType {
    case appSettingsCell(model: AppSettingsCell)
}

struct AppSettingsCell {
    let title: String
    let iconSystemName: String
    let handler: (() -> Void)
}
