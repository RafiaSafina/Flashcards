//
//  TemporaryData.swift
//  Flashcards
//
//  Created by Рафия Сафина on 25.03.2023.
//

import Foundation

class TemporaryData {
    static let categories = [ "all words", "my words", "dictionary"]
    
    static var searchWords: [DictWord] = []
}

enum Constants {
    
    enum Categories {
        static let allWords = "all words"
        static let myWords = "my words"
        static let dictionary = "dictionary"
    }
    
    enum ReuseIdentifiers {
        static let menuCell = "menuCell"
        static let flipCell = "cardsCell"
        static let mainCell = "wordCell"
        static let header = "headerView"
        static let searchCell = "searchCell"
    }
    
    enum Images {
        static let xmark = "xmark"
        static let delete = "delete"
        static let plus = "plus"
        static let heart = "heart"
        static let filledHeart = "filledHeart"
    }
    
    enum String {
        static let searchBarPlaceholder = "Find word in dictionary"
        static let saveButtonTitle = "Save"
        static let learnButtonTitle = "Learn"
        static let initError = "init(coder:) has not been implemented"
    }
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}
