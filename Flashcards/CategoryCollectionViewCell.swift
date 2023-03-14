//
//  CollectionViewCell.swift
//  Flashcards
//
//  Created by Рафия Сафина on 12.03.2023.
//

import UIKit

final class CollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "categoryCell"
    
    private var wordLabel: UILabel = {
        let label = UILabel()
        label.layer.masksToBounds = false
        label.layer.cornerRadius = 16
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.clipsToBounds = true
        label.backgroundColor = .systemBlue
        label.textAlignment = .center
       
        
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(wordLabel)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        NSLayoutConstraint.activate([
            wordLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            wordLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
            wordLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            wordLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func configure(with text: String, isSelected: Bool) {
        wordLabel.text = text
        
        if isSelected {
            wordLabel.backgroundColor = .systemBlue
            wordLabel.layer.borderColor = UIColor.systemBlue.cgColor
            wordLabel.textColor = .white
        } else {
            wordLabel.backgroundColor = .clear
            wordLabel.layer.borderColor = UIColor.lightGray.cgColor
            wordLabel.textColor = .black
        }
    }
}
