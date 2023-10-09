//
//  CustomNav.swift
//  TickerApp
//
//  Created by Serj on 03.10.2023.
//

import UIKit

final class CustomNav: UINavigationController {
    
    // MARK: title
    private let appNameTitle: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "LED Ultra"
        l.font = SFProRounded.set(fontSize: 24, weight: .heavy)
        l.textColor = .black
        return l
    }()
    
    // MARK: - view Did Load 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBarStyle()
    }
    
    // MARK: - navigation Bar Style
    private func navigationBarStyle() {
        
        // Subview
        self.navigationBar.addSubview(appNameTitle)
        
        // Style
        self.navigationBar.isTranslucent = false
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = #colorLiteral(red: 0.1882352941, green: 0.8588235294, blue: 0.3568627451, alpha: 1)
        self.navigationBar.standardAppearance = appearance
        self.navigationBar.scrollEdgeAppearance = appearance
        
        // Cnstraint
        NSLayoutConstraint.activate([
            appNameTitle.centerYAnchor.constraint(equalTo: self.navigationBar.centerYAnchor),
            appNameTitle.leadingAnchor.constraint(equalTo: self.navigationBar.leadingAnchor, constant: 16),
        ])
    }
    
    // MARK: - Action
    @objc private func settingsAct() {
        print("settingsAct")
    }
    
}
