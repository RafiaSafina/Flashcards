//
//  CardsViewController.swift
//  Flashcards
//
//  Created by Рафия Сафина on 26.03.2023.
//

import UIKit

protocol SwipeCardsDataSource: AnyObject {
    func numberOfCardsToShow() -> Int
    func showCard(at index: Int) -> SwipeCardView
    func update(word: Word, isLearnt: Bool)
    func countPreviousWords()
    func countAnswers(isRightAnswer: Bool)
}

class TestViewController: UIViewController {
    
    var presenter: TestPresenterProtocol
    
    private var wordsToLearn: [Word] = []
    
    private lazy var totalWords = wordsToLearn.count
    private var previousWordsCount = 0
    
    private var wrongAnswers = 0
    private var rightAnswers = 0
    
    private lazy var wrongAnswerLabel: TranslationLabel = {
        let label = TranslationLabel()
        label.text = String(wrongAnswers)
        label.textColor = .systemRed
        return label
    }()
    
    private lazy var rightAnswerLabel: TranslationLabel = {
        let label = TranslationLabel()
        label.text = String(rightAnswers)
        label.textColor = .systemGreen
        return label
    }()
    
    private var stackContainerView = StackContainerView()
    
    private lazy var restartButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 20)
        button.tintColor = .accentColor
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        button.setTitle("Restart", for: .normal)
        button.addTarget(self, action: #selector(didTapRestartButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wordsToLearn = presenter.words ?? []
        setupLayout()
        setupNavigationBar()
        view.backgroundColor = Constants.Color.backgroundColor
        stackContainerView.dataSource = self
    }
    
    init(presenter: TestPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError(Constants.String.initError)
    }
    
    @objc private func didTapRestartButton() {
        print()
    }
    
    @objc private func backToRoot() {
        presenter.goBactToRoot()
    }
}

//MARK: - Set UI
extension TestViewController {
    
    private func setupNavigationBar() {
        let previousWordsCount = String(previousWordsCount)
        let totalWords = String(totalWords)
        
        title = previousWordsCount + "/" + totalWords
        
        let leftBarItem = UIBarButtonItem(image: UIImage(systemName: Constants.Images.xmark), style: .plain, target: self, action: #selector(backToRoot))
        leftBarItem.tintColor = Constants.Color.accentColor
        
        navigationItem.leftBarButtonItem = leftBarItem
    }
    
    private func setupLayout() {
        view.addSubview(stackContainerView)
        view.addSubview(wrongAnswerLabel)
        view.addSubview(rightAnswerLabel)
        view.addSubview(restartButton)
        
        NSLayoutConstraint.activate([
            wrongAnswerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            wrongAnswerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            rightAnswerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            rightAnswerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            stackContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/4),
            stackContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 2/3),
            
            restartButton.topAnchor.constraint(equalTo: stackContainerView.bottomAnchor, constant: 40),
            restartButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
//MARK: - SwipeCardsDataSource
extension TestViewController: SwipeCardsDataSource {
    func countAnswers(isRightAnswer: Bool) {
        
        if isRightAnswer == true {
            rightAnswers += 1
            rightAnswerLabel.text = String(rightAnswers)
        } else {
            wrongAnswers += 1
            wrongAnswerLabel.text = String(wrongAnswers)
        }
    }
    
    func countPreviousWords() {
        previousWordsCount += 1
        let prevWordsCount = String(previousWordsCount)
        let totalWords = String(totalWords)
        title = prevWordsCount + "/" + totalWords
    }
    
    func update(word: Word, isLearnt: Bool) {
        presenter.saveWord(word: word, isLearnt: isLearnt)
    }
    
    func numberOfCardsToShow() -> Int {
        wordsToLearn.count
    }
    
    func showCard(at index: Int) -> SwipeCardView {
        let card = SwipeCardView()
        card.dataSourse = wordsToLearn[index]
        return card
    }
}

//MARK: - TestViewProtocol
extension TestViewController: TestViewProtocol {}

