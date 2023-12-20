//
//  TickerView.swift
//  TickerApp
//
//  Created by Serj on 30.09.2023.
//

import UIKit
import MarqueeLabel

final class TickerView: UIView {
    
    //
    var isLandscape: Bool = false
    
    // MARK: - Default value
    // Do not change
    private var currentFontSize: CGFloat = 50.0
    private var currentTextSpeed: CGFloat = 100.0
    private var currentFontName: String = "Oswald-Regular"
    private var currentStrokeWidth: Double = 0.0
    private var currentShadowRadius: Double = 0.0
    private var currentBGImageName: String = "Empty" // или background0
    
    private var currentLayoutWidth: CGFloat = 400
    
    //
    private let imageView: UIImageView = UIImageView()
    
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
    
    // MARK: - is Labelize
    // Buffer нужно указывать в зависимости view width
    // Желательно поправить на configTickerLayout как нибудь
    
    func isLabelize(bool: Bool) {
        if bool {
            tickerLable.leadingBuffer = 0
            tickerLable.trailingBuffer = 0
            tickerLable.labelize = true
            tickerLable.textAlignment = .center
        } else {
            tickerLable.leadingBuffer = currentLayoutWidth
            tickerLable.trailingBuffer = currentLayoutWidth/2
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
        setupTickerLableUI()
        defaultConfig()
    }
    
    deinit {
        // Если есть данные то ticker view не освобождается
//        print("✅ deinit ticker view")
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
    func getTickerConfigure(handler: @escaping (TickerDataModel) -> Void ) {
        let model = TickerDataModel(
            dateAdded: Date(),
            inputText: tickerLable.text ?? "text",
            textColor: encodeUIColor(color: tickerLable.textColor),
            textSpeed: currentTextSpeed,
            bgColor: encodeUIColor(color: self.backgroundColor ?? .black),
            bgImage: currentBGImageName,
            fontName: currentFontName,
            fontSize: Double(currentFontSize),
            stroke: currentStrokeWidth,
            shadow: currentShadowRadius
        )
        handler(model)
    }
    
    // MARK: - Configure Ticker ⚙️
    func configureTicker(tickerDataModel: TickerDataModel, frameBuffer: CGFloat) {
        print("🔵 Start configureTicker")
        configTickerLayout(width: frameBuffer)
        
        // Баговый конфиг ~~~>
        tickerLable.text = tickerDataModel.inputText
        tickerLable.textColor = decodeUIColor(colorString: tickerDataModel.textColor)
        tickerLable.speed = .rate(CGFloat(tickerDataModel.textSpeed ?? currentTextSpeed))
        ///
        self.backgroundColor = decodeUIColor(colorString: tickerDataModel.bgColor)
        setBackgroundImage(named: tickerDataModel.bgImage)
        ///
        setStroke(widthStr: String(format: "%.1f", tickerDataModel.stroke ?? currentStrokeWidth))
        setShadow(radiusStr: String(format: "%.1f", tickerDataModel.shadow ?? currentShadowRadius))
        ///
        if tickerDataModel.textSpeed == 0 {
            isLabelize(bool: true)
            tickerLable.font = UIFont(name: tickerDataModel.fontName ?? currentFontName, size: CGFloat(tickerDataModel.fontSize ?? currentFontSize))
        } else {
            isLabelize(bool: false)
            tickerLable.font = UIFont(
                name: tickerDataModel.fontName ?? currentFontName,
                size: isLandscape ? CGFloat(tickerDataModel.fontSize ?? currentFontSize) * 2 : CGFloat(tickerDataModel.fontSize ?? currentFontSize)
            )
        }
        
        updateInstancesValue(tickerDataModel: tickerDataModel)
        reloadTicker()
    }
    
    // При getTickerConfig получаем эти значения
    // MARK: - update Instances Value
    func updateInstancesValue(tickerDataModel: TickerDataModel) {
        self.currentFontSize = CGFloat(tickerDataModel.fontSize ?? currentFontSize);
        self.currentTextSpeed = CGFloat(tickerDataModel.textSpeed ?? currentTextSpeed);
        self.currentFontName = tickerDataModel.fontName ?? currentFontName;
        self.currentStrokeWidth = tickerDataModel.stroke ?? currentStrokeWidth
        self.currentShadowRadius = tickerDataModel.shadow ?? currentShadowRadius
    }
    
    // MARK: - Config Ticker Layout
    func configTickerLayout(width: CGFloat) {
        self.currentLayoutWidth = width
        //
        tickerLable.leadingBuffer = width
        tickerLable.trailingBuffer = width/2
    }
    
    // MARK: - Set
    // Input
    func setInputText(text: String) {
        tickerLable.text = text
        tickerLable.restartLabel()
    }
    // MARK: - Effect
    func setTextSpeed(speedStr: String?) {
        currentTextSpeed = convertTextSpeed(speedStr: speedStr)
        tickerLable.speed = .rate(currentTextSpeed)
    }
    // MARK: - Text
    func setFontSize(stringSize: String?) {
        tickerLable.font = tickerLable.font.withSize(convertFontSize(stringFontSize: stringSize))
        currentFontSize = convertFontSize(stringFontSize: stringSize)
    }
    func setFont(fontName: String) {
        currentFontName = fontName
        tickerLable.font = UIFont(name: fontName, size: currentFontSize)
        
        Task {
//            print("setFont -🟠",currentFontName)
//            print("setFont -🔴",tickerLable.font.fontName)
        }
    }
    func setTextColor(color: UIColor?) {
        tickerLable.textColor = color
        tickerLable.restartLabel()
        
        Task {
//            print("setTextColor -🟠",currentFontName)
//            print("setTextColor -🔴",tickerLable.font.fontName)
        }
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
        //
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
        //
        currentShadowRadius = doubleRadius
        //
        tickerLable.layer.shadowOpacity = isZero ? 0 : 1
        tickerLable.layer.shadowRadius = isZero ? 0 : CGFloat(doubleRadius)
        tickerLable.layer.shadowOffset = isZero ? CGSize(width: 0, height: 0) : CGSize(width: 2, height: 4)
        tickerLable.layer.shadowColor = isZero ? UIColor.clear.cgColor : tickerLable.textColor.cgColor
    }
    func setHandjetFont(variableFont: UIFont) {
        currentFontName = variableFont.fontName
        tickerLable.font = variableFont
        
//        Task {
//            print("setHandjetFont 🔴",tickerLable.font.fontName)
//            print("setHandjetFont -🟠",currentFontName)
//        }
    }
    // MARK: - Background
    func setBGColor(bgColor: UIColor?) {
        self.backgroundColor = bgColor
    }
    func setBackgroundImage(named: String?) {
        guard
            let named = named,
            named != "Empty"
        else {
            self.imageView.image = nil
            currentBGImageName = "Empty"
            return
        }
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode =  UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        //
        self.imageView.image = UIImage(named: named)
        self.currentBGImageName = self.getImageName(imageView: self.imageView)
        //
        imageView.center = self.center
        self.addSubview(imageView)
        self.sendSubviewToBack(imageView)
        // Пришлось Constraint
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    
    

    
    
    // MARK: - Support
    // reload
    func reloadTicker() {
        tickerLable.restartLabel()
        tickerLable.layoutIfNeeded()
        tickerLable.forceScrolling = true
    }
    
    // Get
    private func getImageName(imageView: UIImageView) -> String {
        guard
            imageView.image?.imageAsset?.value(forKey: "assetName") as? String != "Empty",
            let name = imageView.image?.imageAsset?.value(forKey: "assetName") as? String
        else {
            return currentBGImageName
        }
        return name
    }
    
    
    


}


// MARK: - Setup UI
extension TickerView {
    private func setupTickerLableUI() {
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
