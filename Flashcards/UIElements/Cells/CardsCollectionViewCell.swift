//
//  CardsCollectionViewCell.swift
//  Flashcards
//
//  Created by Рафия Сафина on 26.03.2023.
//

import UIKit

final class CardsCollectionViewCell: UICollectionViewCell {
    
    static let cellID = "cardsCellID"
    
    private var isFlipped = false
    
    private lazy var frontCellView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(flip))
        singleTap.numberOfTapsRequired = 1
        view.addGestureRecognizer(singleTap)
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        view.layer.shadowOpacity = 1.0
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 10.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var backCellView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(flip))
        singleTap.numberOfTapsRequired = 1
        view.addGestureRecognizer(singleTap)
        view.isHidden = true
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        view.layer.shadowOpacity = 1.0
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 10.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let translationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let wordLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func flip() {
        UIView.transition(with: contentView, duration: 1.0, options: isFlipped ? .transitionFlipFromBottom : .transitionFlipFromTop, animations:  { [unowned self] in
            frontCellView.isHidden = !frontCellView.isHidden
            backCellView.isHidden = !backCellView.isHidden
        })
        isFlipped = !isFlipped
    }
    
    func configure(name: String, translation: String) {
        wordLabel.text = name
        translationLabel.text = translation
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.addSubview(frontCellView)
        contentView.addSubview(backCellView)
        frontCellView.addSubview(wordLabel)
        backCellView.addSubview(translationLabel)
        
        NSLayoutConstraint.activate([
            frontCellView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            frontCellView.leadingAnchor.constraint(equalTo: leadingAnchor),
            frontCellView.trailingAnchor.constraint(equalTo: trailingAnchor),
            frontCellView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            backCellView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            backCellView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backCellView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backCellView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            translationLabel.centerXAnchor.constraint(equalTo: backCellView.centerXAnchor),
            translationLabel.centerYAnchor.constraint(equalTo: backCellView.centerYAnchor),
            
            wordLabel.centerXAnchor.constraint(equalTo: frontCellView.centerXAnchor),
            wordLabel.centerYAnchor.constraint(equalTo: frontCellView.centerYAnchor)
        ])
    }
}
