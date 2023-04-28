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

protocol MainViewControllerDelegate: AnyObject {
    func goToTestViewController()
    func addNewWord()
}

protocol DataUpdateDelegate: AnyObject {
    func reloadData()
    func insertItem(word: Word)
}

class MainViewController: UIViewController {
    
    var presenter: MainPresenterProtocol

    private var categories = TemporaryData.categories
    
    private var filteredWords: [Word] = []
    private var dictionaryWords: [Word] = []
    private lazy var myWords: [Word] = presenter.words
    
    private var allWords: [Word] {
        myWords + dictionaryWords
    }
    
    private var isFlipped = true
    private var isDictWordsSelected = false
    private var isAnimationInProgress = false
    
    private var menuCollectionViewHeightConstraint: NSLayoutConstraint?
    
    private let zeroSectionTipLabel = WordLabel()
    private let firstSectionTipLabel = WordLabel()
    
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
        toggleLabels()
        definesPresentationContext = true
    }
    
    private func setCellSelected() {
        let indexPath = IndexPath(item: 0, section: 0)
        menuCollectionView.selectItem(at: indexPath,
                                      animated: true,
                                      scrollPosition: .bottom)
    }
    
    private func toggleLabels() {
        if filteredWords.isEmpty {
            zeroSectionTipLabel.isHidden = false
            firstSectionTipLabel.isHidden = false
        } else {
            zeroSectionTipLabel.isHidden = true
            firstSectionTipLabel.isHidden = true
        }
    }
    
    private func reloadDataAfterSelecting(category: [Word], text: String) {
        filteredWords = category
        mainCollectionView.reloadData()
        toggleLabels()
        firstSectionTipLabel.text = "Tap 'Learn' to check yourself"
        zeroSectionTipLabel.text = text
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
                
                guard let name = word.name,
                      let translation = word.translation else {
                    return UICollectionViewCell() }
                
                cell.configure(word: name, translation: translation)
                cell.deleteHandler = { [weak self] in
                    guard let self = self else { return }
                    self.presenter.didSwipeToDelete(word: word)
                    self.filteredWords.remove(at: indexPath.item)
                    self.myWords.remove(at: indexPath.item)
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
                reloadDataAfterSelecting(category: allWords, text: "Tap '+' to add your new word \n or search word in dictionary")
            case 1:
                reloadDataAfterSelecting(category: myWords, text: "Tap '+' to add your new word")
            default:
                reloadDataAfterSelecting(category: dictionaryWords, text: "Find your word in dictionary")
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
        view.insertSubview(zeroSectionTipLabel, belowSubview: mainCollectionView)
        view.insertSubview(firstSectionTipLabel, belowSubview: mainCollectionView)
        
        NSLayoutConstraint.activate([
            zeroSectionTipLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            zeroSectionTipLabel.topAnchor.constraint(equalTo: menuCollectionView.topAnchor, constant: view.frame.height / 4),
            
            firstSectionTipLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            firstSectionTipLabel.bottomAnchor.constraint(equalTo: zeroSectionTipLabel.bottomAnchor, constant: view.frame.height / 4),
            
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
        let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.08))
        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        headerElement.pinToVisibleBounds = true
        
        return headerElement
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            
        if scrollView.contentOffset.y > 0 {
            menuCollectionView.isHidden = true
        } else {
            menuCollectionView.isHidden = false
        }
    }
}

//MARK: - HeaderCollectionReusableViewDelegate
extension MainViewController: MainViewControllerDelegate {
    
    func goToTestViewController() {
        presenter.learnButtonTapped()
    }
    
    func addNewWord() {
        presenter.goToNewWord(delegate: self)
    }
}

//MARK: - DataUpdateDelegate
extension MainViewController: DataUpdateDelegate {
    func insertItem(word: Word) {
        self.myWords.append(word)
        self.filteredWords.append(word)
        let indexPath = [IndexPath(item: myWords.count - 1, section: 0),
                         IndexPath(item: myWords.count - 1, section: 1)]
        mainCollectionView.insertItems(at: indexPath)
        
        let bottomOffset = CGPoint(x: 0, y: mainCollectionView.contentSize.height - mainCollectionView.bounds.height + mainCollectionView.contentInset.bottom)
        mainCollectionView.setContentOffset(bottomOffset, animated: true)
    }
    
    func reloadData() {
        mainCollectionView.reloadData()
    }
}

//MARK: - MainViewProtocol
extension MainViewController: MainViewProtocol {}


