//
//  ViewController.swift
//  Flashcards
//
//  Created by Рафия Сафина on 12.03.2023.
//

import UIKit

final class MainViewController: UIViewController {

    private var filteredWords: [Word] = []
    private var allWords = TestingData.words.shuffled()
    
    private var categories = TestingData.categories
    
    private let menuBarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBlue
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: MenuCell.cellID)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
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
    
    private let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .custom)
        button.bounds.size.width = 80
        button.bounds.size.height = 80
        button.layer.cornerRadius = button.bounds.size.width / 2
        button.layer.backgroundColor = UIColor.white.cgColor
        let image = UIImage(named: "plus")
        button.setImage(image, for: .normal)
        button.tintColor = .systemPink
        button.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filteredWords = allWords
        view.backgroundColor = .white
        setNavigationBar()
        setLayout()
        wordsCollectionView.delegate = self
        wordsCollectionView.dataSource = self
        menuBarCollectionView.delegate = self
        menuBarCollectionView.dataSource = self
        menuBarCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .left)
    }
    
    private func setNavigationBar() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        navBarAppearance.backgroundColor = .white
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonPressed)
        )
        addButton.tintColor = .systemPink.withAlphaComponent(0.5)
        navigationItem.rightBarButtonItem = addButton
        
    }
    
    @objc private func addButtonPressed() {
        print("newWord")
    }
    
    private func setLayout() {
        view.addSubview(wordsCollectionView)
        view.addSubview(menuBarCollectionView)
        view.addSubview(bottomView)
        bottomView.addSubview(addButton)
        
        guard let navBarHeight = navigationController?.navigationBar.frame.minY  else { return }
        
        NSLayoutConstraint.activate([
            menuBarCollectionView.topAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: navBarHeight),
            menuBarCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuBarCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            menuBarCollectionView.heightAnchor.constraint(equalToConstant: 60),
            
            wordsCollectionView.topAnchor.constraint(equalTo: menuBarCollectionView.bottomAnchor),
            wordsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            wordsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            wordsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/10),
            
            addButton.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor),
            addButton.centerYAnchor.constraint(equalTo: bottomView.topAnchor),
            addButton.heightAnchor.constraint(equalToConstant: 70),
            addButton.widthAnchor.constraint(equalToConstant: 70)
        ])
    }
}
//MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == wordsCollectionView {
            return filteredWords.count
        } else {
            return categories.count
        }
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == wordsCollectionView {
            guard let cell = wordsCollectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.reuseIdentifier, for: indexPath) as? MainCollectionViewCell else { return UICollectionViewCell() }
            let word = filteredWords[indexPath.item].name
            cell.configure(text: word)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuCell.cellID, for: indexPath) as? MenuCell else { return UICollectionViewCell() }
            cell.configure(text: categories[indexPath.item].name)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == menuBarCollectionView {
            let category = categories[indexPath.item].name
            switch indexPath.item {
            case 0:
                filteredWords = allWords
                wordsCollectionView.reloadData()
            default:
                filteredWords = allWords.filter {$0.category.name == category}
                wordsCollectionView.reloadData()
            }
        }
    }
}
//MARK: - UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayaut: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == wordsCollectionView {
            return CGSize(width: UIScreen.main.bounds.width - 30, height: 120)
        } else {
            return CGSize(width: UIScreen.main.bounds.width / 3, height: 60)
        }
    }
}
//MARK: - UImage().resize
extension UIImage {
    func resize(targetSize: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: targetSize).image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}




