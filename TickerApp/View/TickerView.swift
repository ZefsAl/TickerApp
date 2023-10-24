//
//  TickerView.swift
//  TickerApp
//
//  Created by Serj on 30.09.2023.
//

import UIKit
import MarqueeLabel

final class TickerView: UIView {

    
    private var currentFontSize: CGFloat = 80.0
    private var currentTextSpeed: CGFloat = 100.0
    private var currentFontName: String = "SF-Pro-Rounded-Regular"
    
    
    // MARK: - ticker Lable
    private var tickerLable: MarqueeLabel = {
        
        let l = MarqueeLabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.adjustsFontSizeToFitWidth = true
        

        l.type = .continuous
        l.animationDelay = 0.0
        l.animationCurve = .linear // text
        l.fadeLength = 0
        
        l.restartLabel()
        return l
    }()
    
    
    private func defaultConfig() {
        // Test config, need default func config
        tickerLable.font = UIFont(name: self.currentFontName, size: self.currentFontSize)
        
        tickerLable.speed = .rate(currentTextSpeed)
        
//        tickerLable.leadingBuffer = 400
//        tickerLable.trailingBuffer = 200
        
        tickerLable.leadingBuffer = 0
        tickerLable.trailingBuffer = 0
        
        
        tickerLable.text = "Input text here!"
//        l.text = "Русский"
//        l.textColor = .white
        tickerLable.textColor = AppColors.primary
        tickerLable.forceScrolling = true
        
        
//        l.font = SFProRounded.set(fontSize: currentFontSize, weight: .heavy)
        // work
//        l.font = UIFont.init(name: "PermanentMarker-Regular", size: 150)
//        l.font = UIFont.init(name: "Bangers-Regular", size: 75)
//        l.font = UIFont.init(name: "PressStart2P-Regular", size: 150)
//        l.font = UIFont.init(name: "LibreBarcode39-Regular", size: 150)
        
    }
    
    var isLandscape: Bool = false
    
    // MARK: - Convert Speed
    private func convertTextSpeed(speedStr: String?) -> CGFloat {
        guard
            let speedStr = speedStr,
            let double = Double(speedStr)
        else { return currentTextSpeed }
        
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
    
    // MARK: - isLabelize
    // Buffer нужно указывать в зависимости view width
    func isLabelize(bool: Bool) {
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
    
    // MARK: - convertFontSize
    private func convertFontSize(stringFontSize: String?) -> CGFloat {
        guard
            let stringSize = stringFontSize,
            let double = Double(stringSize)
        else { return currentFontSize}
        
        return CGFloat(double)
    }
    
    
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        viewStyle()
        setupUI()
        defaultConfig()

        
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
    
    // MARK: - Get TickerConfig
    func getTickerConfig(handler: @escaping (TickerDataModel) -> Void ) {
        let model = TickerDataModel(
            inputText: tickerLable.text ?? "text",
            textColor: encodeUIColor(color: tickerLable.textColor),
            textSpeed: currentTextSpeed,
            bgColor: encodeUIColor(color: self.backgroundColor ?? .black),
            fontName: currentFontName,
            fontSize: Double(currentFontSize)
        )
        handler(model)
    }
    
    // MARK: - Configure Ticker
    func configureTicker(tickerDataModel: TickerDataModel, frameWidth: CGFloat) {
        
        configTickerLayout(width: frameWidth)
        
        if tickerDataModel.textSpeed == 0 {
            isLabelize(bool: true)
            
            tickerLable.text = tickerDataModel.inputText
            tickerLable.textColor = decodeUIColor(colorString: tickerDataModel.textColor)
            tickerLable.speed = .rate(CGFloat(tickerDataModel.textSpeed ?? currentTextSpeed))
            tickerLable.font = UIFont(name: tickerDataModel.fontName ?? currentFontName, size: CGFloat(tickerDataModel.fontSize ?? currentFontSize))
            self.backgroundColor = decodeUIColor(colorString: tickerDataModel.bgColor)
            reloadTicker()
        } else {
            tickerLable.labelize = false
            tickerLable.text = tickerDataModel.inputText
            tickerLable.textColor = decodeUIColor(colorString: tickerDataModel.textColor)
            tickerLable.speed = .rate(CGFloat(tickerDataModel.textSpeed ?? currentTextSpeed))
            
            if isLandscape {
                tickerLable.font = UIFont(name: tickerDataModel.fontName ?? currentFontName, size: CGFloat(tickerDataModel.fontSize ?? currentFontSize) * 2)
            } else {
                tickerLable.font = UIFont(name: tickerDataModel.fontName ?? currentFontName, size: CGFloat(tickerDataModel.fontSize ?? currentFontSize))
            }
            
            self.backgroundColor = decodeUIColor(colorString: tickerDataModel.bgColor)
            reloadTicker()
            
        }
    }
    
    // MARK: - config Ticker Layout
    func configTickerLayout(width: CGFloat) {
        tickerLable.leadingBuffer = width
        tickerLable.trailingBuffer = width/2
    }
    
    // MARK: - Set Ticker
    func setInputText(text: String) {
        tickerLable.text = text
        tickerLable.restartLabel()
    }
    func setText(textColor: UIColor?) {
        tickerLable.textColor = textColor
        tickerLable.restartLabel()
    }
    func setEffect(speedStr: String?) {
        currentTextSpeed = convertTextSpeed(speedStr: speedStr)
        tickerLable.speed = .rate(currentTextSpeed)
    }
    func setBGColor(bgColor: UIColor?) {
        self.backgroundColor = bgColor
    }
    func setFontSize(stringSize: String?) {
        tickerLable.font = tickerLable.font.withSize(convertFontSize(stringFontSize: stringSize))
        currentFontSize = convertFontSize(stringFontSize: stringSize)
    }
    func setFont(fontName: String) {
        currentFontName = fontName
        tickerLable.font = UIFont(name: fontName, size: currentFontSize)
    }
    
//    func setIncreaseFontSize(stringSize: String?) {
//        tickerLable.font = tickerLable.font.withSize(convertFontSize(stringFontSize: stringSize))
//        currentFontSize = convertFontSize(stringFontSize: stringSize)
//    }
    
    
    // MARK: - Support
    // reload
    func reloadTicker() {
        tickerLable.restartLabel()
        tickerLable.layoutIfNeeded()
        tickerLable.forceScrolling = true
    }
    
    
    
    
    // MARK: - Setup UI
    private func setupUI() {
        // Adding
        self.addSubview(tickerLable)
        
        // Constraints
        NSLayoutConstraint.activate([
            tickerLable.topAnchor.constraint(equalTo: self.topAnchor),
            tickerLable.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tickerLable.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tickerLable.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }


}

