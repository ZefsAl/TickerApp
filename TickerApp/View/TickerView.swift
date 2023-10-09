//
//  TickerView.swift
//  TickerApp
//
//  Created by Serj on 30.09.2023.
//

import UIKit
import MarqueeLabel

final class TickerView: UIView {

    
//    var lengthyLabel = MarqueeLabel.init(frame: CGRect(x: 0, y: 0, width: 200, height: 200), duration: 8.0, fadeLength: 10.0)
    
//    var someLable: UILabel = {
//        let l = UILabel()
//        l.translatesAutoresizingMaskIntoConstraints = false
//        l.text = "Test text "
//        return l
//    }()
    
    private var someLable: MarqueeLabel = {
//        let l = MarqueeLabel.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0), duration: 8.0, fadeLength: 10.0)
        let l = MarqueeLabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        
        l.text = "Test Test Test Test Test Test"
        l.textColor = .white
        l.backgroundColor = .red
        l.forceScrolling = true
        l.font = UIFont.systemFont(ofSize: 22)
//        l.scrollDuration = 1000
        l.fadeLength = 10.0
        l.speed = .rate(100.0)
//        l.speed = .duration(10.0)
        l.type = .continuous
        l.animationDelay = 0.0
//        l.contentMode = .
//        sublabel.layer.speed
//        l.scrollDuration
        
//        l.speed = .
        
        
        
        return l
    }()
    
    
//    init(someLable: MarqueeLabel) {
//        self.someLable = someLable
//    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        viewStyle()
//        self.backgroundColor = .orange
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func viewStyle() {
        // Border
        self.layer.cornerRadius = 26
        self.layer.borderWidth = 3
        self.layer.borderColor = AppColors.gray6.cgColor
    }
    
    private func setupUI() {
        
        // Adding
//        self.view.addSubview(someLable)
        
//        someLable.tapToScroll = true
//        someLable.type = .continuous
//        someLable.triggerScrollStart()
        // Constraints
        NSLayoutConstraint.activate([
//            someLable.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
//            someLable.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
//            someLable.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
//            someLable.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
//            someLable.widthAnchor.constraint(equalTo: someLable.widthAnchor),
        ])
    }


}

