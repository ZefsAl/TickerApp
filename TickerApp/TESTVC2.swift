//
//  TESTVC2.swift
//  TickerApp
//
//  Created by Serj on 10.12.2023.
//
//
//import Foundation
//import UIKit
//
//class TESTVC2: UIViewController {
//
//    let label: UILabel = {
//        let l = UILabel()
//        l.translatesAutoresizingMaskIntoConstraints = false
//        l.backgroundColor = .orange
////        l.font.withSize(<#T##fontSize: CGFloat##CGFloat#>)
//        return l
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        self.label.text = "TEST1🎃"
//        
//        // Предполагаем, что ваш UILabel уже содержит текст
//        guard let labelText = label.text else { return }
//
//        // Создаем CAShapeLayer с пиксельным гридом в виде кругов
//        let pixelGridLayer = createPixelGridLayer(text: labelText, style: .circle)
//        
//        // Устанавливаем позицию и добавляем его на ваш UILabel
//        pixelGridLayer.position = label.center
//        view.layer.addSublayer(pixelGridLayer)
//        
////        self.view.addSubview(label)
////        label.layer.addSublayer(pixelGridLayer)
////        NSLayoutConstraint.activate([
////            self.label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
////            self.label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
////        ])
//    }
//
//    func createPixelGridLayer(text: String, style: PixelGridStyle) -> CALayer {
//        let pixelGridLayer = CALayer()
//
//        // Создаем CAShapeLayer с нужным стилем
//        let shapeLayer = CAShapeLayer()
//        shapeLayer.frame = pixelGridLayer.bounds
//        shapeLayer.fillColor = UIColor.clear.cgColor  // Цвет кругов или квадратов
//        shapeLayer.strokeColor = UIColor.clear.cgColor
//        shapeLayer.lineWidth = 0.0  // Ширина обводки (если нужно)
//        pixelGridLayer.addSublayer(shapeLayer)
//
//        // Дополнительно настраиваем CAShapeLayer в зависимости от стиля (круги или квадраты)
//        switch style {
//        case .circle:
//            shapeLayer.path = createBezierPath().cgPath
//            
//        case .square:
//            shapeLayer.path = createBezierPath().cgPath
//
//        }
//
//        // Добавляем текст в ваш CAShapeLayer
//        let textLayer = CATextLayer()
//        textLayer.string = text
//        textLayer.fontSize = 100.0  // Размер шрифта
//        textLayer.alignmentMode = .center
//        textLayer.frame = pixelGridLayer.bounds
//        pixelGridLayer.addSublayer(textLayer)
//
//        return pixelGridLayer
//    }
//}
//
//// Перечисление для определения стиля пиксельного грида
//enum PixelGridStyle {
//    case circle
//    case square
//    // Добавьте другие стили при необходимости
//}
//
//
//
//extension TESTVC2 {
//
//    private func setupShape(shapeLayer: CAShapeLayer) {
////        let shapeLayer = CAShapeLayer()
//        shapeLayer.path = createBezierPath().cgPath
//        shapeLayer.fillColor = AppColors.primary.cgColor
//        shapeLayer.position = CGPoint(x: 0, y: 0)
////        self.layer.addSublayer(shapeLayer)
//    }
//
//    private func createBezierPath() -> UIBezierPath {
//        let bezierPath = UIBezierPath()
//        bezierPath.move(to: CGPoint(x: 20, y: 9.85))
//        bezierPath.addCurve(to: CGPoint(x: 10.15, y: 0), controlPoint1: CGPoint(x: 20, y: 3.28), controlPoint2: CGPoint(x: 16.72, y: 0))
//        bezierPath.addCurve(to: CGPoint(x: 0, y: 9.85), controlPoint1: CGPoint(x: 3.38, y: 0), controlPoint2: CGPoint(x: 0, y: 3.28))
//        bezierPath.addCurve(to: CGPoint(x: 10.15, y: 20), controlPoint1: CGPoint(x: 0, y: 16.62), controlPoint2: CGPoint(x: 3.38, y: 20))
//        bezierPath.addCurve(to: CGPoint(x: 20, y: 9.85), controlPoint1: CGPoint(x: 16.72, y: 20), controlPoint2: CGPoint(x: 20, y: 16.62))
//        bezierPath.close()
//        return bezierPath
//    }
//
//}
