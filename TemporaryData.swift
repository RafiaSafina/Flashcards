//
//  TemporaryData.swift
//  Flashcards
//
//  Created by Рафия Сафина on 25.03.2023.
//

import UIKit

struct TemporaryData {
    static let categories = [ "all words", "my words", "dictionary"]
}

enum Constants {
    
    enum Categories {
        static let myWords = "my word"
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
        static let heart = "heart"
        static let filledHeart = "filledHeart"
        static let plus = "plus"
    }
    
    enum String {
        static let searchBarPlaceholder = "Find word in dictionary"
        static let saveButtonTitle = "Save"
        static let learnButtonTitle = "Learn"
        static let initError = "init(coder:) has not been implemented"
        static let key = "dict.1.1.20230405T122803Z.d3e168049561cfc7.842b40383d8e77ebd82988b5bef7eb27165a7807"
    }
    
    enum Color {
        static let accentColor = UIColor.accentColor
        static let cellColor = UIColor.cellColor
        static let fontColor = UIColor.black
        static let backgroundColor = UIColor.backgroundColor
        static let shadowColor = UIColor.shadowColor
    }
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}
