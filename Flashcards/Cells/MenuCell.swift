//
//  MenuCell.swift
//  Flashcards
//
//  Created by Рафия Сафина on 15.03.2023.
//

import UIKit

final class MenuCell: UICollectionViewCell {
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.configureLabel(fontWight: .heavy)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError(Constants.String.initError)
    }
    
    override var isSelected: Bool {
        didSet {
            categoryLabel.textColor = isSelected
            ? .systemPink.withAlphaComponent(0.3)
            : .black
        }
    }
    
    func configure(text: String) {
        categoryLabel.text = text
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(categoryLabel)
        
        NSLayoutConstraint.activate([
            categoryLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            categoryLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            categoryLabel.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
