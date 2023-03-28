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
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.text = "\(previousWordsCount)/\(filteredWords.count)"
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
//        collectionView.isScrollEnabled = .
        collectionView.register(CardsCollectionViewCell.self, forCellWithReuseIdentifier: CardsCollectionViewCell.cellID)
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
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
        collectionView.delegate = self
        collectionView.dataSource = self
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
        print("left")
    }
    
    @objc private func rightButtonTapped() {
        print("right")
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
        view.addSubview(collectionView)
        view.addSubview(leftButton)
        view.addSubview(rightButton)
        view.addSubview(countLabel)
        
        NSLayoutConstraint.activate([
            countLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            countLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            collectionView.topAnchor.constraint(equalTo: countLabel.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            leftButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20),
            leftButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            leftButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            
            rightButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20),
            rightButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            rightButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension TestViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filteredWords.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardsCollectionViewCell.cellID, for: indexPath) as? CardsCollectionViewCell else { return UICollectionViewCell() }
        guard let name = filteredWords[indexPath.item].name else { return UICollectionViewCell() }
        guard let translation = filteredWords[indexPath.item].translation else { return UICollectionViewCell() }
        cell.configure(name: name, translation: translation, isSwiped: isSwiped)
        return cell
    }
}
//MARK: - UICollectionViewFlowLayout
extension TestViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: view.frame.width - 40, height: 600)
//    }
}

