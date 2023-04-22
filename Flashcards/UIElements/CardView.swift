//
//  CardView.swift
//  Flashcards
//
//  Created by Рафия Сафина on 18.04.2023.
//

import UIKit

class CardView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Constants.Color.cellColor
        self.layer.shadowColor = Constants.Color.shadowColor.cgColor
        self.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 20.0
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError(Constants.String.initError)
    }
}
