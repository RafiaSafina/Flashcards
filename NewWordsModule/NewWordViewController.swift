//
//  NewWordViewController.swift
//  Flashcards
//
//  Created by Рафия Сафина on 13.04.2023.
//

import UIKit
 
protocol PassDataDelegate: AnyObject {
    func receiveData(word: String?, translation: String?)
}

class NewWordViewController: UIViewController {
    
    private var word: String?
    private var translation: String?
    
    private var isHidden: Bool?
    
    private let cardView = CardView()
    
    private let wordTF: UITextField = {
        let tf = UITextField()
        tf.configureTF(fontWeight: .bold)
        return tf
    }()
    
    private let translationTF: UITextField = {
        let tf = UITextField()
        tf.configureTF(fontWeight: .regular)
        return tf
    }()
    
    private lazy var exitButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(goToRoot), for: .touchUpInside)
        button.setImage(UIImage(systemName: Constants.Images.xmark), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 20))
        button.layer.cornerRadius = button.frame.height / 2
        button.layer.cornerCurve = .circular
        button.layer.backgroundColor = UIColor.black.withAlphaComponent(0.2).cgColor
        button.setTitle(Constants.String.saveButtonTitle, for: .normal)
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: Constants.Images.heart)
        image?.withTintColor(.systemPink.withAlphaComponent(0.3))
        button.tintColor = .systemRed
        button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpOutside)
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupLayout()
        configure()
    }
    
    @objc private func favoriteButtonTapped() {
        print("favorite")
    }
    
    @objc private func goToRoot() {
        dismiss(animated: true)
    }
    
    @objc private func saveButtonTapped() {
        print("save")
    }
    
    private func configure() {
        guard let word = word, let translation = translation else { return }
        wordTF.text = word
        translationTF.text = translation
    }
    
    private func toggleVisibility() {
        
    }
    
    private func setupLayout() {
        view.addSubview(cardView)
        cardView.addSubview(exitButton)
        cardView.addSubview(saveButton)
        cardView.addSubview(favoriteButton)
     
        NSLayoutConstraint.activate([
            favoriteButton.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 10),
            favoriteButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -10),
            
            exitButton.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 20),
            exitButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            
            saveButton.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            saveButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -20),
            saveButton.widthAnchor.constraint(equalToConstant: saveButton.frame.width),
            
            cardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cardView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/4),
            cardView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 2/3)
        ])
    }
}

extension NewWordViewController: PassDataDelegate {
    func receiveData(word: String?, translation: String?) {
        self.word = word
        self.translation = translation
    }
}
