//
//  EditSettingsVM.swift
//  TickerApp
//
//  Created by Serj on 07.10.2023.
//

import Foundation
import UIKit

struct EditSettingsVM {
    
    var effectSettingsModel: EditSettingsModel = EditSettingsModel(editSettingsModelType: .effect, sections: [])
    var textSettingsModel: EditSettingsModel = EditSettingsModel(editSettingsModelType: .text, sections: [])
    var backgroundSettingsModel: EditSettingsModel = EditSettingsModel(editSettingsModelType: .background, sections: [])
    
    init() {
        configEffectData()
        configTextData()
        configBackgroundData()
    }
    
    
}

extension EditSettingsVM {
    // MARK: - Effect
    mutating private func configEffectData() {
        
        effectSettingsModel = EditSettingsModel(
            editSettingsModelType: .effect,
            sections: [
                EditSettingsSection(
                    sectionTitle: "Scroll Speed",
                    sectionCells: [
                        CellSectionType.regularCell(
                            model: RegularCell(
                                title: "0",
                                iconSystemName: nil,
                                bgColor: nil,
                                fontName: nil,
                                handler: {}
                            )),
                        CellSectionType.regularCell(
                            model: RegularCell(
                                title: "0.5",
                                iconSystemName: nil,
                                bgColor: nil,
                                fontName: nil,
                                handler: {}
                            )),
                        CellSectionType.regularCell(
                            model: RegularCell(
                                title: "1.0",
                                iconSystemName: nil,
                                bgColor: nil,
                                fontName: nil,
                                handler: {}
                            )),
                        CellSectionType.regularCell(
                            model: RegularCell(
                                title: "1.5",
                                iconSystemName: nil,
                                bgColor: nil,
                                fontName: nil,
                                handler: {}
                            )),
                        CellSectionType.regularCell(
                            model: RegularCell(
                                title: "2",
                                iconSystemName: nil,
                                bgColor: nil,
                                fontName: nil,
                                handler: {}
                            )),
                    ])
            ])
    }
    
    // MARK: - Text
    mutating func configTextData() {
        
        textSettingsModel = EditSettingsModel(
            editSettingsModelType: .text,
            sections: [
                EditSettingsSection(
                    sectionTitle: "Size",
                    sectionCells: [
                        CellSectionType.regularCell(
                            model: RegularCell(
                                title: "50",
                                iconSystemName: nil,
                                bgColor: nil,
                                fontName: nil,
                                handler: {}
                            )),
                        CellSectionType.regularCell(
                            model: RegularCell(
                                title: "150",
                                iconSystemName: nil,
                                bgColor: nil,
                                fontName: nil,
                                handler: {}
                            )),
                        CellSectionType.regularCell(
                            model: RegularCell(
                                title: "250",
                                iconSystemName: nil,
                                bgColor: nil,
                                fontName: nil,
                                handler: {}
                            )),
                    ]),
                EditSettingsSection(
                sectionTitle: "Fonts",
                sectionCells: [
//                    CellSectionType.fontCell(
//                        model: FontCellModel(
//                            title: "Aa",
//                            bgColor: nil,
//                            fontName: "PermanentMarker-Regular"
//                        )),
                    CellSectionType.regularCell(
                        model: RegularCell(
                            title: "Aa",
                            iconSystemName: nil,
                            bgColor: nil,
                            fontName: "PermanentMarker-Regular",
                            handler: {}
                        )),
                    CellSectionType.regularCell(
                        model: RegularCell(
                            title: "Aa",
                            iconSystemName: nil,
                            bgColor: nil,
                            fontName: "Bangers-Regular",
                            handler: {}
                        )),
                ]),
                EditSettingsSection(
                    sectionTitle: "Color",
                    sectionCells: [
                        CellSectionType.regularCell(
                            model: RegularCell(
                                title: nil,
                                iconSystemName: nil,
                                bgColor: AppColors.primary,
                                fontName: nil,
                                handler: {}
                            )),
                        CellSectionType.regularCell(
                            model: RegularCell(
                                title: nil,
                                iconSystemName: nil,
                                bgColor: .black,
                                fontName: nil,
                                handler: {}
                            )),
                        CellSectionType.regularCell(
                            model: RegularCell(
                                title: nil,
                                iconSystemName: nil,
                                bgColor: .white,
                                fontName: nil,
                                handler: {}
                            )),
                        
                    ]),
                
            ])
            
    }
    
    // MARK: - Background
    mutating func configBackgroundData() {
        backgroundSettingsModel = EditSettingsModel(
            editSettingsModelType: .background,
            sections: [
                EditSettingsSection(
                    sectionTitle: "Color",
                    sectionCells: [
                        CellSectionType.regularCell(
                            model: RegularCell(
                                title: nil,
                                iconSystemName: nil,
                                bgColor: .black,
                                fontName: nil,
                                handler: {}
                            )),
                        CellSectionType.regularCell(
                            model: RegularCell(
                                title: nil,
                                iconSystemName: nil,
                                bgColor: .white,
                                fontName: nil,
                                handler: {}
                            )),
                        CellSectionType.regularCell(
                            model: RegularCell(
                                title: nil,
                                iconSystemName: nil,
                                bgColor: .red,
                                fontName: nil,
                                handler: {}
                            )),
                    ])
            ])
    }
}
