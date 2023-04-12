//
//  TableViewCell.swift
//  Flashcards
//
//  Created by Рафия Сафина on 12.03.2023.
//

import UIKit

final class MainCollectionViewCell: UICollectionViewCell {

    static let reuseIdentifier = "wordCell"
    
    weak var delegate: SwipeableCollectionViewCellDelegate?
    
    private var frontView = FrontView()
    
    private let hiddenContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemRed
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let wordLabel = WordLabel()
    private let translationLabel = TranslationLabel()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
       }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .clear
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(frontView)
        stackView.addArrangedSubview(hiddenContainerView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let deleteImageView: UIImageView = {
        let image = UIImage(named: "trash.fill")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .white
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupGestureRecognizer()
        wordLabel.textAlignment = .left
        translationLabel.textAlignment = .left
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(word: String, translation: String) {
        wordLabel.text = word
        translationLabel.text = translation
    }
    
    private func setupGestureRecognizer() {
        let hiddenContainerTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hiddenContainerViewTapped))
        hiddenContainerView.addGestureRecognizer(hiddenContainerTapGestureRecognizer)
    }
    
    @objc private func hiddenContainerViewTapped() {
        delegate?.hiddenContainerViewTapped(inCell: self)
    }
}

//MARK: - Set UI
extension MainCollectionViewCell {

    private func setupSubviews() {
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        hiddenContainerView.addSubview(deleteImageView)
        frontView.addSubview(wordLabel)
        frontView.addSubview(translationLabel)
    
        scrollView.pinEdgesToSuperView()
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 10),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 2),
            
            wordLabel.leadingAnchor.constraint(equalTo: frontView.leadingAnchor, constant: 20),
            wordLabel.trailingAnchor.constraint(equalTo: frontView.trailingAnchor, constant: -10),
            wordLabel.topAnchor.constraint(equalTo: frontView.topAnchor, constant: 15),
            
            translationLabel.topAnchor.constraint(equalTo: wordLabel.bottomAnchor, constant: 10),
            translationLabel.leadingAnchor.constraint(equalTo: frontView.leadingAnchor, constant: 20),
            translationLabel.trailingAnchor.constraint(equalTo: frontView.trailingAnchor, constant: -10),
            
            deleteImageView.trailingAnchor.constraint(equalTo: hiddenContainerView.trailingAnchor, constant: -10),
            deleteImageView.topAnchor.constraint(equalTo: hiddenContainerView.topAnchor, constant: 10),
            deleteImageView.widthAnchor.constraint(equalToConstant: 30),
            deleteImageView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    override func layoutSubviews() {
        if scrollView.contentOffset.x > 0 {
            scrollView.contentOffset.x = scrollView.frame.width
        }
    }
}

