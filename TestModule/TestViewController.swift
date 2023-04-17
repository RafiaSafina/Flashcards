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
    func countWrongAnswers()
    func countRightAnswers()
}

class TestViewController: UIViewController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wordsToLearn = filterData()
        setupLayout()
        setupNavigationBar()
        view.backgroundColor = .white
        stackContainerView.dataSource = self
    }
    
    private func filterData() -> [Word] {
        let wordsToLearn = TemporaryData.testWords.filter { word in
           word.isLearnt == false
        }
        return wordsToLearn
    }
    
    @objc private func backToRoot() {
        navigationController?.popToRootViewController(animated: true)
    }
}
//MARK: - Set UI
extension TestViewController {
    
    private func setupNavigationBar() {
        let previousWordsCount = String(previousWordsCount)
        let totalWords = String(totalWords)
        
        title = previousWordsCount + "/" + totalWords
        
        let leftBarItem = UIBarButtonItem(image: UIImage(systemName: Constants.Images.xmark), style: .plain, target: self, action: #selector(backToRoot))
        leftBarItem.tintColor = .systemPink.withAlphaComponent(0.3)
        
        navigationItem.leftBarButtonItem = leftBarItem
    }
    
    private func setupLayout() {
        view.addSubview(stackContainerView)
        view.addSubview(wrongAnswerLabel)
        view.addSubview(rightAnswerLabel)
        
        NSLayoutConstraint.activate([
            wrongAnswerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            wrongAnswerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            rightAnswerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            rightAnswerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            stackContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/4),
            stackContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 2/3)
        ])
    }
}
//MARK: - SwipeCardsDataSource
extension TestViewController: SwipeCardsDataSource {
    func countWrongAnswers() {
        wrongAnswers += 1
        wrongAnswerLabel.text =  String(wrongAnswers)
    }
    
    func countRightAnswers() {
        rightAnswers += 1
        rightAnswerLabel.text = String(rightAnswers)
    }
    
    func countPreviousWords() {
        previousWordsCount += 1
        let prevWordsCount = String(previousWordsCount)
        let totalWords = String(totalWords)
        title = prevWordsCount + totalWords
    }
    
    func update(word: Word, isLearnt: Bool) {
        StorageManager.shared.updateStatus(word, isLearnt: isLearnt)
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

