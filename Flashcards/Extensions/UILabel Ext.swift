//
//  UIlabel Extension.swift
//  Flashcards
//
//  Created by Рафия Сафина on 18.04.2023.
//

import UIKit

extension UILabel {
    func configureLabel(fontWight: UIFont.Weight) {
        self.numberOfLines = 0
        self.font = UIFont.systemFont(ofSize: 20, weight: fontWight)
        self.textColor = .black
        self.textAlignment = .center
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
