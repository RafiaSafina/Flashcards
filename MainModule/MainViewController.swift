//
//  ViewController.swift
//  Flashcards
//
//  Created by Рафия Сафина on 12.03.2023.
//

import UIKit

protocol SwipeableCollectionViewCellDelegate: AnyObject {
    func hiddenContainerViewTapped(inCell cell: UICollectionViewCell)
}

protocol HeaderCollectionReusableViewDelegate: AnyObject {
    func goToTestViewController()
    func addNewWord()
}

protocol DataUpdateDelegate: AnyObject {
    func reloadData()
    func insertRow(word: Word)
}

class MainViewController: UIViewController {
    
    var presenter: MainPresenterProtocol
    
    private var categories = TemporaryData.categories
    
    private lazy var myWords: [Word] = presenter.words
    private var dictionaryWords: [Word] = []
    private var filteredWords: [Word] = []
    
    private var allWords: [Word] {
        myWords + dictionaryWords
    }
    
    private var isFlipped = true
    
    private let label: WordLabel = {
        let label = WordLabel()
        label.isHidden = true
        label.text = "Tap '+' to add your new word \n or search word in dictionary"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let searchResultController = SearchViewController(style: .plain)
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchBar.backgroundColor = .clear
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.searchTextField.borderStyle = .roundedRect
        searchController.searchBar.delegate = searchResultController
        searchController.searchResultsUpdater = searchResultController
        searchController.searchBar.searchBarStyle = .prominent
        searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: Constants.String.searchBarPlaceholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        return searchController
    }()
   
    private lazy var menuCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.isScrollEnabled = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(MenuCell.self, forCellWithReuseIdentifier: Constants.ReuseIdentifiers.menuCell)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private lazy var mainCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        cv.setCollectionViewLayout(createLayout(), animated: true)
        cv.backgroundColor = .clear
        cv.delegate = self
        cv.dataSource = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: Constants.ReuseIdentifiers.mainCell)
        cv.register(CardsCollectionViewCell.self, forCellWithReuseIdentifier: Constants.ReuseIdentifiers.flipCell)
        cv.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Constants.ReuseIdentifiers.header)
        return cv
    }()
    
    init(presenter: MainPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError(Constants.String.initError)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Color.backgroundColor
        filteredWords = allWords
        setNavigationBar()
        setLayout()
        setCellSelected()
        definesPresentationContext = true
        toggleLabel()
    }
    
    private func setCellSelected() {
        let indexPath = IndexPath(item: 0, section: 0)
        menuCollectionView.selectItem(at: indexPath,
                                      animated: true,
                                      scrollPosition: .bottom)
    }
    
    private func toggleLabel() {
        if filteredWords.isEmpty {
            label.isHidden = false
        } else {
            label.isHidden = true
        }
    }
}
    
//MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.ReuseIdentifiers.header, for: indexPath) as? HeaderCollectionReusableView else { return HeaderCollectionReusableView() }
        headerView.delegate = self
        return headerView
    }
    
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
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == menuCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.ReuseIdentifiers.menuCell, for: indexPath) as? MenuCell else { return UICollectionViewCell() }
            let category = categories[indexPath.item]
            cell.configure(text: category)
            return cell
        } else {
            switch indexPath.section {
            case 0:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.ReuseIdentifiers.flipCell, for: indexPath) as? CardsCollectionViewCell else { return UICollectionViewCell() }
                
                guard let name = filteredWords[indexPath.item].name,
                      let translation = filteredWords[indexPath.item].translation else { return UICollectionViewCell() }
                
                cell.configure(name: name, translation: translation)
                
                return cell
                
            default:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.ReuseIdentifiers.mainCell, for: indexPath) as? MainCollectionViewCell else { return UICollectionViewCell() }
                
                let word = filteredWords[indexPath.item]
                
                guard let name = word.name, let translation = word.translation else {
                    return UICollectionViewCell() }
                
                cell.configure(word: name, translation: translation)
                cell.deleteHandler = { [weak self] in
                    self?.presenter.didSwipeToDelete(word: word)
                    self?.filteredWords.remove(at: indexPath.item)
                    collectionView.deleteItems(at: [indexPath])
                }
                return cell
            }
        }
    }
}

//MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let itemIndex = indexPath.item
        
        if collectionView == menuCollectionView {
            switch itemIndex {
            case 0:
                filteredWords = allWords
                toggleLabel()
                mainCollectionView.reloadData()
            case 1:
                filteredWords = myWords
                toggleLabel()
                mainCollectionView.reloadData()
            default:
                filteredWords = dictionaryWords
                toggleLabel()
                mainCollectionView.reloadData()
            }
        } else {
            let word = filteredWords[indexPath.item]
            presenter.goToMyWord(word: word, delegate: self)
        }
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

//MARK: - Setup UI
extension MainViewController {
    private func setNavigationBar() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = Constants.Color.backgroundColor
    
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        navigationController?.navigationBar.barTintColor = .white
        
        navigationItem.searchController = searchController
    }
    
    private func setLayout() {
        view.addSubview(mainCollectionView)
        view.addSubview(menuCollectionView)
        view.insertSubview(label, belowSubview: mainCollectionView)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: menuCollectionView.bottomAnchor, constant: view.frame.height / 8),
            
            menuCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            menuCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            menuCollectionView.heightAnchor.constraint(equalToConstant: view.frame.width / 6),
             
            mainCollectionView.topAnchor.constraint(equalTo: menuCollectionView.bottomAnchor),
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
                group.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPagingCentered
                section.interGroupSpacing = 10
                section.supplementariesFollowContentInsets = false
                return section
            default:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(0.2))
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                group.contentInsets = .init(top: 10, leading: 24, bottom: 0, trailing: 24)
                
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
                                heightDimension: .fractionalHeight(0.08)),
              elementKind: UICollectionView.elementKindSectionHeader,
              alignment: .topLeading)
    }
}

//MARK: - HeaderCollectionReusableViewDelegate
extension MainViewController: HeaderCollectionReusableViewDelegate {
    func goToTestViewController() {
        presenter.learnButtonTapped()
    }
    
    func addNewWord() {
        presenter.goToNewWord()
    }
}

//MARK: - DataUpdateDelegate
extension MainViewController: DataUpdateDelegate {
    func insertRow(word: Word) {
        print("insert")
//        self.myWords.append(word)
//        
//        let cardIP = IndexPath(item: 0, section: 0)
//        let mainIP = IndexPath(item: 0, section: 1)
//
//        mainCollectionView.reloadData()
    }
    
    func reloadData() {
        mainCollectionView.reloadData()
    }
}

//MARK: - MainViewProtocol
extension MainViewController: MainViewProtocol {}


