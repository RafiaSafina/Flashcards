//
//  CardsViewController.swift
//  Flashcards
//
//  Created by Рафия Сафина on 26.03.2023.
//

import UIKit

class TestViewController: UIViewController {
    
    private var passedWords: [Word] = []
    private var wordToLearn: [Word] = []
    
    private var myWords: [Word] = []
    private var dictWionary: [Word] = []
    private var allWords: [Word] = []
    private var filteredWords: [Word] = []
    
    private let isSwiped = true
    
    private var previousWordsCount: Int {
        1
    }
    
    private lazy var cardView: CardView = {
        let view = CardView()
        view.configure(name: filteredWords[0].name!,
                           translation: filteredWords[0].translation!)
        view.addGestureRecognizer(panGesture)
        return view
    }()
    
    private lazy var panGesture: UIPanGestureRecognizer = {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        return pan
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.text = "\(previousWordsCount)/\(filteredWords.count)"
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var leftButton: UIButton = {
        let button = UIButton(type: .system)
        button.bounds.size.width = 50
        button.bounds.size.height = 50
        button.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var rightButton: UIButton = {
        let button = UIButton(type: .system)
        button.bounds.size.width = 50
        button.bounds.size.height = 50
        button.setImage(UIImage(systemName: "arrow.right"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        fetchData()
        filteredWords = myWords
        setupLayout()
    }
    
    
    @objc private func didPan() {
        guard let card = panGesture.view else { return }
        let point = panGesture.translation(in: view)
        card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
        
        let linePosition = view.frame.width / 3
        
        if panGesture.state == .ended {
            
            if card.center.x < linePosition {
                UIView.animate(withDuration: 0.3) {
                    card.center = CGPoint(x: card.center.x -  self.view.frame.maxX, y: card.center.y)
                }
                return
            } else if card.center.x > linePosition {
                UIView.animate(withDuration: 0.3) {
                    card.center = CGPoint(x: card.center.x +  self.view.frame.maxX , y: card.center.y)
                }
                return
            }
            UIView.animate(withDuration: 0.2) { [unowned self] in
                card.center = self.view.center
            }
        }
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(view.frame.height - 200))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 5)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    @objc private func leftButtonTapped() {
        UIView.animate(withDuration: 0.3) {
            self.cardView.center = CGPoint(x: self.cardView.center.x - self.view.frame.maxX , y: self.cardView.center.y)
        }
    }
    
    @objc private func rightButtonTapped() {
        UIView.animate(withDuration: 0.3) {
            self.cardView.center = CGPoint(x: self.cardView.center.x + self.view.frame.maxX , y: self.cardView.center.y)
        }
    }
    
    private func fetchData() {
        CoreDataManager.shared.fetchData { [unowned self] result in
            switch result {
            case .success(let words):
                self.myWords = words
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func setupLayout() {
        view.addSubview(cardView)
        view.addSubview(leftButton)
        view.addSubview(rightButton)
        view.addSubview(countLabel)
        
        NSLayoutConstraint.activate([
            countLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            countLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            cardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cardView.widthAnchor.constraint(equalToConstant: view.frame.size.width - 60),
            cardView.heightAnchor.constraint(equalToConstant: view.frame.size.height - 260),
            
            leftButton.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 20),
            leftButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            leftButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            
            rightButton.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 20),
            rightButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            rightButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
    }
}

