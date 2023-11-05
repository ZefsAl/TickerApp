//
//  RegularTextField.swift
//  TickerApp
//
//  Created by Serj on 05.10.2023.
//

import UIKit

final class RegularTextField: UITextField {
    
    // MARK: init
    init(frame: CGRect, setPlaceholder: String) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        // Delegate
        delegate = self
        // Style
        layer.cornerRadius = 16
        self.backgroundColor = AppColors.gray5 // BG - Важно!
        // Text, Style
        attributedPlaceholder = NSAttributedString(
            string: setPlaceholder,
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                NSAttributedString.Key.font: SFProRounded.set(fontSize: 17, weight: .semibold)
            ]);
        font = SFProRounded.set(fontSize: 17, weight: .semibold)
        textColor = .white;
        tintColor = AppColors.primary;
        
        
        self.clearButtonMode = .whileEditing
        // Margins inside
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        leftViewMode = .always
        
        self.heightAnchor.constraint(equalToConstant: 50).isActive = true

        // keyboard
//        self.keyboardType = .asciiCapable // Eng
        self.regularAccessoryViewOnKeyboard()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Delegate, Animate
extension RegularTextField: UITextFieldDelegate {
}

// MARK: Extension Accessory View
extension RegularTextField {

    func regularAccessoryViewOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        doneToolbar.backgroundColor = .systemGray5

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.doneButtonAction))
        done.tintColor = .white

        let items = [flexSpace, done]
        doneToolbar.items = items

        doneToolbar.sizeToFit()

        self.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction() {
        self.endEditing(true)
    }
}
