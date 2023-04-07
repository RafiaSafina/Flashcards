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
    private lazy var allWords = myWords + dictionaryWords
    
    private var filteredWords: [Word] = []
    
    private var isFlipped = true
    
    private lazy var menuCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .blue
        cv.isScrollEnabled = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(MenuCell.self, forCellWithReuseIdentifier: MenuCell.cellID)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private lazy var mainCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        cv.setCollectionViewLayout(createLayout(), animated: true)
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.reuseIdentifier)
        cv.register(CardsCollectionViewCell.self, forCellWithReuseIdentifier: CardsCollectionViewCell.cellID)
        cv.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.reuseIdentifier)
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        fetchData()
        filteredWords = allWords
        setNavigationBar()
        setLayout()
        setCellSelected()
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
            mainCollectionView.insertItems(at: [IndexPath(item: filteredWords.count - 1, section: 0)])
        }
    }
    
    private func delete(word: Word) {
        StorageManager.shared.delete(word)
    }
}
    
//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == menuCollectionView {
            return 1
        } else {
            return 2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == menuCollectionView {
            return categories.count
        } else {
            return filteredWords.count
        }
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == menuCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuCell.cellID, for: indexPath) as? MenuCell else { return UICollectionViewCell() }
            let category = categories[indexPath.item].name
            cell.configure(text: category)
            return cell
        } else {
            switch indexPath.section {
            case 0:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardsCollectionViewCell.cellID, for: indexPath) as? CardsCollectionViewCell else { return UICollectionViewCell() }
                guard let name = myWords[indexPath.item].name else { return UICollectionViewCell() }
                guard let translation = myWords[indexPath.item].translation else { return UICollectionViewCell() }
                cell.configure(name: name, translation: translation)
                return cell
            default:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.reuseIdentifier, for: indexPath) as? MainCollectionViewCell else { return UICollectionViewCell() }
                let word = filteredWords[indexPath.item]
                guard let name = word.name else { return UICollectionViewCell() }
                guard let translation = word.translation else { return UICollectionViewCell() }
                cell.configure(word: name, translation: translation)
                cell.delegate = self
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let itemIndex = indexPath.item
        
        if collectionView == menuCollectionView {
            switch itemIndex {
            case 0:
                TemporaryData.testWords = allWords
                filteredWords = allWords
                mainCollectionView.reloadData()
            case 1:
                TemporaryData.testWords = myWords
                filteredWords = myWords
                mainCollectionView.reloadData()
            default:
                TemporaryData.testWords = dictionaryWords
                filteredWords = dictionaryWords
                mainCollectionView.reloadData()
            }
        } else {
            let word = filteredWords[indexPath.item]
            showAlert(word: word) { [unowned self] in
                self.mainCollectionView.reloadItems(at: [indexPath])
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
        let indexPath = IndexPath(item: 0, section: 0)
        menuCollectionView.selectItem(at: indexPath,
                                      animated: true,
                                      scrollPosition: .bottom)
        TemporaryData.testWords = allWords
    }
}

//MARK: - UICollectionViewFlowDelegate
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == menuCollectionView {
            return CGSize(width: view.frame.width / 3, height: collectionView.frame.height)
        }
        return CGSize()
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
        view.addSubview(mainCollectionView)
        view.addSubview(menuCollectionView)
        
        NSLayoutConstraint.activate([
            menuCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            menuCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            menuCollectionView.heightAnchor.constraint(equalToConstant: view.frame.width / 6),
            
            mainCollectionView.topAnchor.constraint(equalTo: menuCollectionView.safeAreaLayoutGuide.topAnchor),
            mainCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [unowned self] sectionindex, _ in
            switch sectionindex {
            case 0:
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
                    heightDimension: .fractionalHeight(0.15))
                
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
        .init(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                heightDimension: .fractionalHeight(0.1)),
              elementKind: UICollectionView.elementKindSectionHeader,
              alignment: .topLeading)
    }
}
//MARK: - SwipeableCollectionViewCellDelegate
extension MainViewController: SwipeableCollectionViewCellDelegate {
    func hiddenContainerViewTapped(inCell cell: UICollectionViewCell) {
        guard let indexPath = mainCollectionView.indexPath(for: cell) else { return }
        let word = myWords[indexPath.item]
        myWords.remove(at: indexPath.item)
        StorageManager.shared.delete(word)
        mainCollectionView.performBatchUpdates({
            self.mainCollectionView.deleteItems(at: [indexPath])
        })
    }
    
    func visibleContainerViewTapped(inCell cell: UICollectionViewCell) {
        guard let indexPath = mainCollectionView.indexPath(for: cell) else { return }
        print("Tapped item at index path: \(indexPath)")
    }
}



