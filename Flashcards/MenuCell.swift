//
//  MenuCell.swift
//  Flashcards
//
//  Created by Рафия Сафина on 15.03.2023.
//

import UIKit

final class MenuCell: UICollectionViewCell {
    
    static let cellID = "menuCellID"
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.layer.borderWidth = 3
        label.layer.borderColor = UIColor.white.cgColor
        label.layer.cornerRadius = 32
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    override var isSelected: Bool {
        didSet {
            label.layer.borderColor = isSelected
            ? UIColor.systemPink.withAlphaComponent(0.5).cgColor
            : UIColor.white.cgColor
        
            
        }
    }
    
    func configure(text: String) {
        label.text = text
    }
}
