//
//  WordRequest.swift
//  Flashcards
//
//  Created by Рафия Сафина on 22.04.2023.
//

import Foundation

struct WordRequest {
    
    private let apiKey = Constants.String.key
    
    let baseUrl = "https://dictionary.yandex.net/api/v1/dicservice.json/"
    
    var defaultQueryItems: [URLQueryItem] {
        [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "lang", value: "en-ru"),
            URLQueryItem(name: "text", value: "text")
        ]
    }
    
    
}
