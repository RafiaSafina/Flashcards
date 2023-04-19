//
//  NewWordViewController.swift
//  Flashcards
//
//  Created by Рафия Сафина on 13.04.2023.
//

import UIKit

protocol ReloadDataDelegate: AnyObject {
    func reloadData()
}

class NewWordViewController: UIViewController {
    
    var presenter: NewWordPresenterProtocol
    
    weak var delegate: ReloadDataDelegate?
    
    private var isHidden: Bool?
    
    private let cardView = CardView()
    
    private lazy var wordTF: UITextField = {
        let tf = UITextField(frame: CGRect(x: 0, y: 0, width: cardView.frame.width, height: 20))
        tf.sizeToFit()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.configureTF(fontWeight: .bold)
        tf.becomeFirstResponder()
        return tf
    }()
    
    private let translationTF: UITextField = {
        let tf = UITextField()
        tf.configureTF(fontWeight: .regular)
        return tf
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .leading
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 20
        stack.addArrangedSubview(wordTF)
        stack.addArrangedSubview(translationTF)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupLayout()
        presenter.setWord()
    }
    
    init(presenter: NewWordPresenterProtocol, delegate: ReloadDataDelegate) {
        self.presenter = presenter
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    @objc private func goToRoot() {
        dismiss(animated: true)
    }
    
    @objc private func saveButtonTapped() {
        guard let word = wordTF.text, let translation = translationTF.text else { return }
        presenter.update(newName: word, newTranslation: translation)
        delegate?.reloadData()
        presenter.goBackToRoot()
    }
    
    private func setupLayout() {
        view.addSubview(cardView)
        cardView.addSubview(stackView)
        cardView.addSubview(exitButton)
        cardView.addSubview(saveButton)

     
        NSLayoutConstraint.activate([
            exitButton.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 20),
            exitButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            
            stackView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            
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

extension NewWordViewController: NewWordViewProtocol {
    func reloadData() {
       
    }
    
    func setWord(word: Word) {
        wordTF.text = word.name
        translationTF.text = word.translation
    }
}
