//
//  NAVCloseButtonView.swift
//  TickerApp
//
//  Created by Serj on 19.10.2023.
//

import Foundation
import UIKit

final class NAVCloseButtonView: UIView {
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let configImage = UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .bold)) // 25~30x30-frame
        
        let iv = UIImageView(image: configImage)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.tintColor = .black
        iv.isUserInteractionEnabled = false
        
        self.addSubview(iv)
        self.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setToNav(rootVC: UIViewController, selectorStr: Selector) {
        let gesture = UITapGestureRecognizer(target: self, action: selectorStr)
        self.addGestureRecognizer(gesture)

        // Add Nav Item
        let dismissButtonItem = UIBarButtonItem(customView: self)
        rootVC.navigationItem.rightBarButtonItem = dismissButtonItem
    }
        
        
    
}
    
    
