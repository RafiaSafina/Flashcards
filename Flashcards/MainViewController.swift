//
//  ViewController.swift
//  Flashcards
//
//  Created by Рафия Сафина on 12.03.2023.
//

import UIKit

final class MainViewController: UIViewController {

     var filteredWords: [Word] = []
     var allWords = TestingData().words
     var categories = TestingData().categories
    
    private let menuBar: MenuBar = {
        let menuBar = MenuBar()
        menuBar.translatesAutoresizingMaskIntoConstraints = false
        return menuBar
    }()
    
    private let wordsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0)
        collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.reuseIdentifier)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setNavigationBar()
        wordsCollectionView.delegate = self
        wordsCollectionView.dataSource = self
        setLayout()
        filteredWords = allWords
    }
    
    private func setNavigationBar() {
        navigationController?.navigationBar.showsLargeContentViewer = false
        navigationController?.hidesBarsOnSwipe = true
        
        title = "Idioms"
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        navBarAppearance.backgroundColor = .systemBlue
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
    }
    
    private func setLayout() {
        view.addSubview(wordsCollectionView)
        view.addSubview(menuBar)
        
        guard let navBarHeight = navigationController?.navigationBar.frame.minY  else { return }
        
        NSLayoutConstraint.activate([
            menuBar.topAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: navBarHeight),
            menuBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            menuBar.heightAnchor.constraint(equalToConstant: 60),
            
            wordsCollectionView.topAnchor.constraint(equalTo: menuBar.bottomAnchor),
            wordsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            wordsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            wordsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
//MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        allWords.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = wordsCollectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.reuseIdentifier, for: indexPath) as? MainCollectionViewCell else { return UICollectionViewCell() }
        let word = allWords[indexPath.item].name
        cell.configure(text: word)
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayaut: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            CGSize(width: UIScreen.main.bounds.width - 30, height: 120)
    }
}




