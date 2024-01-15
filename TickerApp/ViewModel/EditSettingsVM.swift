//
//  EditSettingsVM.swift
//  TickerApp
//
//  Created by Serj on 07.10.2023.
//

import Foundation
import UIKit
import ApphudSDK

class EditSettingsVM {
    
    private var isActiveSubscription = Apphud.hasActiveSubscription()
    private var premiumSetting: Bool = true
    private var freeSetting: Bool = false
    
    var effectSettingsModel: EditSettingsModel = EditSettingsModel(editSettingsModelType: .effect, sections: [])
    var textSettingsModel: EditSettingsModel = EditSettingsModel(editSettingsModelType: .text, sections: [])
    var backgroundSettingsModel: EditSettingsModel = EditSettingsModel(editSettingsModelType: .background, sections: [])
    
    // MARK: - init
    init() {
        checkActiveSubscription()
        configEffectData()
        configTextData()
        configBackgroundData()
    }
    
    private func checkActiveSubscription() {
        // Hide premium badge
        guard
            let premium = UserDefaults.standard.object(forKey: "UserIsPremiumObserverKey") as? Bool
        else { return }
        self.premiumSetting = premium ? false : true
    }
}

extension EditSettingsVM {
    // MARK: - Effect
    private func configEffectData() {
        
        effectSettingsModel = EditSettingsModel(
            editSettingsModelType: .effect,
            sections: [
                
                // General (multi-select)
                EditSettingsSection(
                    sectionTitle: "General",
                    sectionCells: [
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: nil,
                                iconSystemName: "bold",
                                bgColor: nil,
                                fontName: nil,
                                bgImageName: nil,
                                isPremium: freeSetting,
                                handler: nil,
                                infoMessage: "1"
                            )),
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: nil,
                                iconSystemName: "arrow.left.arrow.right",
                                bgColor: nil,
                                fontName: nil,
                                bgImageName: nil,
                                isPremium: freeSetting,
                                handler: nil,
                                infoMessage: "2"
                            )),
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: nil,
                                iconSystemName: "sun.max.fill",
                                bgColor: nil,
                                fontName: nil,
                                bgImageName: nil,
                                isPremium: freeSetting,
                                handler: nil,
                                infoMessage: "3"
                            )),
                    ]),
                
                // MARK: - LED
                EditSettingsSection(
                    sectionTitle: "LED",
                    sectionCells: [
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: "HD",
                                iconSystemName: nil,
                                bgColor: nil,
                                fontName: nil,
                                bgImageName: nil,
                                isPremium: freeSetting,
                                handler: nil,
                                infoMessage: nil
                            )),
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: nil,
                                iconSystemName: "square.fill",
                                bgColor: nil,
                                fontName: nil,
                                bgImageName: nil,
                                isPremium: premiumSetting,
                                handler: nil,
                                infoMessage: "7"
                            )),
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: nil,
                                iconSystemName: "circle.fill",
                                bgColor: nil,
                                fontName: nil,
                                bgImageName: nil,
                                isPremium: premiumSetting,
                                handler: nil,
                                infoMessage: "11"
                            )),
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: nil,
                                iconSystemName: "leaf.fill",
                                bgColor: nil,
                                fontName: nil,
                                bgImageName: nil,
                                isPremium: premiumSetting,
                                handler: nil,
                                infoMessage: "13"
                            )),
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: nil,
                                iconSystemName: "rhombus.fill",
                                bgColor: nil,
                                fontName: nil,
                                bgImageName: nil,
                                isPremium: premiumSetting,
                                handler: nil,
                                infoMessage: "15"
                            )),
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: nil,
                                iconSystemName: "heart.fill",
                                bgColor: nil,
                                fontName: nil,
                                bgImageName: nil,
                                isPremium: premiumSetting,
                                handler: nil,
                                infoMessage: "16"
                            )),
                    ]),
                // MARK: - Pixel
                EditSettingsSection(
                    sectionTitle: "Pixel",
                    sectionCells: [
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: "1",
                                iconSystemName: nil,
                                bgColor: nil,
                                fontName: nil,
                                bgImageName: nil,
                                isPremium: premiumSetting,
                                handler: nil,
                                infoMessage: nil
                            )),
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: "2",
                                iconSystemName: nil,
                                bgColor: nil,
                                fontName: nil,
                                bgImageName: nil,
                                isPremium: premiumSetting,
                                handler: nil,
                                infoMessage: nil
                            )),
                    ]),
                
                // MARK: - Sparkle
                EditSettingsSection(
                    sectionTitle: "Sparkle",
                    sectionCells: [
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: "0",
                                iconSystemName: nil,
                                bgColor: nil,
                                fontName: nil,
                                bgImageName: nil,
                                isPremium: freeSetting,
                                handler: nil,
                                infoMessage: "0"
                            )),
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: "0.5",
                                iconSystemName: nil,
                                bgColor: nil,
                                fontName: nil,
                                bgImageName: nil,
                                isPremium: premiumSetting,
                                handler: nil,
                                infoMessage: "1.2"
                            )),
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: "1.0",
                                iconSystemName: nil,
                                bgColor: nil,
                                fontName: nil,
                                bgImageName: nil,
                                isPremium: premiumSetting,
                                handler: nil,
                                infoMessage: "0.8"
                            )),
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: "1.5",
                                iconSystemName: nil,
                                bgColor: nil,
                                fontName: nil,
                                bgImageName: nil,
                                isPremium: premiumSetting,
                                handler: nil,
                                infoMessage: "0.5"
                            )),
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: "2",
                                iconSystemName: nil,
                                bgColor: nil,
                                fontName: nil,
                                bgImageName: nil,
                                isPremium: premiumSetting,
                                handler: nil,
                                infoMessage: "0.2"
                            )),
                    ]),
                
                // MARK: - Scroll Speed
                EditSettingsSection(
                    sectionTitle: "Scroll Speed",
                    sectionCells: [
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: "0",
                                iconSystemName: nil,
                                bgColor: nil,
                                fontName: nil,
                                bgImageName: nil,
                                isPremium: freeSetting,
                                handler: nil,
                                infoMessage: nil
                            )),
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: "0.5",
                                iconSystemName: nil,
                                bgColor: nil,
                                fontName: nil,
                                bgImageName: nil,
                                isPremium: freeSetting,
                                handler: nil,
                                infoMessage: nil
                            )),
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: "1.0",
                                iconSystemName: nil,
                                bgColor: nil,
                                fontName: nil,
                                bgImageName: nil,
                                isPremium: freeSetting,
                                handler: nil,
                                infoMessage: nil
                            )),
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: "1.5",
                                iconSystemName: nil,
                                bgColor: nil,
                                fontName: nil,
                                bgImageName: nil,
                                isPremium: freeSetting,
                                handler: nil,
                                infoMessage: nil
                            )),
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: "2",
                                iconSystemName: nil,
                                bgColor: nil,
                                fontName: nil,
                                bgImageName: nil,
                                isPremium: freeSetting,
                                handler: nil,
                                infoMessage: nil
                            )),
                    ])
            ])
    }
    
    // MARK: - Text
    private func configTextData() {
        textSettingsModel = EditSettingsModel(
            editSettingsModelType: .text,
            sections: [
                // MARK: - Size
                EditSettingsSection(
                    sectionTitle: "Size",
                    sectionCells: [
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: "50",
                                iconSystemName: nil,
                                bgColor: nil,
                                fontName: nil,
                                bgImageName: nil,
                                isPremium: freeSetting,
                                handler: nil,
                                infoMessage: nil
                            )),
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: "75",
                                iconSystemName: nil,
                                bgColor: nil,
                                fontName: nil,
                                bgImageName: nil,
                                isPremium: freeSetting,
                                handler: nil,
                                infoMessage: nil
                            )),
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: "100",
                                iconSystemName: nil,
                                bgColor: nil,
                                fontName: nil,
                                bgImageName: nil,
                                isPremium: freeSetting,
                                handler: nil,
                                infoMessage: nil
                            )),
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: "125",
                                iconSystemName: nil,
                                bgColor: nil,
                                fontName: nil,
                                bgImageName: nil,
                                isPremium: freeSetting,
                                handler: nil,
                                infoMessage: nil
                            )),
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: "150",
                                iconSystemName: nil,
                                bgColor: nil,
                                fontName: nil,
                                bgImageName: nil,
                                isPremium: freeSetting,
                                handler: nil,
                                infoMessage: nil
                            )),
                    ]),
                // MARK: - Fonts
                EditSettingsSection(
                    sectionTitle: "Fonts",
                    sectionCells: [
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: "Aa",
                                iconSystemName: nil,
                                bgColor: nil,
                                fontName: "Oswald-Regular",
                                bgImageName: nil,
                                isPremium: freeSetting,
                                handler: nil,
                                infoMessage: nil
                            )),
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: "Aa",
                                iconSystemName: nil,
                                bgColor: nil,
                                fontName: "pixhobo",
                                bgImageName: nil,
                                isPremium: freeSetting,
                                handler: nil,
                                infoMessage: nil
                            )),
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: "Aa",
                                iconSystemName: nil,
                                bgColor: nil,
                                fontName: "Marske",
                                bgImageName: nil,
                                isPremium: freeSetting,
                                handler: nil,
                                infoMessage: nil
                            )),
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: "Aa",
                                iconSystemName: nil,
                                bgColor: nil,
                                fontName: "LEPKA", 
                                bgImageName: nil,
                                isPremium: premiumSetting,
                                handler: nil,
                                infoMessage: nil
                            )),
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: "Aa",
                                iconSystemName: nil,
                                bgColor: nil,
                                fontName: "Baymax",
                                bgImageName: nil,
                                isPremium: premiumSetting,
                                handler: nil,
                                infoMessage: nil
                            )),
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: "Aa",
                                iconSystemName: nil,
                                bgColor: nil,
                                fontName: "Blackcraft",
                                bgImageName: nil,
                                isPremium: premiumSetting,
                                handler: nil,
                                infoMessage: nil
                            )),
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: "Aa",
                                iconSystemName: nil,
                                bgColor: nil,
                                fontName: "PixelifySans-Regular",
                                bgImageName: nil,
                                isPremium: premiumSetting,
                                handler: nil,
                                infoMessage: nil
                            )),
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: "Aa",
                                iconSystemName: nil,
                                bgColor: nil,
                                fontName: "PermanentMarker-Regular",
                                bgImageName: nil,
                                isPremium: premiumSetting,
                                handler: nil,
                                infoMessage: nil
                            )),
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: "Aa",
                                iconSystemName: nil,
                                bgColor: nil,
                                fontName: "Bangers-Regular",
                                bgImageName: nil,
                                isPremium: premiumSetting,
                                handler: nil,
                                infoMessage: nil
                            )),
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: "Aa",
                                iconSystemName: nil,
                                bgColor: nil,
                                fontName: "RampartOne-Regular",
                                bgImageName: nil,
                                isPremium: premiumSetting,
                                handler: nil,
                                infoMessage: nil
                            )),
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: "Aa",
                                iconSystemName: nil,
                                bgColor: nil,
                                fontName: "RubikWetPaint-Regular",
                                bgImageName: nil,
                                isPremium: premiumSetting,
                                handler: nil,
                                infoMessage: nil
                            )),
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: "Aa",
                                iconSystemName: nil,
                                bgColor: nil,
                                fontName: "TrainOne-Regular",
                                bgImageName: nil,
                                isPremium: premiumSetting,
                                handler: nil,
                                infoMessage: nil
                            )),
                    ]),
                // MARK: - Color
                EditSettingsSection(
                    sectionTitle: "Color",
                    sectionCells: [
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: nil,
                                iconSystemName: nil,
                                bgColor: AppColors.primary,
                                fontName: nil,
                                bgImageName: nil,
                                isPremium: freeSetting,
                                handler: nil,
                                infoMessage: nil
                            )),
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: nil,
                                iconSystemName: nil,
                                bgColor: .black,
                                fontName: nil,
                                bgImageName: nil,
                                isPremium: freeSetting,
                                handler: nil,
                                infoMessage: nil
                            )),
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: nil,
                                iconSystemName: nil,
                                bgColor: .white,
                                fontName: nil,
                                bgImageName: nil,
                                isPremium: freeSetting,
                                handler: nil,
                                infoMessage: nil
                            )),
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: nil,
                                iconSystemName: nil,
                                bgColor: .systemRed,
                                fontName: nil,
                                bgImageName: nil,
                                isPremium: freeSetting,
                                handler: nil,
                                infoMessage: nil
                            )),
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: nil,
                                iconSystemName: nil,
                                bgColor: .systemOrange,
                                fontName: nil,
                                bgImageName: nil,
                                isPremium: freeSetting,
                                handler: nil,
                                infoMessage: nil
                            )),
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: nil,
                                iconSystemName: nil,
                                bgColor: .systemBlue,
                                fontName: nil,
                                bgImageName: nil,
                                isPremium: freeSetting,
                                handler: nil,
                                infoMessage: nil
                            )),
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: nil,
                                iconSystemName: nil,
                                bgColor: .magenta,
                                fontName: nil,
                                bgImageName: nil,
                                isPremium: freeSetting,
                                handler: nil,
                                infoMessage: nil
                            )),
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: nil,
                                iconSystemName: nil,
                                bgColor: .cyan,
                                fontName: nil,
                                bgImageName: nil,
                                isPremium: freeSetting,
                                handler: nil,
                                infoMessage: nil
                            )),
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: nil,
                                iconSystemName: nil,
                                bgColor: .systemPink,
                                fontName: nil,
                                bgImageName: nil,
                                isPremium: freeSetting,
                                handler: nil,
                                infoMessage: nil
                            )),
                    ]),
                // MARK: - Stroke
                EditSettingsSection(
                    sectionTitle: "Stroke",
                    sectionCells: [
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: "0",
                                iconSystemName: nil,
                                bgColor: nil,
                                fontName: nil,
                                bgImageName: nil,
                                isPremium: freeSetting,
                                handler: nil,
                                infoMessage: nil
                            )),
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: "2",
                                iconSystemName: nil,
                                bgColor: nil,
                                fontName: nil,
                                bgImageName: nil,
                                isPremium: premiumSetting,
                                handler: nil,
                                infoMessage: "2"
                            )),
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: "5",
                                iconSystemName: nil,
                                bgColor: nil,
                                fontName: nil,
                                bgImageName: nil,
                                isPremium: premiumSetting,
                                handler: nil,
                                infoMessage: "5"
                            )),
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: "10",
                                iconSystemName: nil,
                                bgColor: nil,
                                fontName: nil,
                                bgImageName: nil,
                                isPremium: premiumSetting,
                                handler: nil,
                                infoMessage: "10"
                            )),
                    ]),
                // MARK: - Shadow
                EditSettingsSection(
                    sectionTitle: "Shadow",
                    sectionCells: [
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: "0",
                                iconSystemName: nil,
                                bgColor: nil,
                                fontName: nil,
                                bgImageName: nil,
                                isPremium: freeSetting,
                                handler: nil,
                                infoMessage: nil
                            )),
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: "2",
                                iconSystemName: nil,
                                bgColor: nil,
                                fontName: nil,
                                bgImageName: nil,
                                isPremium: premiumSetting,
                                handler: nil,
                                infoMessage: "2"
                            )),
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: "5",
                                iconSystemName: nil,
                                bgColor: nil,
                                fontName: nil,
                                bgImageName: nil,
                                isPremium: premiumSetting,
                                handler: nil,
                                infoMessage: "5"
                            )),
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: "10",
                                iconSystemName: nil,
                                bgColor: nil,
                                fontName: nil,
                                bgImageName: nil,
                                isPremium: premiumSetting,
                                handler: nil,
                                infoMessage: "10"
                            )),
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: "15",
                                iconSystemName: nil,
                                bgColor: nil,
                                fontName: nil,
                                bgImageName: nil,
                                isPremium: premiumSetting,
                                handler: nil,
                                infoMessage: "15"
                            )),
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: "20",
                                iconSystemName: nil,
                                bgColor: nil,
                                fontName: nil,
                                bgImageName: nil,
                                isPremium: premiumSetting,
                                handler: nil,
                                infoMessage: "20"
                            )),
                    ]),
            ])
    }
    
    // MARK: - Background
    private func configBackgroundData() {
        backgroundSettingsModel = EditSettingsModel(
            editSettingsModelType: .background,
            sections: [
                // MARK: - Color
                EditSettingsSection(
                    sectionTitle: "Color",
                    sectionCells: [
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: nil,
                                iconSystemName: nil,
                                bgColor: .black,
                                fontName: nil,
                                bgImageName: nil,
                                isPremium: freeSetting,
                                handler: nil,
                                infoMessage: nil
                            )),
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: nil,
                                iconSystemName: nil,
                                bgColor: .white,
                                fontName: nil,
                                bgImageName: nil,
                                isPremium: freeSetting,
                                handler: nil,
                                infoMessage: nil
                            )),
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: nil,
                                iconSystemName: nil,
                                bgColor: .systemRed,
                                fontName: nil,
                                bgImageName: nil,
                                isPremium: freeSetting,
                                handler: nil,
                                infoMessage: nil
                            )),
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: nil,
                                iconSystemName: nil,
                                bgColor: .systemOrange,
                                fontName: nil,
                                bgImageName: nil,
                                isPremium: freeSetting,
                                handler: nil,
                                infoMessage: nil
                            )),
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: nil,
                                iconSystemName: nil,
                                bgColor: .systemBlue,
                                fontName: nil,
                                bgImageName: nil,
                                isPremium: freeSetting,
                                handler: nil,
                                infoMessage: nil
                            )),
                    ]),
                // MARK: - Image
                EditSettingsSection(
                    sectionTitle: "Image",
                    sectionCells: [
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: nil,
                                iconSystemName: "circle.slash.fill",
                                bgColor: nil,
                                fontName: nil,
                                bgImageName: "Empty",
                                isPremium: freeSetting,
                                handler: nil,
                                infoMessage: nil
                            )),
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: nil,
                                iconSystemName: nil,
                                bgColor: nil,
                                fontName: nil,
                                bgImageName: "background1.jpg",
                                isPremium: premiumSetting,
                                handler: nil,
                                infoMessage: nil
                            )),
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: nil,
                                iconSystemName: nil,
                                bgColor: nil,
                                fontName: nil,
                                bgImageName: "background2.jpg",
                                isPremium: premiumSetting,
                                handler: nil,
                                infoMessage: nil
                            )),
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: nil,
                                iconSystemName: nil,
                                bgColor: nil,
                                fontName: nil,
                                bgImageName: "background3.jpg",
                                isPremium: premiumSetting,
                                handler: nil,
                                infoMessage: nil
                            )),
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: nil,
                                iconSystemName: nil,
                                bgColor: nil,
                                fontName: nil,
                                bgImageName: "background4.jpg",
                                isPremium: premiumSetting,
                                handler: nil,
                                infoMessage: nil
                            )),
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: nil,
                                iconSystemName: nil,
                                bgColor: nil,
                                fontName: nil,
                                bgImageName: "background5.jpg",
                                isPremium: premiumSetting,
                                handler: nil,
                                infoMessage: nil
                            )),
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: nil,
                                iconSystemName: nil,
                                bgColor: nil,
                                fontName: nil,
                                bgImageName: "background6.jpg",
                                isPremium: premiumSetting,
                                handler: nil,
                                infoMessage: nil
                            )),
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: nil,
                                iconSystemName: nil,
                                bgColor: nil,
                                fontName: nil,
                                bgImageName: "background7.jpg",
                                isPremium: premiumSetting,
                                handler: nil,
                                infoMessage: nil
                            )),
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: nil,
                                iconSystemName: nil,
                                bgColor: nil,
                                fontName: nil,
                                bgImageName: "background8.jpg",
                                isPremium: premiumSetting,
                                handler: nil,
                                infoMessage: nil
                            )),
                        CellSectionType.regularCell(
                            model: RegularCellModel(
                                title: nil,
                                iconSystemName: nil,
                                bgColor: nil,
                                fontName: nil,
                                bgImageName: "background9.jpg",
                                isPremium: premiumSetting,
                                handler: nil,
                                infoMessage: nil
                            )),
                    ])
            ])
    }
}
