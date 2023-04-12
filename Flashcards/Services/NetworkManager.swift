//
//  NetworkManager.swift
//  Flashcards
//
//  Created by Рафия Сафина on 04.04.2023.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
   
}
