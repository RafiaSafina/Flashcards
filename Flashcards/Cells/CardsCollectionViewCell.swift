//
//  CardsCollectionViewCell.swift
//  Flashcards
//
//  Created by Рафия Сафина on 26.03.2023.
//

import UIKit

final class CardsCollectionViewCell: UICollectionViewCell {

    private var isFlipped = true
    
    private lazy var frontCellView: UIView = {
        let view = UIView()
        view.configureBaseView()
        return view
    }()
    
    private lazy var backCellView: UIView = {
        let view = UIView()
        view.configureBaseView()
        view.isHidden = true
        return view
    }()

    private let translationLabel = TranslationLabel()
    private let wordLabel = WordLabel()
    
    private lazy var singleTapGesture: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(flip))
        tap.numberOfTapsRequired = 1
        return tap
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        contentView.addGestureRecognizer(singleTapGesture)
    }

    required init?(coder: NSCoder) {
        fatalError(Constants.String.initError)
    }

    @objc private func flip() {
        UIView.transition(with: contentView, duration: 1.0, options: isFlipped ? .transitionFlipFromBottom : .transitionFlipFromTop, animations:  { [unowned self] in
            frontCellView.isHidden = !frontCellView.isHidden
            backCellView.isHidden = !backCellView.isHidden
        })
        isFlipped = !isFlipped
    }

    func configure(name: String, translation: String, isSwiped: Bool? = nil) {
        wordLabel.text = name
        translationLabel.text = translation

        guard let isSwiped = isSwiped else { return }

        if isSwiped {
            contentView.removeGestureRecognizer(singleTapGesture)
        }
    }
}
//MARK: - Set UI
extension CardsCollectionViewCell {
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
