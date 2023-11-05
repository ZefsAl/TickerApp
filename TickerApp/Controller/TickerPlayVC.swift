//
//  TickerPlayVC.swift
//  TickerApp
//
//  Created by Serj on 11.10.2023.
//

import UIKit


class TickerPlayVC: UIViewController {
    
//    private var isHiddenUI: Bool = true
    
    let headerStack: UIStackView = {
        let s = UIStackView()
        s.isHidden = false
        s.layer.opacity = 1
        return s
    }()
    
    // MARK: - close
    private let close: CircleButton = {
        let b = CircleButton(
            frame: .zero,
            bgColor: AppColors.gray5,
            iconSystemName: "xmark",
            iconColor: AppColors.gray2
        )
        b.addTarget(Any?.self, action: #selector(closeAct), for: .touchUpInside)
        return b
    }()
    @objc private func closeAct(_ sender: MediumButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - playPause
    private let playPause: MediumButton = {
        let b = MediumButton(
            frame: .zero,
            bgColor: AppColors.secondary,
            title: nil,
            titleColor: nil,
            iconSystemName: "playpause.fill",
            iconColor: AppColors.primary,
            hideTitle: true
        )
        return b
    }()
    // MARK: - edit
    private let edit: MediumButton = {
        let b = MediumButton(
            frame: .zero,
            bgColor: AppColors.primary,
            title: "Edit",
            titleColor: AppColors.secondary,
            iconSystemName: "square.and.pencil",
            iconColor: AppColors.secondary,
            hideTitle: false
        )
        return b
    }()
    
    // MARK: - TickerView
    private var tickerView: TickerView = {
        let t = TickerView()
        t.layer.borderColor = UIColor.clear.cgColor
        return t
    }()
    
    

//     MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        setupUI()
        showHideUI()
        
    }
    
    // MARK: - Init
    init(tickerDataModel: TickerDataModel?) {
        super.init(nibName: nil, bundle: nil)
        
        if let model = tickerDataModel {
            self.tickerView.isLandscape = true
            self.tickerView.configureTicker(tickerDataModel: model, frameWidth: self.view.frame.size.height) // 🔄 на оборот
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - view Did Appear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    // MARK: - view Did Layout Subviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.rotateToLandsScapeDevice()
    }
    // MARK: - view Will Disappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.rotateToPotraitScapeDevice()
    }
    
    // MARK: - Orientation - BUG
    func rotateToLandsScapeDevice(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.defaultOrientation = .landscapeLeft
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
        UIView.setAnimationsEnabled(true)
    }

    func rotateToPotraitScapeDevice(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.defaultOrientation = .portrait
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        UIView.setAnimationsEnabled(true)
    }

}

// MARK: - Setup UI
extension TickerPlayVC {
    
    private func setupUI() {
        
        // header
//        let headerStack = UIStackView(arrangedSubviews: [close,UIView(),playPause,edit])
        headerStack.addArrangedSubview(close)
        headerStack.addArrangedSubview(UIView())
        headerStack.addArrangedSubview(playPause)
        headerStack.addArrangedSubview(edit)
        headerStack.translatesAutoresizingMaskIntoConstraints = false
        headerStack.axis = .horizontal
        headerStack.alignment = .fill
        headerStack.spacing = 24
        
        self.view.addSubview(tickerView)  // 1
        self.view.addSubview(headerStack) // 2
        
        // Stack
        let top: CGFloat = 16
//        let left: CGFloat = 16
//        let right: CGFloat = -16
//        let width: CGFloat = right - left
        
        let viewMargin = self.view.layoutMarginsGuide
        NSLayoutConstraint.activate([

            headerStack.topAnchor.constraint(equalTo: viewMargin.topAnchor, constant: top),
            headerStack.leadingAnchor.constraint(equalTo: viewMargin.leadingAnchor, constant: 0),
            headerStack.trailingAnchor.constraint(equalTo: viewMargin.trailingAnchor, constant: 0),

            tickerView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tickerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tickerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tickerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }
    
    // MARK: - show Hide UI
    private func showHideUI() {
        
        // Delay hide
        UIView.animate(withDuration: 0.2, delay: 2, options: .curveEaseInOut) {
            self.headerStack.layer.opacity = 0
        } completion: { _ in
            self.headerStack.isHidden = true
        }
        
        let showHideGesture = UITapGestureRecognizer(target: self, action: #selector(showHideGesture))
        self.view.addGestureRecognizer(showHideGesture)
    }
    // MARK: - show Gesture
    @objc private func showHideGesture() {
        if self.headerStack.isHidden {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
                self.headerStack.isHidden = false
                self.headerStack.layer.opacity = 1
            } completion: { _ in }
        } else {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
                self.headerStack.layer.opacity = 0
            } completion: { _ in
                self.headerStack.isHidden = true
            }
        }
    }
}
