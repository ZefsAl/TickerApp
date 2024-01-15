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
    public private(set) var currentFontSize: CGFloat = 100.0
    private var currentTextSpeed: CGFloat = 100.0
    private var currentFontName: String = "Oswald-Regular"
    
    private var currentBGImageName: String = "Empty" // или background0
    private var currentLayoutWidth: CGFloat = 400
    private var isReversedScroll: Bool = false
    private var currentSparkleDuration: Double = 0.0
    // Stroke
    private var currentStrokeWidth: Double = 2.0
    // Shadow
    private var currentShadowRadius: Double = 5.0
    public private(set) var currentShadowColor: CGColor = UIColor.clear.cgColor
    
    // Other
    private var timer = Timer()
    private let imageView: UIImageView = UIImageView()
    
    
    // MARK: - ticker Label
    private var tickerLabel: MarqueeLabel = {
        let l = MarqueeLabel()
        return l
    }()
    
    // MARK: - default Config
    private func defaultConfig() {
        // Configure
        tickerLabel.translatesAutoresizingMaskIntoConstraints = false
        tickerLabel.adjustsFontSizeToFitWidth = true
        tickerLabel.type = .continuous
        tickerLabel.animationDelay = 0.0
        tickerLabel.animationCurve = .linear // text
        tickerLabel.fadeLength = 0
        tickerLabel.alpha = 1
        // Default
        tickerLabel.font = UIFont(name: self.currentFontName, size: self.currentFontSize)
        tickerLabel.speed = .rate(currentTextSpeed)
        tickerLabel.leadingBuffer = 0
        tickerLabel.trailingBuffer = 0
        tickerLabel.text = "Input text here!"
        tickerLabel.textColor = AppColors.primary
        tickerLabel.forceScrolling = true
        // other style - cust fix
        setDefaultEffect(color: tickerLabel.textColor.cgColor)
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
    func isLabelize(bool: Bool) {
        if bool {
            tickerLabel.leadingBuffer = 0
            tickerLabel.trailingBuffer = 0
            tickerLabel.labelize = true
            tickerLabel.textAlignment = .center
        } else {
            tickerLabel.leadingBuffer = currentLayoutWidth
            tickerLabel.trailingBuffer = currentLayoutWidth/2
            tickerLabel.labelize = false
            tickerLabel.textAlignment = .left
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
    
    // MARK: - init ⚙️
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        viewStyle()
        setupTickerLabelUI()
        defaultConfig()
    }
    
    deinit {
        // Если есть данные то ticker view не освобождается
        print("✅ deinit ticker view")
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
    
    // MARK: - Configure Ticker ⚙️
    func configureTicker(tickerDataModel: TickerDataModel, frameBuffer: CGFloat) {
        print("🔵 Start configureTicker")
        configTickerLayout(width: frameBuffer)
        //
        startSparkleTimer(duration: tickerDataModel.sparkleDuration ?? self.currentSparkleDuration)
        reverseScroll(isReversedScroll: tickerDataModel.isReversedScroll ?? self.isReversedScroll)
        
        // Баговый конфиг ~~~>
        tickerLabel.text = tickerDataModel.inputText
        tickerLabel.textColor = decodeUIColor(colorString: tickerDataModel.textColor)
        tickerLabel.speed = .rate(CGFloat(tickerDataModel.textSpeed ?? self.currentTextSpeed))
        //
        self.backgroundColor = decodeUIColor(colorString: tickerDataModel.bgColor)
        setBackgroundImage(named: tickerDataModel.bgImage)
        //
        setStroke(widthStr: String(format: "%.1f", tickerDataModel.stroke ?? self.currentStrokeWidth))
        setShadow(radiusStr: String(format: "%.1f", tickerDataModel.shadow ?? self.currentShadowRadius))
        //
        if tickerDataModel.textSpeed == 0 {
            isLabelize(bool: true)
            tickerLabel.font = UIFont(name: tickerDataModel.fontName ?? self.currentFontName, size: CGFloat(tickerDataModel.fontSize ?? self.currentFontSize))
        } else {
            isLabelize(bool: false)
            tickerLabel.font = UIFont(
                name: tickerDataModel.fontName ?? self.currentFontName,
                size: isLandscape ? CGFloat(tickerDataModel.fontSize ?? self.currentFontSize) * 2 : CGFloat(tickerDataModel.fontSize ?? self.currentFontSize)
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
        tickerLabel.leadingBuffer = width
        tickerLabel.trailingBuffer = width/2
    }
    
    // MARK: - Set
    // Default
    private func setDefaultEffect(color: CGColor?) {
        setShadow(radiusStr: String(currentShadowRadius), shadowColor: color)
        setStroke(widthStr: String(currentStrokeWidth))
    }
    // Input
    func setInputText(text: String) {
        tickerLabel.text = text
        tickerLabel.restartLabel()
    }
    // MARK: - Effect
    func startSparkleTimer(duration: Double) {
        self.timer.invalidate()
        self.currentSparkleDuration = duration
        guard duration != 0 else { stopSparkleTimer(); return }
        self.timer = Timer.scheduledTimer(withTimeInterval: duration, repeats: true) { [weak self] timer in
            self?.sparkle(duration: duration)
        }
    }
    func stopSparkleTimer() {
        self.timer.invalidate()
        self.tickerLabel.alpha = 1
    }
    func reverseScroll(isReversedScroll: Bool) {
        self.isReversedScroll = isReversedScroll
        self.tickerLabel.type = isReversedScroll ? .continuousReverse : .continuous
    }
    func setTextSpeed(speedStr: String?) {
        currentTextSpeed = convertTextSpeed(speedStr: speedStr)
        tickerLabel.speed = .rate(currentTextSpeed)
    }
   
    
    // MARK: - Text
    func setFontSize(stringSize: String?) {
        tickerLabel.font = tickerLabel.font.withSize(convertFontSize(stringFontSize: stringSize))
        currentFontSize = convertFontSize(stringFontSize: stringSize)
    }
    func setFont(fontName: String) {
        currentFontName = fontName
        tickerLabel.font = UIFont(name: fontName, size: currentFontSize)
    }
    func setTextColor(color: UIColor?) {
        tickerLabel.textColor = color
        setDefaultEffect(color: color?.cgColor)
    }
    func setStroke(widthStr: String?) {
        guard
            let widthStr = widthStr,
            let doubleWidth = Double(widthStr)
        else { return }
        guard
            let text = tickerLabel.text,
            let textColor = tickerLabel.textColor,
            let font = tickerLabel.font
        else { return }
        //
        currentStrokeWidth = doubleWidth
        //
        let strokeTextAttributes = [
            NSAttributedString.Key.strokeColor : textColor,
            NSAttributedString.Key.foregroundColor : textColor,
            NSAttributedString.Key.strokeWidth : -doubleWidth, // doubleWidth без минуса, можно добавить как фичу
            NSAttributedString.Key.font : font
        ] as [NSAttributedString.Key : Any]
        //
        tickerLabel.attributedText = NSMutableAttributedString(string: text, attributes: strokeTextAttributes)
    }
    
    func setShadow(radiusStr: String?, shadowColor: CGColor? = nil) {
        guard
            let radiusStr = radiusStr,
            let doubleRadius = Double(radiusStr)
        else { return }
        
        var isZero: Bool {
            guard doubleRadius == 0.0 else { return false }
            return true
        }
        //
        currentShadowRadius = doubleRadius
        currentShadowColor = tickerLabel.textColor.cgColor
        tickerLabel.layer.shadowColor = isZero ? UIColor.clear.cgColor : self.currentShadowColor
        //
        tickerLabel.layer.shadowOpacity = isZero ? 0 : 1
        tickerLabel.layer.shadowRadius = isZero ? 0 : CGFloat(doubleRadius)
        tickerLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    func setHandjetFont(variableFont: UIFont) {
        currentFontName = variableFont.fontName
        tickerLabel.font = variableFont
        currentFontSize = tickerLabel.font.pointSize
    }
    func setDefaultFont() {
        self.setFont(fontName: "Oswald-Regular")
        self.setFontSize(stringSize: "100")
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
    
    
    

    
    // MARK: - Get
    // get Ticker Configure
    func getTickerConfigure(handler: @escaping (TickerDataModel) -> Void ) {
        // желательно было вывести в верх тела как TickerDataModel без переменных как модель
        let model = TickerDataModel(
            dateAdded: Date(),
            inputText: tickerLabel.text ?? "text",
            textColor: encodeUIColor(color: tickerLabel.textColor),
            textSpeed: currentTextSpeed,
            bgColor: encodeUIColor(color: self.backgroundColor ?? .black),
            bgImage: currentBGImageName,
            fontName: currentFontName,
            fontSize: Double(currentFontSize),
            stroke: currentStrokeWidth,
            shadow: currentShadowRadius,
            isReversedScroll: isReversedScroll,
            sparkleDuration: currentSparkleDuration
        )
        handler(model)
    }
    // get Image Name
    private func getImageName(imageView: UIImageView) -> String {
        guard
            imageView.image?.imageAsset?.value(forKey: "assetName") as? String != "Empty",
            let name = imageView.image?.imageAsset?.value(forKey: "assetName") as? String
        else {
            return currentBGImageName
        }
        return name
    }
    
    
    // MARK: - Remove
    func removeDefaultEffect() {
        setShadow(radiusStr: "0")
        setStroke(widthStr: "0")
    }
//    func removeShadow() {
//        currentShadowRadius = 0
//        tickerLabel.layer.shadowOpacity = 0
//        tickerLabel.layer.shadowRadius = 0
//        tickerLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
//        tickerLabel.layer.shadowColor = nil
//    }
    

    // MARK: - Support
    func reloadTicker() {
        tickerLabel.restartLabel()

        tickerLabel.forceScrolling = true
    }
}

// Sparkle
extension TickerView {
    private func sparkle(duration: Double) {
        UIView.transition(with: tickerLabel,
                      duration: duration,
                       options: .curveEaseInOut,
                    animations: { [weak self] in
            self?.tickerLabel.alpha = 0.1
        }) { _ in
            UIView.transition(with: self.tickerLabel,
                          duration: duration,
                           options: .curveEaseInOut,
                        animations: { [weak self] in
                self?.tickerLabel.alpha = 1
            })
        }
    }
}

// MARK: - Setup UI
extension TickerView {
    private func setupTickerLabelUI() {
        // Adding
        self.addSubview(tickerLabel)
        // Constraints
        NSLayoutConstraint.activate([
            tickerLabel.topAnchor.constraint(equalTo: self.topAnchor),
            tickerLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tickerLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tickerLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
}
