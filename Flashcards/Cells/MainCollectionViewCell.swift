//
//  TableViewCell.swift
//  Flashcards
//
//  Created by Рафия Сафина on 12.03.2023.
//

import UIKit

final class MainCollectionViewCell: SwipableCollectionViewCell {

    static let reuseIdentifier = "wordCell"
    
    private var frontView = FrontView()
    
    private let wordLabel = WordLabel()
    private let translationLabel = TranslationLabel()
    
    private let deleteImageView: UIImageView = {
        let image = UIImage(named: "delete")?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .white
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        wordLabel.textAlignment = .left
        translationLabel.textAlignment = .left
        visibleContainerView.backgroundColor = .clear
        hiddenContainerView.backgroundColor = .systemRed
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(word: String, translation: String) {
        wordLabel.text = word
        translationLabel.text = translation
    }
}

//MARK: - Set UI
extension MainCollectionViewCell {

    override func layoutSubviews() {
        hiddenContainerView.addSubview(deleteImageView)
        visibleContainerView.addSubview(frontView)
        frontView.addSubview(wordLabel)
        frontView.addSubview(translationLabel)
            
        frontView.pinEdgesToSuperView()
        
        NSLayoutConstraint.activate([
            wordLabel.leadingAnchor.constraint(equalTo: frontView.leadingAnchor, constant: 20),
            wordLabel.trailingAnchor.constraint(equalTo: frontView.trailingAnchor, constant: -10),
            wordLabel.topAnchor.constraint(equalTo: frontView.topAnchor, constant: 15),
            
            translationLabel.topAnchor.constraint(equalTo: wordLabel.bottomAnchor, constant: 10),
            translationLabel.leadingAnchor.constraint(equalTo: frontView.leadingAnchor, constant: 20),
            translationLabel.trailingAnchor.constraint(equalTo: frontView.trailingAnchor, constant: -10),
            
            deleteImageView.centerXAnchor.constraint(equalTo: hiddenContainerView.centerXAnchor),
            deleteImageView.centerYAnchor.constraint(equalTo: hiddenContainerView.centerYAnchor),
            deleteImageView.widthAnchor.constraint(equalToConstant: 20),
            deleteImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}

