//
//  UIView_Ext.swift
//  TickerApp
//
//  Created by Serj on 20.10.2023.
//

import Foundation
import UIKit


extension UIView {
    
    // MARK: - colorAnimateTap
    func colorAnimateTap() {
        let bgColor = self.backgroundColor
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseInOut) {
            self.backgroundColor = AppColors.gray3
        } completion: { _ in
            UIView.animate(withDuration: 0.15, delay: 0) {
                self.backgroundColor = bgColor
            }
        }
    }
    
    // MARK: - Fade text
    func fadeTransition(_ duration:CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
    
    // MARK: - Button
    func tapAnimateBegan() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseInOut) {
                self.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
            }
        }
    }
    
    func tapAnimateEnded() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseInOut) {
                self.transform = CGAffineTransform.identity
            } 
        }
    }
    
    func wrongShake() {
        
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.05
        shake.repeatCount = 2
        shake.autoreverses = true
        
        let fromPoint = CGPoint(x: self.center.x - 5, y: self.center.y)
        let fromValue = NSValue(cgPoint: fromPoint)
        
        let toPoint = CGPoint(x: self.center.x + 5, y: self.center.y)
        let toValue = NSValue(cgPoint: toPoint)
        
        shake.fromValue = fromValue
        shake.toValue = toValue
        
        self.layer.add(shake, forKey: "position")
    }
    
    
    func tapDefaultAnimate() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2, animations: {
                self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }, completion: { _ in
                UIView.animate(withDuration: 0.2) {
                    self.transform = CGAffineTransform.identity
                }
            })
        }
    }

    // MARK: - haptic
    func hapticImpact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    func hapticNotification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
}
