//
//  TableViewCell.swift
//  Flashcards
//
//  Created by Рафия Сафина on 12.03.2023.
//

import UIKit

protocol MainCollectionViewDelegate: AnyObject {
    func enableTextFields()
    func toggleButtonVisibility()
}

final class MainCollectionViewCell: UICollectionViewCell {

    static let reuseIdentifier = "wordCell"
    
    var deleteAction: (() -> ())?
    
    private var cellView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        view.layer.shadowOpacity = 1.0
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 2.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let wordLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let translationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.bounds.size.width = 50
        button.bounds.size.height = 50
        let image = UIImage(systemName: "trash")
        button.setImage(image, for: .normal)
        button.tintColor = .systemPink.withAlphaComponent(0.3)
        button.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func deleteButtonPressed() {
        if let action = deleteAction {
            action()
        }
    }
    
    func configure(word: String, translation: String) {
        wordLabel.text = word
        translationLabel.text = translation
    }
    
    override func layoutSubviews() {
        cellView.addSubview(wordLabel)
        cellView.addSubview(translationLabel)
        cellView.addSubview(deleteButton)
        addSubview(cellView)
            
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: topAnchor),
            cellView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            cellView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            cellView.bottomAnchor.constraint(equalTo: bottomAnchor),
            cellView.heightAnchor.constraint(equalToConstant: 120),
            
            wordLabel.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 20),
            wordLabel.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -10),
            wordLabel.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 20),
            
            translationLabel.topAnchor.constraint(equalTo: wordLabel.bottomAnchor, constant: 20),
            translationLabel.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 20),
            translationLabel.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -10),
            
            deleteButton.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -10),
            deleteButton.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -10)
        ])
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        endEditing(true)
    }
}

