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
    private lazy var allWords: [Word] = myWords

    private let menuBarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBlue
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: MenuCell.cellID)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let wordsCollectionView = WordsCollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        fetchData()
        filteredWords = allWords
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
    
    @objc private func startButtonPressed() {
        let cardsVC = CardsViewController()
        navigationController?.pushViewController(cardsVC, animated: true)
    }
    
    @objc private func addButtonPressed() {
        showAlert()
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
    
    private func save(wordName: String, translation: String) {
        CoreDataManager.shared.create(wordName, translation: translation) { [unowned self] word in
            myWords.append(word)
            wordsCollectionView.insertItems(at: [IndexPath(item: myWords.count - 1, section: 0)])
        }
    }
    
    private func delete(word: Word) {
        CoreDataManager.shared.delete(word)
    }

    private func setLayout() {
        view.addSubview(menuBarCollectionView)
        view.addSubview(wordsCollectionView)
        
        guard let navBarHeight = navigationController?.navigationBar.frame.minY  else { return }
        
        NSLayoutConstraint.activate([
            menuBarCollectionView.topAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: navBarHeight),
            menuBarCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuBarCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            menuBarCollectionView.heightAnchor.constraint(equalToConstant: 60),
            
            wordsCollectionView.topAnchor.constraint(equalTo: menuBarCollectionView.bottomAnchor),
            wordsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            wordsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            wordsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
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
            let word = filteredWords[indexPath.item]
            let name = word.name ?? ""
            let translation = word.translation ?? ""
            cell.configure(word: name, translation: translation)
            cell.deleteAction = { [weak self] in
                guard let word = self?.myWords.remove(at: indexPath.item) else { return }
                self?.wordsCollectionView.deleteItems(at: [indexPath])
                CoreDataManager.shared.delete(word)
            }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuCell.cellID, for: indexPath) as? MenuCell else { return UICollectionViewCell() }
            cell.configure(text: categories[indexPath.item])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == menuBarCollectionView {
            switch indexPath.item {
            case 0:
                filteredWords = allWords
                wordsCollectionView.reloadData()
            case 1:
                filteredWords = myWords
                wordsCollectionView.reloadData()
            default:
                filteredWords = dictionaryWords
                wordsCollectionView.reloadData()
            }
        } else {
            collectionView.deleteItems(at: [indexPath])
            let word = myWords[indexPath.item]
            showAlert(word: word) {
                collectionView.reloadItems(at: [indexPath])
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
// MARK: - Alert Controller
extension MainViewController {
    
    private func showAlert(word: Word? = nil, completion: (() -> Void)? = nil) {
        let title = word != nil ? "Update Word" : "New Word"
        let alert = UIAlertController.createAlertController(withTitle: title)
        
        alert.action(word: word) { [weak self] wordName, translationName  in
            if let word = word, let completion = completion {
                CoreDataManager.shared.update(word, newName: wordName, newTranslation: translationName)
                completion()
            } else {
                self?.save(wordName: wordName, translation: translationName)
            }
        }
        present(alert, animated: true)
    }
}

