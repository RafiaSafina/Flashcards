//
//  MenuCell.swift
//  Flashcards
//
//  Created by Рафия Сафина on 15.03.2023.
//

import UIKit

final class MenuCell: UICollectionViewCell {
    
    private lazy var label: UILabel = {
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
            label.textColor = isSelected
            ? .systemPink.withAlphaComponent(0.3)
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
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
