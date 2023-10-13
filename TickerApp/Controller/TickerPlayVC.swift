//
//  TickerPlayVC.swift
//  TickerApp
//
//  Created by Serj on 11.10.2023.
//

import UIKit


class TickerPlayVC: UIViewController {
    
    // MARK: - close
    private let close: CircleButton = {
        let b = CircleButton(
            frame: .zero,
            bgColor: AppColors.gray5,
            iconSystemName: "xmark",
            iconColor: AppColors.gray2
        )
        return b
    }()
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
    private let tickerView: TickerView = EditSettingsVM.tickerView  // viewDidAppear
    

//     MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .black
        setupUI()
    }
    // MARK: - view Did Appear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tickerView.configTickerLayout(width: self.view.frame.size.width)
//        tickerView.setFont(font: nil)
    }
    
    // MARK: - Orientation
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }
    override var shouldAutorotate: Bool {
        return true
    }
    
    
    


    

}

// MARK: - Setup UI
extension TickerPlayVC {
    
    private func setupUI() {
        
        
        // header
        let headerStack = UIStackView(arrangedSubviews: [close,edit,UIView(),playPause,edit])
        headerStack.translatesAutoresizingMaskIntoConstraints = false
        headerStack.axis = .horizontal
        headerStack.alignment = .fill
        headerStack.spacing = 24
        
        self.view.addSubview(headerStack)
        self.view.addSubview(tickerView)
        
        
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
    
    
}
