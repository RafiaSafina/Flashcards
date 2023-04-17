//
//  TemporaryData.swift
//  Flashcards
//
//  Created by Рафия Сафина on 25.03.2023.
//

import Foundation

class TemporaryData {
    static let categories = [ "all words", "my words", "dictionary"]
    
    static var testWords: [Word] = []
    static var searchWords: [DictWord] = []
}

enum Constants {
        
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
    }
    
    enum String {
        static let searchBarPlaceholder = "Find word in dictionary"
        static let cancelButtonTitle = "Cancel"
        static let learnButtonTitle = "Learn"
        static let initError = "init(coder:) has not been implemented"
    }
}
