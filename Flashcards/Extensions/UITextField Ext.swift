//
//  BaseView.swift
//  Flashcards
//
//  Created by Рафия Сафина on 30.03.2023.
//

import UIKit

extension UITextField {
    func configureTF(fontWeight: UIFont.Weight) {
        self.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        self.textColor = Constants.Color.fontColor
        self.borderStyle = .none
        
        var bottomLine = CALayer()
        bottomLine.backgroundColor = UIColor.white.cgColor
        bottomLine.frame = CGRect(x: 0.0,
                                  y: self.frame.height - 1,
                                  width: self.frame.width,
                                  height: 1.0)

        self.layer.addSublayer(bottomLine)
    }
}




