//
//  MenuTopBar.swift
//  Flashcards
//
//  Created by Рафия Сафина on 31.03.2023.
//

import UIKit

class MenuTopBar: UIView {
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemRed
        addSubview(collectionView)
        collectionView.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
