//
//  TickerView.swift
//  TickerApp
//
//  Created by Serj on 30.09.2023.
//

import UIKit
import MarqueeLabel

final class TickerView: UIView {
    
    // Default value
    var isLandscape: Bool = false
    private var currentFontSize: CGFloat = 50.0
    private var currentTextSpeed: CGFloat = 100.0
    private var currentFontName: String = "Oswald-Regular"
    private var currentStrokeWidth: Double = 0.0
    private var currentShadowRadius: Double = 0.0
    
    
    
    
    // MARK: - ticker Lable
    private var tickerLable: MarqueeLabel = {
        let l = MarqueeLabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.adjustsFontSizeToFitWidth = true
        l.type = .continuous
        l.animationDelay = 0.0
        l.animationCurve = .linear // text
        l.fadeLength = 0
        return l
    }()
    
    // MARK: - default Config
    private func defaultConfig() {
        // Default
        tickerLable.font = UIFont(name: self.currentFontName, size: self.currentFontSize)
        tickerLable.speed = .rate(currentTextSpeed)
        
        tickerLable.leadingBuffer = 0
        tickerLable.trailingBuffer = 0
        
        tickerLable.text = "Input text here!"
        tickerLable.textColor = AppColors.primary
        tickerLable.forceScrolling = true
    }
    
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
    // Желательно поправить на configTickerLayout
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
    
    // MARK: - Get Ticker Config
    func getTickerConfig(handler: @escaping (TickerDataModel) -> Void ) {
        let model = TickerDataModel(
            inputText: tickerLable.text ?? "text",
            textColor: encodeUIColor(color: tickerLable.textColor),
            textSpeed: currentTextSpeed,
            bgColor: encodeUIColor(color: self.backgroundColor ?? .black),
            fontName: currentFontName,
            fontSize: Double(currentFontSize),
            stroke: currentStrokeWidth,
            shadow: currentShadowRadius
        )
        handler(model)
    }
    
    // MARK: - Configure Ticker
    // Так себе конфиг 👎
    func configureTicker(tickerDataModel: TickerDataModel, frameWidth: CGFloat) {
        
        configTickerLayout(width: frameWidth)
        
        if tickerDataModel.textSpeed == 0 {
            // Layout stop
            isLabelize(bool: true)
            
            tickerLable.text = tickerDataModel.inputText
            tickerLable.textColor = decodeUIColor(colorString: tickerDataModel.textColor)
            tickerLable.speed = .rate(CGFloat(tickerDataModel.textSpeed ?? currentTextSpeed))
            tickerLable.font = UIFont(name: tickerDataModel.fontName ?? currentFontName, size: CGFloat(tickerDataModel.fontSize ?? currentFontSize))
            self.backgroundColor = decodeUIColor(colorString: tickerDataModel.bgColor)
            //
            setStroke(widthStr: String(format: "%.1f", tickerDataModel.stroke ?? currentStrokeWidth))
            setShadow(radiusStr: String(format: "%.1f", tickerDataModel.shadow ?? currentShadowRadius))
            //
            
            reloadTicker()
        } else {
            // Layout move
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
            
            setStroke(widthStr: String(format: "%.1f", tickerDataModel.stroke ?? currentStrokeWidth))
            setShadow(radiusStr: String(format: "%.1f", tickerDataModel.shadow ?? currentShadowRadius))
            
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
    //
    func setTextSpeed(speedStr: String?) {
        currentTextSpeed = convertTextSpeed(speedStr: speedStr)
        tickerLable.speed = .rate(currentTextSpeed)
    }
    //
    func setBGColor(bgColor: UIColor?) {
        self.backgroundColor = bgColor
    }
    // Text
    func setFontSize(stringSize: String?) {
        tickerLable.font = tickerLable.font.withSize(convertFontSize(stringFontSize: stringSize))
        currentFontSize = convertFontSize(stringFontSize: stringSize)
    }
    func setFont(fontName: String) {
        currentFontName = fontName
        tickerLable.font = UIFont(name: fontName, size: currentFontSize)
    }
    func setTextColor(color: UIColor?) {
        tickerLable.textColor = color
        tickerLable.restartLabel()
    }
    func setStroke(widthStr: String?) {
        guard
            let widthStr = widthStr,
            let doubleWidth = Double(widthStr)
        else { return }
        guard
            let text = tickerLable.text,
            let textColor = tickerLable.textColor,
            let font = tickerLable.font
        else { return }
        //
        currentStrokeWidth = doubleWidth
        //
        let strokeTextAttributes = [
          NSAttributedString.Key.strokeColor : textColor,
          NSAttributedString.Key.foregroundColor : textColor,
          NSAttributedString.Key.strokeWidth : -doubleWidth,
          NSAttributedString.Key.font : font
        ] as [NSAttributedString.Key : Any]

        tickerLable.attributedText = NSMutableAttributedString(string: text, attributes: strokeTextAttributes)
    }
    func setShadow(radiusStr: String?) {
        guard
            let radiusStr = radiusStr,
            let doubleRadius = Double(radiusStr)
        else { return }
        
        var isZero: Bool {
            if (doubleRadius == 0.0) {
                return true
            }
            return false
        }
        currentShadowRadius = doubleRadius
        tickerLable.layer.shadowOpacity = isZero ? 0 : 1
        tickerLable.layer.shadowRadius = isZero ? 0 : CGFloat(doubleRadius)
        tickerLable.layer.shadowOffset = isZero ? CGSize(width: 0, height: 0) : CGSize(width: 2, height: 4)
        tickerLable.layer.shadowColor = isZero ? UIColor.clear.cgColor : tickerLable.textColor.cgColor
    }
    
    
    
    
    
    
    // MARK: - Support
    // reload
    func reloadTicker() {
        tickerLable.restartLabel()
        tickerLable.layoutIfNeeded()
        tickerLable.forceScrolling = true
    }
    
    
    


}


// MARK: - Setup UI
extension TickerView {

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
