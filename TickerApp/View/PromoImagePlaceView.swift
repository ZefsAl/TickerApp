//
//  PromoImagePlace.swift
//  TickerApp
//
//  Created by Serj on 21.11.2023.
//

import UIKit

class PromoImagePlaceView: UIView {

    // MARK: - Promo Image
    private let promoImageView: UIImageView = {
       let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.clipsToBounds = true
        //
        self.layer.cornerRadius = 40
        self.addSubview(promoImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - set Image
    func setImage(named: String) {
        self.setNeedsLayout()
        self.layoutIfNeeded()
        //
        promoImageView.contentMode = .top
        promoImageView.clipsToBounds = true
        //
        let image = UIImage(named: named)
        promoImageView.image = image?.resizeTopAlignedToFill(newWidth: self.frame.width)
    }
}


extension UIImage {
    // For fix
    func resizeTopAlignedToFill(newWidth: CGFloat) -> UIImage? {
        let newHeight = size.height * newWidth / size.width
        
        let newSize = CGSize(width: newWidth, height: newHeight)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
        draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
