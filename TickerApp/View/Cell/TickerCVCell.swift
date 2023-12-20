//
//  TickerCVCell.swift
//  TickerApp
//
//  Created by Serj on 05.10.2023.
//

import UIKit

final class TickerCVCell: UICollectionViewCell {
    
    static var reuseID: String {
        String(describing: self)
    }
    
    // MARK: - tickerView
    let tickerView = TickerView()
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: - Configure
    func configure(tickerDataModel: TickerDataModel) {        
        tickerView.configureTicker(tickerDataModel: tickerDataModel, frameBuffer: self.frame.size.width)
    }
    
    // MARK: - Set up Stack
    private func setupUI() {
        
        self.addSubview(tickerView)
        
        NSLayoutConstraint.activate([
            tickerView.topAnchor.constraint(equalTo: self.topAnchor),
            tickerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tickerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tickerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
}

