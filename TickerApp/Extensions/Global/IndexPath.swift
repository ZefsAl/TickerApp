//
//  Convert IndexPath.swift
//  TickerApp
//
//  Created by Serj on 18.10.2023.
//

import Foundation


func findSelectedIndexPath(editSettingsCV: EditSettingsCV, type: EditSettingsModelType, sectionTitle: String) -> IndexPath? {
    
    switch type {
    case .effect:
        let result = editSettingsCV.selectedEffectIndexPath.first { selectedIndexPath in
            let section = editSettingsCV.editSettingsModel.sections[selectedIndexPath.section]
            return section.sectionTitle == sectionTitle
        }
        print("Find \(sectionTitle) 🟣", result as Any)
        return result
    case .text:
        let result = editSettingsCV.selectedTextIndexPath.first { selectedIndexPath in
            let section = editSettingsCV.editSettingsModel.sections[selectedIndexPath.section]
            return section.sectionTitle == sectionTitle
        }
        print("Find \(sectionTitle) 🟣", result as Any)
        return result
    case .background:
        let result = editSettingsCV.selectedBackgroundIndexPath.first { selectedIndexPath in
            let section = editSettingsCV.editSettingsModel.sections[selectedIndexPath.section]
            return section.sectionTitle == sectionTitle
        }
        print("Find \(sectionTitle) 🟣", result as Any)
        return result
    }
}

/// Found  - IndexPath? in editSettingsCV by sectionTitle.
/// Проверить наличие Select в секци внутри других коллекций
func findSelectedIndexPath_v2(editSettingsCV: EditSettingsCV, type: EditSettingsModelType, sectionTitle: String) -> IndexPath? {
    
    switch type {
    case .effect:
        let result = editSettingsCV.indexPathsForSelectedItems?.first { selectedIndexPath in
            let section = editSettingsCV.editSettingsModel.sections[selectedIndexPath.section]
            return section.sectionTitle == sectionTitle
        }
        print("Find \(sectionTitle) 🟣", result as Any)
        return result
    case .text:
        let result = editSettingsCV.indexPathsForSelectedItems?.first { selectedIndexPath in
            let section = editSettingsCV.editSettingsModel.sections[selectedIndexPath.section]
            return section.sectionTitle == sectionTitle
        }
        print("Find \(sectionTitle) 🟣", result as Any)
        return result
    case .background:
        let result = editSettingsCV.indexPathsForSelectedItems?.first { selectedIndexPath in
            let section = editSettingsCV.editSettingsModel.sections[selectedIndexPath.section]
            return section.sectionTitle == sectionTitle
        }
        print("Find \(sectionTitle) 🟣", result as Any)
        return result
    }
}

//
//func findSpecificCellIndexPath(editSettingsCV: EditSettingsCV, type: EditSettingsModelType, sectionTitle: String) -> IndexPath? {
//
//    switch type {
//    case .effect:
//        let result = editSettingsCV.indexPathsForSelectedItems?.first { selectedIndexPath in
//            let section = editSettingsCV.editSettingsModel.sections[selectedIndexPath.section]
//            let row = section.sectionCells.first { cellSectionType in
//                switch cellSectionType {
//                case .regularCell(model: let model):
//                    return model.
//                }
//            }
////            return section.sectionTitle == sectionTitle
//        }
//        print("Find \(sectionTitle) 🟣", result as Any)
//        return result
//    case .text:
//        let result = editSettingsCV.indexPathsForSelectedItems?.first { selectedIndexPath in
//            let section = editSettingsCV.editSettingsModel.sections[selectedIndexPath.section]
//            return section.sectionTitle == sectionTitle
//        }
//        print("Find \(sectionTitle) 🟣", result as Any)
//        return result
//    case .background:
//        let result = editSettingsCV.indexPathsForSelectedItems?.first { selectedIndexPath in
//            let section = editSettingsCV.editSettingsModel.sections[selectedIndexPath.section]
//            return section.sectionTitle == sectionTitle
//        }
//        print("Find \(sectionTitle) 🟣", result as Any)
//        return result
//    }
//}

public func encodeIndexPath(indexPathArr: [IndexPath] ) -> Data {
    let indexPathData = try? NSKeyedArchiver.archivedData(withRootObject: indexPathArr, requiringSecureCoding: false)
    let data = indexPathData?.base64EncodedData()
    return data ?? Data()
}

public func decodeIndexPath(indexPathData: Data) -> [IndexPath] {
    guard let data = Data(base64Encoded: indexPathData) else { return [] }
    let indexPathArr = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [IndexPath]
    guard let indexPathArr else { return [] }
    return indexPathArr
}
