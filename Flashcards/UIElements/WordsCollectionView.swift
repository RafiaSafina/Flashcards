//
//  WordsCollectionView.swift
//  Flashcards
//
//  Created by Рафия Сафина on 18.03.2023.
//


import UIKit

class WordsCollectionView: UICollectionView {
    
    private let wordsLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        return layout
    }()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: wordsLayout)
        backgroundColor = .white
        isUserInteractionEnabled = true
        translatesAutoresizingMaskIntoConstraints = false
        register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
