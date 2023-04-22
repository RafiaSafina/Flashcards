//
//  TableViewCell.swift
//  Flashcards
//
//  Created by Рафия Сафина on 12.03.2023.
//

import UIKit

final class MainCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: SwipeableCollectionViewCellDelegate?
    
    var deleteHandler: (() -> Void)?
    
    private lazy var leftSwipeGesture: UISwipeGestureRecognizer = {
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeLeft))
        gesture.direction = .left
        return gesture
    }()
    
    private lazy var rightSwipeGesture: UISwipeGestureRecognizer = {
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeRight))
        gesture.direction = .right
        gesture.isEnabled = false
        return gesture
    }()
    
    private let cellView = CardView()
    
    private let wordLabel = WordLabel()
    private let translationLabel = TranslationLabel()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(deleteCell), for: .touchUpInside)
        button.setImage(UIImage(named: Constants.Images.delete), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        setupSubviews()
        cellView.addGestureRecognizer(leftSwipeGesture)
        cellView.addGestureRecognizer(rightSwipeGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError(Constants.String.initError)
    }
    
    @objc private func deleteCell() {
        if let deleteHandler = deleteHandler {
            deleteHandler()
        }
        toggleGestures()
    }
    
    @objc private func didSwipeLeft() {
        swipe(frameShift: -self.frame.width)
        toggleGestures()
    }
    
    @objc private func didSwipeRight() {
        swipe(frameShift: self.frame.width)
        toggleGestures()
    }
    
    private func swipe(frameShift: Double) {
        var frame = cellView.frame
        frame.origin.x += frameShift / 2

        UIView.animate(withDuration: 0.3) {
            self.cellView.frame = frame
        }
    }
    
    private func toggleGestures() {
        leftSwipeGesture.isEnabled = !leftSwipeGesture.isEnabled
        rightSwipeGesture.isEnabled = !rightSwipeGesture.isEnabled
    }
    
    func configure(word: String, translation: String) {
        wordLabel.text = word
        translationLabel.text = translation
    }
}

//MARK: - Set UI
extension MainCollectionViewCell {
    private func setupSubviews() {
        contentView.addSubview(cellView)
        contentView.insertSubview(deleteButton, belowSubview: cellView)
        cellView.addSubview(wordLabel)
        cellView.addSubview(translationLabel)
        
        cellView.pinEdgesToSuperView()
        
        NSLayoutConstraint.activate([
            deleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -contentView.frame.width / 5),
            
            wordLabel.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 20),
            wordLabel.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 20),
            
            translationLabel.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 20),
            translationLabel.topAnchor.constraint(equalTo: wordLabel.bottomAnchor, constant: 20)
        ])
    }
}


