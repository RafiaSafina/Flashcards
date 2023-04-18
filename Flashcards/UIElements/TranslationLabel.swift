//
//  TranslationLabel.swift
//  Flashcards
//
//  Created by Рафия Сафина on 18.04.2023.
//

import UIKit

class TranslationLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLabel(fontWight: .regular)
    }
    
    required init?(coder: NSCoder) {
        fatalError(Constants.String.initError)
    }
}
