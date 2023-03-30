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
        label.configureLabel(fontWight: .heavy)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet {
            label.textColor = isSelected
            ? .systemPink.withAlphaComponent(0.5)
            : .black
        }
    }
    
    func configure(text: String) {
        label.text = text
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
}
