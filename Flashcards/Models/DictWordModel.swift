//
//  DictionaryWordModel.swift
//  Flashcards
//
//  Created by Рафия Сафина on 13.04.2023.
//

struct DictWord: Decodable {
    let def: [Def]
}

struct Def: Decodable {
    let text: String
    let tr: [Translation]
}

struct Translation: Decodable {
    let text: String
}
