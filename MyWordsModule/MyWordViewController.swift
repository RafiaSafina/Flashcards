//
//  NewWordViewController.swift
//  Flashcards
//
//  Created by Рафия Сафина on 13.04.2023.
//

import UIKit

class MyWordViewController: UIViewController {
    
    var presenter: NewWordPresenterProtocol
    weak var delegate: DataUpdateDelegate?
    
    private var isSelected = false
    private var isUpdating = false
    
    private let cardView: CardView = {
        let view = CardView()
        view.layer.shadowColor = UIColor.clear.cgColor
        return view
    }()
    
    private let favoriteView = CircleView()
    private let exitView = CircleView()
    
    private lazy var buttonsStackView: UIStackView = {
        let view = UIStackView()
        view.alignment = .fill
        view.distribution = .fillEqually
        view.axis = .horizontal
        view.spacing = 8
        view.addArrangedSubview(favoriteView)
        view.addArrangedSubview(exitView)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var textFieldsStackView: UIStackView = {
        let view = UIStackView()
        view.alignment = .fill
        view.distribution = .fillEqually
        view.axis = .vertical
        view.spacing = 20
        view.addArrangedSubview(wordTF)
        view.addArrangedSubview(translationTF)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: Constants.Images.heart), for: .normal)
        button.addTarget(self, action: #selector(didTapFavorite), for: .touchUpInside)
        return button
    }()
    
    private lazy var exitButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(goToRoot), for: .touchUpInside)
        button.setImage(UIImage(named: Constants.Images.xmark), for: .normal)
        return button
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 20
        button.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        button.layer.cornerCurve = .circular
        button.backgroundColor = Constants.Color.accentColor
        button.setTitle(Constants.String.saveButtonTitle, for: .normal)
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var wordTF: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.configureTF(fontWeight: .bold)
        textField.becomeFirstResponder()
        return textField
    }()
    
    private let translationTF: UITextField = {
        let textField = UITextField()
        textField.configureTF(fontWeight: .regular)
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupLayout()
        favoriteView.isHidden = true
        presenter.setWord()
        presenter.updateInterface()
        presenter.setStatus()
    }
    
    init(presenter: NewWordPresenterProtocol, delegate: DataUpdateDelegate) {
        self.presenter = presenter
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    init(presenter: NewWordPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError(Constants.String.initError)
    }
    
    @objc private func goToRoot() {
        presenter.goBackToRoot()
    }
    
    @objc private func didTapFavorite() {
        isSelected  = !isSelected
        isSelected
        ? favoriteButton.setImage(UIImage(named: Constants.Images.filledHeart), for: .normal)
        : favoriteButton.setImage(UIImage(named: Constants.Images.heart), for: .normal)
    }
    
    @objc private func saveButtonTapped() {
        guard let word = wordTF.text,
              let translation = translationTF.text else { return }
        
        isUpdating
        ? updateWord(word: word, translation: translation)
        :  createNewWord(word: word, translation: translation)

        presenter.goBackToRoot()
    }
    
    private func updateWord(word: String, translation: String) {
        presenter.update(newName: word, newTranslation: translation)
        delegate?.reloadData()
    }
    
    private func createNewWord(word: String, translation: String) {
        presenter.create(word: word, translation: translation)
        guard let word = presenter.word else { return }
        delegate?.insertItem(word: word)
    }
    
    private func setupLayout() {
        view.addSubview(cardView)
        cardView.addSubview(buttonsStackView)
        cardView.addSubview(textFieldsStackView)
        cardView.addSubview(exitButton)
        cardView.addSubview(saveButton)
        favoriteView.addSubview(favoriteButton)
        exitView.addSubview(exitButton)

        favoriteButton.pinEdgesToSuperView()
        exitButton.pinEdgesToSuperView()
        
        NSLayoutConstraint.activate([
            buttonsStackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            
            textFieldsStackView.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            textFieldsStackView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            
            exitButton.heightAnchor.constraint(equalToConstant: exitView.frame.width),
            exitButton.widthAnchor.constraint(equalToConstant: exitView.frame.width),
            
            favoriteButton.heightAnchor.constraint(equalToConstant: favoriteView.frame.width),
            favoriteButton.widthAnchor.constraint(equalToConstant: favoriteView.frame.width),

            saveButton.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            saveButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor),
            saveButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            saveButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            
            cardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cardView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/4),
            cardView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 2/3)
        ])
    }
}

//MARK: - NewWordViewProtocol
extension MyWordViewController: NewWordViewProtocol {
    func showButton() {
        favoriteView.isHidden = false
    }
    
    func setUpdatingStatus() {
        isUpdating = true
    }
    
    func setWord(word: Word) {
        wordTF.text = word.name
        translationTF.text = word.translation
    }
}
