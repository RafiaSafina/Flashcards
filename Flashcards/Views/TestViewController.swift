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
}

protocol SwipeCardsDelegate: AnyObject {
    func swipeDidEnd(on view: CardView)
}

class TestViewController: UIViewController {
    
    private var myWords: [Word] = []
    private var filteredWords: [Word] = []
    
    private var previousWordsCount: Int {
        1
    }
    
    private var stackContainerView: StackContainerView = {
        let view = StackContainerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
        
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.text = "\(previousWordsCount)/\(filteredWords.count)"
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        fetchData()
        filteredWords = myWords
        setupLayout()
        stackContainerView.dataSource = self
    }
    
    private func fetchData() {
        StorageManager.shared.fetchData { [unowned self] result in
            switch result {
            case .success(let words):
                self.myWords = words
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
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
    func numberOfCardsToShow() -> Int {
        filteredWords.count
    }
    
    func showCard(at index: Int) -> CardView {
        let card = CardView()
        card.dataSourse = filteredWords[index]
        return card
    }
}

