//
//  BigCVCell.swift
//  TickerApp
//
//  Created by Serj on 22.10.2023.
//

import UIKit

protocol PromoCVCellDelegate {
    func showPaywall()
}

final class PromoCVCell: UICollectionViewCell {
    
    lazy var promoCVCellDelegate: PromoCVCellDelegate? = nil
    
    static var reuseID: String {
        String(describing: self)
    }
    
    // MARK: - ctaButton
    private let ctaButton: BigButton = {
        let b = BigButton(
            frame: .zero,
            bgColor: AppColors.primary,
            title: "Get Pro Plan",
            titleColor: AppColors.secondary,
            iconSystemName: "sparkles",
            iconColor: AppColors.secondary
        )
        b.addTarget(Any?.self, action: #selector(ctaAct), for: .touchUpInside)
        return b
    }()
    @objc private func ctaAct() {
        promoCVCellDelegate?.showPaywall()
    }
    
    // MARK: - title
    private let title: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = SFProRounded.set(fontSize: 17, weight: .heavy)
        l.textAlignment = .left
        l.textColor = .white
        return l
    }()
    
    // MARK: Page Control
    let pageControl: UIPageControl = {
       let pc = UIPageControl()
        pc.numberOfPages = 4
        pc.isUserInteractionEnabled = false
        return pc
    }()
    
    // MARK: - icon
    private let icon: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.tintColor = AppColors.primary
        iv.isUserInteractionEnabled = false
        return iv
    }()
    
    // MARK: Content ScrollView
    private let contentScrollView: UIScrollView = {
       let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.showsHorizontalScrollIndicator = false
        sv.showsVerticalScrollIndicator = false
        return sv
    }()
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Style
        self.backgroundColor = AppColors.gray6
        // Border
        self.layer.cornerRadius = 40
        // Setup
        setupStack()
        
        self.contentScrollView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Set up Stack
    private func setupStack() {
        
        let cellWidth = self.frame.size.width - 32
        
        contentScrollView.contentSize = CGSize(width: cellWidth*4, height: 80)
        contentScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        contentScrollView.isPagingEnabled = true
        
        // MARK: Screens slide
        for slide in 0..<4 {
            
            if slide == 0 {
                let page = CellSideView(
                    frame: CGRect( x: CGFloat(slide) * cellWidth, y: 0, width: cellWidth, height: 92),
                    title: "Includes 3-day free trial",
                    iconName: "sparkle"
                )
                contentScrollView.addSubview(page)
            }
            if slide == 1 {
                let page = CellSideView(
                    frame: CGRect( x: CGFloat(slide) * cellWidth, y: 0, width: cellWidth, height: 92),
                    title: "Unlimited banners",
                    iconName: "rectangle.stack.fill"
                )
                contentScrollView.addSubview(page)
            }
            if slide == 2 {
                let page = CellSideView(
                    frame: CGRect( x: CGFloat(slide) * cellWidth, y: 0, width: cellWidth, height: 92),
                    title: "Unlock all colors and styles",
                    iconName: "lock.open.fill"
                )
                contentScrollView.addSubview(page)
            }
            if slide == 3 {
                let page = CellSideView(
                    frame: CGRect( x: CGFloat(slide) * cellWidth, y: 0, width: cellWidth, height: 92),
                    title: "Access to all settings",
                    iconName: "slider.horizontal.3"
                )
                contentScrollView.addSubview(page)
            }
        }
        
        // MARK: - content Stack
        let contentStack = UIStackView(arrangedSubviews: [contentScrollView,pageControl,ctaButton])
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.axis = .vertical
        contentStack.alignment = .fill
        contentStack.spacing = 20
        
        self.addSubview(contentStack)
        
        NSLayoutConstraint.activate([
                        
            contentScrollView.leadingAnchor.constraint(equalTo: contentStack.leadingAnchor, constant: 0),
            contentScrollView.trailingAnchor.constraint(equalTo: contentStack.trailingAnchor, constant: 0),

            contentStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            contentStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            
        ])
    }
}

class CellSideView: UIView {
    
    // MARK: - icon
    private let icon: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.tintColor = AppColors.primary
        iv.isUserInteractionEnabled = false
        return iv
    }()
    
    // MARK: - title
    private let title: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = SFProRounded.set(fontSize: 20, weight: .heavy)
        l.textAlignment = .left
        l.textColor = AppColors.primary
        return l
    }()
    
    // MARK: - Init
    init(frame: CGRect, title: String, iconName: String) {
        super.init(frame: frame)
        
        self.title.text = title
        self.icon.image = UIImage(systemName: iconName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .bold))
        
        setupStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Set up Stack
    private func setupStack() {
        
        let contentStack = UIStackView(arrangedSubviews: [icon,title])
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.axis = .vertical
        contentStack.alignment = .center
        contentStack.spacing = 8
        
        self.addSubview(contentStack)
        
        NSLayoutConstraint.activate([
            
            self.heightAnchor.constraint(equalToConstant: 92),
            
            contentStack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            contentStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            contentStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
        ])
    }
    
}


// MARK: UIScrollViewDelegate
extension PromoCVCell: UIScrollViewDelegate {
    // для pagecontrol перключения через свайп
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(floorf(Float(contentScrollView.contentOffset.x) / Float(contentScrollView.frame.size.width)))
    }
}
