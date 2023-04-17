//
//  NewWordViewController.swift
//  Flashcards
//
//  Created by Рафия Сафина on 13.04.2023.
//

import UIKit
 
protocol PassDataDelegate: AnyObject {
    func receiveData(word: String, translation: String) 
}

class NewWordViewController: UIViewController {
    
    private let cardView = StaticCardView()
    
    private var word: String?
    private var translation: String?
    
    private lazy var exitButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(goToRoot), for: .touchUpInside)
        button.setImage(UIImage(systemName: Constants.Images.xmark), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.String.cancelButtonTitle, for: .normal)
        button.tintColor = .black
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
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
    
    @objc private func saveButtonTapped() {
        print("save")
    }
    
    private func configure() {
        guard let word = word, let translation = translation else { return }
        cardView.configure(word: word, translation: translation)
    }
    
    private func setupLayout() {
        view.addSubview(cardView)
        cardView.addSubview(exitButton)
        cardView.addSubview(saveButton)
     
        NSLayoutConstraint.activate([
            exitButton.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 20),
            exitButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            
            saveButton.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            saveButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -20),
            
            cardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cardView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/4),
            cardView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 2/3)
        ])
    }
}

extension NewWordViewController: PassDataDelegate {
    func receiveData(word: String, translation: String) {
        self.word = word
        self.translation = translation
    }
}
