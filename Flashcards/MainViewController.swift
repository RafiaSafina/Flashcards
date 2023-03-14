//
//  ViewController.swift
//  Flashcards
//
//  Created by Рафия Сафина on 12.03.2023.
//

import UIKit

final class MainViewController: UIViewController {

    private var filteredWords: [Word] = []
    private var allWords = TestingData.words
    private var categories = TestingData.categories
    
    private let wordsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.reuseIdentifier)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private var categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.reuseIdentifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setNavigationBar()
        wordsCollectionView.delegate = self
        wordsCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        setLayout()
    }
    
    private func setNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.showsLargeContentViewer = false
        title = "Idioms"
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.gray]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.gray]
        navBarAppearance.backgroundColor = .clear
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
    
    private func setLayout() {
        view.addSubview(wordsCollectionView)
        view.addSubview(categoryCollectionView)
        
        NSLayoutConstraint.activate([
            categoryCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoryCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoryCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            categoryCollectionView.heightAnchor.constraint(equalToConstant: 30),
            
            wordsCollectionView.topAnchor.constraint(equalTo: categoryCollectionView.topAnchor, constant: 50),
            wordsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            wordsCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            wordsCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
}
//MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCollectionView {
            return categories.count
        } else {
            return allWords.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryCollectionView {
            guard let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseIdentifier, for: indexPath) as? CollectionViewCell else { return UICollectionViewCell() }
            let name = categories[indexPath.item].name
            let isSelected = categories[indexPath.item].isSelected
            cell.configure(with: name, isSelected: isSelected)
            return cell
        } else {
            guard let cell = wordsCollectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.reuseIdentifier, for: indexPath) as? MainCollectionViewCell else { return UICollectionViewCell() }
            let word = allWords[indexPath.item].name
            cell.configure(text: word)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var isSelected = categories[indexPath.item].isSelected
        isSelected = !isSelected
        
       print(isSelected)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayaut: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoryCollectionView {
            let categoryFont = UIFont.systemFont(ofSize: 14)
            let categoryAttributes = [NSAttributedString.Key.font: categoryFont as Any]
            let categoryWidth = categories[indexPath.item].name.size(withAttributes: categoryAttributes).width + 30
            return CGSize(width: categoryWidth, height: collectionView.frame.height)
        } else {
            return CGSize(width: UIScreen.main.bounds.width - 30, height: 120)
        }
        
    }
}




