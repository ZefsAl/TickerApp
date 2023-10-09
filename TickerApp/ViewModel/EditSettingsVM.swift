//
//  EditSettingsVM.swift
//  TickerApp
//
//  Created by Serj on 07.10.2023.
//

import Foundation
import UIKit

struct EditSettingsVM {
    
    var effectSettingsItems: [CellSectionType] = []
    
    mutating private func effectItemsConfig() {
        effectSettingsItems.append(
            CellSectionType.regularCell(model: RegularCell(
                title: "",
                iconSystemName: "square.and.arrow.down.fill",
                iconColor: .systemOrange,
                handler: {}
            )))
    }
    
    
    
    var effectSettings: [EditSettingsModel] = []
    
    init() {
        effectItemsConfig()
        configEffect()
    }
    
    
}

extension EditSettingsVM {
    mutating private func configEffect() {
        
        effectSettings.append(
            EditSettingsModel(
                sectionTitle: "TESTTESTTEST",
                sectionCells: effectSettingsItems)
        )//Append
        
        effectSettings.append(
            EditSettingsModel(
                sectionTitle: "First",
                sectionCells: [
                    CellSectionType.regularCell(model: RegularCell(
                        title: nil, iconSystemName: "sparkles", iconColor: AppColors.primary, handler: {
                            
                        })),
                    CellSectionType.regularCell(model: RegularCell(
                        title: nil, iconSystemName: "sparkles", iconColor: .red, handler: {
                            
                        })),
                    CellSectionType.regularCell(model: RegularCell(
                        title: nil, iconSystemName: "sparkles", iconColor: .blue, handler: {
                            
                        })),
                    CellSectionType.regularCell(model: RegularCell(
                        title: nil, iconSystemName: "sparkles", iconColor: AppColors.primary, handler: {
                            
                        })),
                    CellSectionType.regularCell(model: RegularCell(
                        title: nil, iconSystemName: "sparkles", iconColor: .red, handler: {
                            
                        })),
                    CellSectionType.regularCell(model: RegularCell(
                        title: nil, iconSystemName: "sparkles", iconColor: .blue, handler: {
                            
                        })),
                    CellSectionType.regularCell(model: RegularCell(
                        title: nil, iconSystemName: "sparkles", iconColor: AppColors.primary, handler: {
                            
                        })),
                    CellSectionType.regularCell(model: RegularCell(
                        title: nil, iconSystemName: "sparkles", iconColor: .red, handler: {
                            
                        })),
                    CellSectionType.regularCell(model: RegularCell(
                        title: nil, iconSystemName: "sparkles", iconColor: .blue, handler: {
                            
                        })),
                ])
        )//Append
        
        effectSettings.append(
            EditSettingsModel(
                sectionTitle: "Two",
                sectionCells: [
                    CellSectionType.regularCell(model: RegularCell(
                        title: nil, iconSystemName: "sparkles", iconColor: AppColors.primary, handler: {
                            
                        })),
                    CellSectionType.regularCell(model: RegularCell(
                        title: nil, iconSystemName: "sparkles", iconColor: .red, handler: {
                            
                        })),
                    CellSectionType.regularCell(model: RegularCell(
                        title: nil, iconSystemName: "sparkles", iconColor: .blue, handler: {
                            
                        })),
                ])
        )//Append
        
        
        
        
    }
}
