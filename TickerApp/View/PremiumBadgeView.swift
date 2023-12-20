//
//  PremiumBadgeView.swift
//  TickerApp
//
//  Created by Serj on 08.11.2023.
//

import UIKit

final class PremiumBadgeView: UIView {
    
    private let icon: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isUserInteractionEnabled = false
        //
        let configImage = UIImage(systemName: "crown.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 11, weight: .regular))
        iv.image = configImage
        iv.tintColor = .white
        return iv
    }()
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        setupShape() // 20 x 20 size
        self.addSubview(icon)
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 20),
            self.widthAnchor.constraint(equalToConstant: 20),
            icon.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            icon.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    
    private func setupShape() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createBezierPath().cgPath
        shapeLayer.fillColor = AppColors.primary.cgColor
        shapeLayer.position = CGPoint(x: 0, y: 0)
        self.layer.addSublayer(shapeLayer)
    }
    
    private func createBezierPath() -> UIBezierPath {
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 20, y: 9.85))
        bezierPath.addCurve(to: CGPoint(x: 10.15, y: 0), controlPoint1: CGPoint(x: 20, y: 3.28), controlPoint2: CGPoint(x: 16.72, y: 0))
        bezierPath.addCurve(to: CGPoint(x: 0, y: 9.85), controlPoint1: CGPoint(x: 3.38, y: 0), controlPoint2: CGPoint(x: 0, y: 3.28))
        bezierPath.addCurve(to: CGPoint(x: 10.15, y: 20), controlPoint1: CGPoint(x: 0, y: 16.62), controlPoint2: CGPoint(x: 3.38, y: 20))
        bezierPath.addCurve(to: CGPoint(x: 20, y: 9.85), controlPoint1: CGPoint(x: 16.72, y: 20), controlPoint2: CGPoint(x: 20, y: 16.62))
        bezierPath.close()
        return bezierPath
    }
    
}
