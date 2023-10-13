//
//  TickerView.swift
//  TickerApp
//
//  Created by Serj on 30.09.2023.
//

import UIKit
import MarqueeLabel

final class TickerView: UIView {

    
    private static var currentFontSize: CGFloat = 80.0
    
    
    // MARK: - ticker Lable
    private var tickerLable: MarqueeLabel = {
//        let l = MarqueeLabel.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0), duration: 8.0, fadeLength: 10.0)
        let l = MarqueeLabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        
        
//        l.clipsToBounds = false
        l.adjustsFontSizeToFitWidth = true
        
        l.text = "English"
//        l.text = "Русский"
//        l.textColor = .white
        l.textColor = AppColors.primary
//        l.backgroundColor = .red
        l.forceScrolling = true
        
        
        l.font = SFProRounded.set(fontSize: currentFontSize, weight: .heavy)
        // work
        
//        l.font = UIFont.init(name: "PermanentMarker-Regular", size: 150)
//        l.font = UIFont.init(name: "Bangers-Regular", size: 75)
//        l.font = UIFont.init(name: "PressStart2P-Regular", size: 150)
//        l.font = UIFont.init(name: "LibreBarcode39-Regular", size: 150)
        
        

        l.speed = .rate(100.0)
        l.type = .continuous
        l.animationDelay = 0.0
        
        l.animationCurve = .linear // text
        l.fadeLength = 0
        l.leadingBuffer = 400
        l.trailingBuffer = 200
        
        return l
    }()
    
    // Convert Speed
    private func textSpeed(speedStr: String?) -> CGFloat {
        guard
            let speedStr = speedStr,
            let double = Double(speedStr)
        else { return CGFloat(100.0)}
        
        switch double {
        case 0:
            isLabelize(bool: true)
            return 0.0;
        case 0.5:
            isLabelize(bool: false)
            return 50.0;
        case 1:
            isLabelize(bool: false)
            return 100.0;
        case 1.5:
            isLabelize(bool: false)
            return 150.0;
        case 2:
            isLabelize(bool: false)
            return 200.0;
        default:
            isLabelize(bool: false)
            return 100.0;
        }
    }
    
    // Buffer нужно указывать в зависимости view width
    private func isLabelize(bool: Bool) {
        if bool {
            tickerLable.leadingBuffer = 0
            tickerLable.trailingBuffer = 0
            tickerLable.labelize = true
            tickerLable.textAlignment = .center
        } else {
            tickerLable.leadingBuffer = 400
            tickerLable.trailingBuffer = 200
            tickerLable.labelize = false
            tickerLable.textAlignment = .left
        }
    }
    
    
    private func stringToCGFloat(stringSize: String?) -> CGFloat {
        guard
            let stringSize = stringSize,
            let double = Double(stringSize)
        else { return TickerView.currentFontSize}
        
        switch double {
        case 50:
            return 50.0;
        case 80:
            return 80.0;
        case 100:
            return 100.0;
        case 150:
            return 150.0;
        default:
            return 80.0;
        }
    }
    
    
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        viewStyle()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - view Style
    private func viewStyle() {
        // Border
        self.layer.cornerRadius = 26
        self.layer.borderWidth = 3
        self.layer.borderColor = AppColors.gray6.cgColor
        self.clipsToBounds = true
    }
    
    // MARK: - Config Ticker
    func setInputText(text: String) {
        tickerLable.text = text
        tickerLable.restartLabel()
    }
    func setText(textColor: UIColor?) {
        tickerLable.textColor = textColor
        tickerLable.restartLabel()
    }
    func setEffect(speedStr: String?) {
        tickerLable.speed = .rate(textSpeed(speedStr: speedStr))
    }
    func setBackground(background: UIColor?) {
        self.backgroundColor = background
    }
    func configTickerLayout(width: CGFloat) {
        tickerLable.leadingBuffer = width
        tickerLable.trailingBuffer = width/2
    }
    func setFontSize(stringSize: String?) {
        tickerLable.font = tickerLable.font.withSize(stringToCGFloat(stringSize: stringSize))
        TickerView.currentFontSize = stringToCGFloat(stringSize: stringSize)
    }
    func setFont(fontName: String) {
        tickerLable.font = UIFont(name: fontName, size: TickerView.currentFontSize)
    }
    
    
    
    
    
    private func setupUI() {
        // Adding
        self.addSubview(tickerLable)
        
        // Constraints
        NSLayoutConstraint.activate([
            tickerLable.topAnchor.constraint(equalTo: self.topAnchor),
            tickerLable.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            tickerLable.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tickerLable.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }


}

