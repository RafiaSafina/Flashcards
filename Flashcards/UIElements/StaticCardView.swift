//
//  StaticCardView.swift
//  Flashcards
//
//  Created by Рафия Сафина on 15.04.2023.
//

import UIKit

class StaticCardView: UIView {
    
    private let wordTextField: UITextField = {
        let textfield = UITextField()
        textfield.configureTF(fontWeight: .bold,
                              textAlignment: .left)
        return textfield
    }()
    
    private let translationTextField: UITextField = {
        let textfield = UITextField()
        textfield.configureTF(fontWeight: .regular,
                              textAlignment: .left)
        return textfield
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.addArrangedSubview(wordTextField)
        stack.addArrangedSubview(translationTextField)
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .fill
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureBaseView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError(Constants.String.initError)
    }
    
    func configure(word: String, translation: String) {
        wordTextField.text = word
        translationTextField.text = translation
    }
    
    private func setupLayout() {
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
}
