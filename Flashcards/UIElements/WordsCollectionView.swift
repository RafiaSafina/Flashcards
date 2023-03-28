//
//  WordsCollectionView.swift
//  Flashcards
//
//  Created by Рафия Сафина on 18.03.2023.
//


import UIKit

class WordsCollectionView: UICollectionView {
    
//    private let wordsLayout: UICollectionViewFlowLayout = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//        return layout
//    }()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        backgroundColor = .white
        isUserInteractionEnabled = true
        translatesAutoresizingMaskIntoConstraints = false
        register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.reuseIdentifier)
        register(CardsCollectionViewCell.self, forCellWithReuseIdentifier: CardsCollectionViewCell.cellID)
        register(MenuCell.self, forCellWithReuseIdentifier: MenuCell.cellID)
        register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
