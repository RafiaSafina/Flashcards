//
//  HeaderCollectionReusableView.swift
//  Flashcards
//
//  Created by Рафия Сафина on 28.03.2023.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {
    
    weak var delegate: MainViewControllerDelegate?
    
    private lazy var learnButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(learnButtonPressed), for: .touchUpInside)
        button.setTitle(Constants.String.learnButtonTitle, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        button.setTitleColor(Constants.Color.accentColor, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        button.setImage(UIImage(systemName: Constants.Images.plus), for: .normal)
        button.tintColor = UIColor.accentColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .backgroundColor
    }
    
    required init?(coder: NSCoder) {
        fatalError(Constants.String.initError)
    }
    
    @objc private func learnButtonPressed() {
        delegate?.goToTestViewController()
    }
    
    @objc private func addButtonPressed() {
        delegate?.addNewWord()
    }
    
    override func layoutSubviews() {
        addSubview(learnButton)
        addSubview(addButton)
        
        NSLayoutConstraint.activate([
            learnButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            learnButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 34),
            
            addButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            addButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -34)
        ])
    }
}


