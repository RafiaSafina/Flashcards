//
//  TemporaryData.swift
//  Flashcards
//
//  Created by Рафия Сафина on 25.03.2023.
//

import Foundation

class TemporaryData {
    static let categories = [
       Category(name: "all words", isSelected: false),
       Category(name: "my words", isSelected: false),
       Category(name: "dictionary", isSelected: false)
    ]
    
    static var testWords: [Word] = []
    
    static var sectionTitles = [" ", " "]
}
