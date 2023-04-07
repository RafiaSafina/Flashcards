//
//  CategoryModel.swift
//  Flashcards
//
//  Created by Рафия Сафина on 07.04.2023.
//

import Foundation

struct Category {
    var name: String
    var isSelected: Bool
    
    init(name: String, isSelected: Bool) {
        self.name = name
        self.isSelected = isSelected
    }
}
