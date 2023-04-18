//
//  UIView Ext.swift
//  Flashcards
//
//  Created by Рафия Сафина on 18.04.2023.
//

import UIKit

extension UIView {
    func pinEdgesToSuperView() {
        guard let superView = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superView.topAnchor),
            leftAnchor.constraint(equalTo: superView.leftAnchor),
            bottomAnchor.constraint(equalTo: superView.bottomAnchor),
            rightAnchor.constraint(equalTo: superView.rightAnchor)
        ])
    }
}
