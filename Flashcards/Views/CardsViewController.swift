//
//  CardsViewController.swift
//  Flashcards
//
//  Created by Рафия Сафина on 26.03.2023.
//

import UIKit

class CardsViewController: UIViewController {

    private var myWords: [Word] = []
    private var isFlipped = false
    
    private let horintalCardsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 40
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CardsCollectionViewCell.self, forCellWithReuseIdentifier: CardsCollectionViewCell.cellID)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        fetchData()
        horintalCardsCollectionView.delegate = self
        horintalCardsCollectionView.dataSource = self
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
        view.addSubview(horintalCardsCollectionView)
        
        NSLayoutConstraint.activate([
            horintalCardsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            horintalCardsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            horintalCardsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            horintalCardsCollectionView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
}
//MARK: - UICollectionViewDelegateFlowLayout
extension CardsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        myWords.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = horintalCardsCollectionView.dequeueReusableCell(withReuseIdentifier: CardsCollectionViewCell.cellID, for: indexPath) as? CardsCollectionViewCell else { return UICollectionViewCell() }
        guard let name = myWords[indexPath.item].name else { return UICollectionViewCell() }
        guard let translation = myWords[indexPath.item].translation else { return UICollectionViewCell() }
        cell.configure(name: name, translation: translation)
        
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension CardsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 50, height: 160)
    }
}
