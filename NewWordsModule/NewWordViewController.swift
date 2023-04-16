//
//  NewWordViewController.swift
//  Flashcards
//
//  Created by Рафия Сафина on 13.04.2023.
//

import UIKit

class NewWordViewController: UIViewController {
    
    var dictWord: Def?
    
    private let cardView = StaticCardView()
    
    private lazy var exitButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(goToRoot), for: .touchUpInside)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        button.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        button.addTarget(self, action: #selector(goToRoot), for: .touchUpInside)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupLayout()
        configure()
    }
    
    @objc private func goToRoot() {
        dismiss(animated: true)
    }
    
    private func configure() {
        guard let word = dictWord?.text else { return }
        guard let tr = dictWord?.tr[0].text else { return }
        cardView.configure(word: word, translation: tr)
    }
    
    private func setupLayout() {
        view.addSubview(cardView)
        cardView.addSubview(exitButton)
        cardView.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            exitButton.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 20),
            exitButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            
            addButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -20),
            addButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            addButton.widthAnchor.constraint(equalToConstant: 40),
            addButton.heightAnchor.constraint(equalToConstant: 40),
            
            cardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cardView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/4),
            cardView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 2/3)
        ])
    }
}
