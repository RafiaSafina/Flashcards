//
//  TestingData.swift
//  Flashcards
//
//  Created by Рафия Сафина on 12.03.2023.
//

import Foundation

class TestingData {
     var categories = [
        Category(isSelected: false, name: "all"),
        Category(isSelected: false, name: "my words"),
        Category(isSelected: false, name: "dictionary"),
    ]
    
    lazy var words = [
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



