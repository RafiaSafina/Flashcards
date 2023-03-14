//
//  TestingData.swift
//  Flashcards
//
//  Created by Рафия Сафина on 12.03.2023.
//

import Foundation

class TestingData {
    static let categories = [
        Category(isSelected: false, name: "first"),
        Category(isSelected: false, name: "second"),
        Category(isSelected: false, name: "third"),
    ]
    
    static let words = [
        Word(name: "some word1", category: categories[0]),
        Word(name: "some word1", category: categories[0]),
        Word(name: "some word1", category: categories[0]),
        Word(name: "some word1", category: categories[0]),
        Word(name: "some word2", category: categories[1]),
        Word(name: "some word2", category: categories[1]),
        Word(name: "some word2", category: categories[1]),
        Word(name: "some word3", category: categories[2]),
        Word(name: "some word3", category: categories[2]),
        Word(name: "some word3", category: categories[2]),
    ]
}

struct Category {
    var isSelected: Bool
    var name: String
}

struct Word {
    var name: String
    var category: Category
}



