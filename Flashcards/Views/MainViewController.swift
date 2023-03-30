//
//  ViewController.swift
//  Flashcards
//
//  Created by Рафия Сафина on 12.03.2023.
//

import UIKit

final class MainViewController: UIViewController {
    
    private var categories = TemporaryData.categories
    
    private var myWords: [Word] = []
    private var dictionaryWords: [Word] = []
    private var filteredWords: [Word] = []
    private lazy var allWords: [Word] = myWords + dictionaryWords
    
    private var isFlipped = true
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.setCollectionViewLayout(createLayout(), animated: true)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.reuseIdentifier)
        collectionView.register(CardsCollectionViewCell.self, forCellWithReuseIdentifier: CardsCollectionViewCell.cellID)
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: MenuCell.cellID)
        collectionView.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.reuseIdentifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        fetchData()
        filteredWords = allWords
        collectionView.collectionViewLayout = createLayout()
        setCellSelected() 
        setNavigationBar()
        setLayout()
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    @objc private func startButtonPressed() {
        let cardsVC = TestViewController()
        navigationController?.pushViewController(cardsVC, animated: true)
    }
    
    @objc private func addButtonPressed() {
        showAlert()
    }
}

//MARK: - CRUD
extension MainViewController {
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
    
    private func save(wordName: String, translation: String) {
        StorageManager.shared.create(wordName, translation: translation) { [unowned self] word in
            myWords.append(word)
            filteredWords.append(word)
            collectionView.insertItems(at: [IndexPath(item: filteredWords.count - 1, section: 0)])
        }
    }
    
    private func delete(word: Word) {
        StorageManager.shared.delete(word)
    }
}
    
//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        TemporaryData.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return categories.count
        case 1:
            return filteredWords.count
        default:
            return filteredWords.count
        }
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuCell.cellID, for: indexPath) as? MenuCell else { return UICollectionViewCell() }
            cell.configure(text: categories[indexPath.item])
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardsCollectionViewCell.cellID, for: indexPath) as? CardsCollectionViewCell else { return UICollectionViewCell() }
            guard let name = myWords[indexPath.item].name else { return UICollectionViewCell() }
            guard let translation = myWords[indexPath.item].translation else { return UICollectionViewCell() }
            cell.configure(name: name, translation: translation)
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.reuseIdentifier, for: indexPath) as? MainCollectionViewCell else { return UICollectionViewCell() }
            let word = filteredWords[indexPath.item]
            let name = word.name ?? ""
            let translation = word.translation ?? ""
            cell.configure(word: name, translation: translation)
            cell.deleteAction = { [weak self] in
                guard let word = self?.filteredWords.remove(at: indexPath.item) else { return }
                StorageManager.shared.delete(word)
                self?.collectionView.deleteItems(at: [indexPath])
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sectionIndex = indexPath.section
        
        if sectionIndex == 0 {
            switch indexPath.item {
            case 0:
                filteredWords = allWords
                collectionView.reloadData()
            case 1:
                filteredWords = myWords
                collectionView.reloadData()
            default:
                filteredWords = dictionaryWords
                collectionView.reloadData()
            }
        } else if sectionIndex == 2 {
            let word = filteredWords[indexPath.item]
            showAlert(word: word) {
                collectionView.reloadItems(at: [indexPath])
            }
        }

    }
    
    private func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCollectionReusableView.reuseIdentifier, for: indexPath) as? HeaderCollectionReusableView else { return UICollectionReusableView() }
        
        let title = TemporaryData.sectionTitles[indexPath.section]
        header.configure(title: title)
        return header
    }
    
    private func setCellSelected() {
        let itemIndex = IndexPath(item: 0, section: 0)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuCell.cellID, for: itemIndex) as? MenuCell else { return }
        cell.isSelected = true
    }
}
// MARK: - Alert Controller
extension MainViewController {
    
    private func showAlert(word: Word? = nil, completion: (() -> Void)? = nil) {
        let title = word != nil ? "Update Word" : "New Word"
        let alert = UIAlertController.createAlertController(withTitle: title)
        
        alert.action(word: word) { [weak self] wordName, translationName  in
            if let word = word, let completion = completion {
                StorageManager.shared.update(word, newName: wordName, newTranslation: translationName)
                completion()
            } else {
                self?.save(wordName: wordName, translation: translationName)
            }
        }
        present(alert, animated: true)
    }
}

//MARK: - setup UI
extension MainViewController {
    private func setNavigationBar() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.systemPink.withAlphaComponent(0.5)]
        navBarAppearance.backgroundColor = .white
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        let learnButton = UIBarButtonItem(
            title: "Learn",
            style: .plain,
            target: self,
            action: #selector(startButtonPressed)
        )
        
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonPressed)
        )
        
        learnButton.tintColor = .systemPink.withAlphaComponent(0.5)
        addButton.tintColor = .systemPink.withAlphaComponent(0.5)
        
        navigationItem.leftBarButtonItem = learnButton
        navigationItem.rightBarButtonItem = addButton
    }
    
    private func setLayout() {
        view.addSubview(collectionView)
        
        collectionView.frame = view.bounds
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [unowned self] sectionindex, layoutEnvironment in
            switch sectionindex {
            case 0:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.3),
                    heightDimension: .fractionalHeight(0.08))
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .paging
                section.interGroupSpacing = 10
                section.supplementariesFollowContentInsets = false
                return section
            case 1:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.85),
                    heightDimension: .fractionalHeight(0.4))
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPagingCentered
                section.interGroupSpacing = 10
                section.boundarySupplementaryItems = [self.supplementaryHeaderItem()]
                section.supplementariesFollowContentInsets = false
                return section
            default:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(0.08))
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                group.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .none
                section.interGroupSpacing = 10
                section.boundarySupplementaryItems = [self.supplementaryHeaderItem()]
                section.supplementariesFollowContentInsets = false
                return section
            }
        }
    }
    
    private func supplementaryHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.1)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
    }
}

