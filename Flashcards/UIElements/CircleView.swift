//
//  CircleView.swift
//  Flashcards
//
//  Created by Рафия Сафина on 21.04.2023.
//

import Foundation

class CircleView: CardView {
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        self.layer.cornerRadius = self.frame.height / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
