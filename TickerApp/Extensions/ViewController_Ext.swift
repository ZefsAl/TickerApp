//
//  ViewController_Ext.swift
//  TickerApp
//
//  Created by Serj on 03.10.2023.
//

import Foundation
import UIKit

extension UIViewController {
    
    // MARK: Setting BTN
    func setSettingNavButtonItem(selectorStr: Selector) {
        let buttonView: UIView = {
            
            let v = UIView() // customView: type
            v.translatesAutoresizingMaskIntoConstraints = false
            
            let configImage = UIImage(systemName: "gearshape.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 27, weight: .bold)) // 27~32x32frame
            
            
            let iv = UIImageView(image: configImage)
            iv.translatesAutoresizingMaskIntoConstraints = false
            iv.tintColor = .black
            iv.isUserInteractionEnabled = false
//            iv.contentMode = .scaleAspectFit // не врлияет
            
            v.addSubview(iv)
            v.heightAnchor.constraint(equalToConstant: 32).isActive = true
            v.widthAnchor.constraint(equalToConstant: 32).isActive = true
            
            return v
        }()
        
        let gesture = UITapGestureRecognizer(target: self, action: selectorStr)
        buttonView.addGestureRecognizer(gesture)
        
        // Add Nav Item
        let dismissButtonItem = UIBarButtonItem(customView: buttonView)
        self.navigationItem.rightBarButtonItem = dismissButtonItem
    }
    
    // MARK: Close BTN
    func setCloseButton(color: UIColor, selector: Selector) {
        let buttonView: UIView = {
            
            let v = UIView() // customView: type
            v.translatesAutoresizingMaskIntoConstraints = false
            
            let configImage = UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .bold)) // 25~30x30-frame
            
            let iv = UIImageView(image: configImage)
            iv.translatesAutoresizingMaskIntoConstraints = false
            iv.tintColor = color
            iv.isUserInteractionEnabled = false
//            iv.contentMode = .scaleAspectFit //
            
            v.addSubview(iv)
            v.heightAnchor.constraint(equalToConstant: 30).isActive = true
            v.widthAnchor.constraint(equalToConstant: 30).isActive = true
            
            return v
        }()
        
        let gesture = UITapGestureRecognizer(target: self, action: selector)
        buttonView.addGestureRecognizer(gesture)
        
        // Add Nav Item
        let dismissButtonItem = UIBarButtonItem(customView: buttonView)
        self.navigationItem.rightBarButtonItem = dismissButtonItem
    }
}
