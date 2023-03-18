//
//  TableViewCell.swift
//  Flashcards
//
//  Created by Рафия Сафина on 12.03.2023.
//

import UIKit

final class MainCollectionViewCell: UICollectionViewCell {

    static let reuseIdentifier = "wordCell"
    
    private var appearanceView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemPink.withAlphaComponent(0.2)
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false 
        return view
    }()
    
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        appearanceView.addSubview(nameLabel)
        addSubview(appearanceView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func layoutSubviews() {
        NSLayoutConstraint.activate([
            appearanceView.topAnchor.constraint(equalTo: topAnchor),
            appearanceView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            appearanceView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            appearanceView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: appearanceView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: appearanceView.trailingAnchor, constant: -10),
            nameLabel.centerYAnchor.constraint(equalTo: appearanceView.centerYAnchor)
        ])
    }
    
    func configure(text: String) {
        nameLabel.text = text
    }
}
