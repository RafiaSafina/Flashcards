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
        self.textColor = .black
        self.clipsToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}




