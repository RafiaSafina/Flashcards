//
//  Base UI.swift
//  Flashcards
//
//  Created by Рафия Сафина on 31.03.2023.
//

import UIKit

class WordLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLabel(fontWight: .bold)
    }
    
    required init?(coder: NSCoder) {
        fatalError(Constants.String.initError)
    }
}
