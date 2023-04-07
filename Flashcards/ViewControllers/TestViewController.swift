//
//  CardsViewController.swift
//  Flashcards
//
//  Created by Рафия Сафина on 26.03.2023.
//

import UIKit

protocol SwipeCardsDataSource: AnyObject {
    func numberOfCardsToShow() -> Int
    func showCard(at index: Int) -> CardView
    func update(word: Word, isLearnt: Bool)
    func countPreviousWords()
}

class TestViewController: UIViewController {
    
    private var wordsToLearn: [Word] = []
    
    private lazy var totalWords = wordsToLearn.count
    private var previousWordsCount = 0 

    private lazy var countLabel: TranslationLabel = {
        let label = TranslationLabel()
        label.text = "\(previousWordsCount)/\(totalWords)"
        return label
    }()
    
    private var stackContainerView = StackContainerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        wordsToLearn = filterData()
        setupLayout()
        view.backgroundColor = .white
        stackContainerView.dataSource = self
    }
    
    private func fetchData() {
        
    }
    
    private func filterData() -> [Word] {
        let wordsToLearn = TemporaryData.testWords.filter { word in
           word.isLearnt == false
        }
        return wordsToLearn
    }
}
//MARK: - Set UI
extension TestViewController {
    private func setupLayout() {
        view.addSubview(stackContainerView)
        view.addSubview(countLabel)
        
        NSLayoutConstraint.activate([
            countLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            countLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stackContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/4),
            stackContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 2/3)
        ])
    }
}
//MARK: - SwipeCardsDataSource
extension TestViewController: SwipeCardsDataSource {
    func countPreviousWords() {
        previousWordsCount += 1
        countLabel.text = "\(previousWordsCount)/\(totalWords)"
    }
    
    func update(word: Word, isLearnt: Bool) {
        StorageManager.shared.updateStatus(word, isLearnt: isLearnt)
    }
    
    func numberOfCardsToShow() -> Int {
        wordsToLearn.count
    }
    
    func showCard(at index: Int) -> CardView {
        let card = CardView()
        card.dataSourse = wordsToLearn[index]
        return card
    }
}

