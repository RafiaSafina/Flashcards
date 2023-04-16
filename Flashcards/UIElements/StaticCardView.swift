//
//  StaticCardView.swift
//  Flashcards
//
//  Created by Рафия Сафина on 15.04.2023.
//

import UIKit

class StaticCardView: UIView {
    
    private let wordLabel: UILabel = {
        let label = UILabel()
        label.configureLabel(fontWight: .bold)
        return label
    }()
    
    private let translationLabel: UILabel = {
        let label = UILabel()
        label.configureLabel(fontWight: .medium)
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.addArrangedSubview(wordLabel)
        stack.addArrangedSubview(translationLabel)
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
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(word: String, translation: String) {
        wordLabel.text = word
        translationLabel.text = translation
    }
    
    private func setupLayout() {
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
