//
//  BaseView.swift
//  Flashcards
//
//  Created by Рафия Сафина on 30.03.2023.
//

import UIKit

extension UIView {
    func configureBaseView() {
        self.backgroundColor = .white
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 10.0
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension UILabel {
    func configureLabel(fontWight: UIFont.Weight) {
        self.numberOfLines = 0
        self.font = UIFont.systemFont(ofSize: 20, weight: fontWight)
        self.textColor = .black
        self.textAlignment = .center
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}




