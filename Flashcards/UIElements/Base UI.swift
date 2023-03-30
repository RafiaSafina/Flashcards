//
//  Base UI.swift
//  Flashcards
//
//  Created by Рафия Сафина on 31.03.2023.
//

import UIKit

//MARK: _ Labels
class WordLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLabel(fontWight: .bold)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TranslationLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLabel(fontWight: .regular)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Views
class FrontView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureBaseView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BackView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureBaseView()
        isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
