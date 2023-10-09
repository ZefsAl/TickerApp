//
//  DocumentButton.swift
//  TickerApp
//
//  Created by Serj on 08.10.2023.
//

import UIKit

class DocumentButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        
        self.translatesAutoresizingMaskIntoConstraints = false
//        self.setTitle("Terms Of Use", for: .normal)
//        self.titleLabel?.font = UIFont(weight: .regular, size: 13)
        self.titleLabel?.font = SFProRounded.set(fontSize: 13, weight: .regular)
        self.setTitleColor(UIColor.white, for: .normal)
    }
    
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
