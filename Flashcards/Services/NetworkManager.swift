//
//  NetworkManager.swift
//  Flashcards
//
//  Created by Рафия Сафина on 04.04.2023.
//

import Foundation

protocol NetworkManagerProtocol {
    func fetchData(text: String, completion: @escaping (Result<DictWord, NetworkError>) -> Void)
}

class NetworkManager: NetworkManagerProtocol {
    
    let key = Constants.String.key
    
    func fetchData(text: String, completion: @escaping (Result<DictWord, NetworkError>) -> Void) {
        guard let formatedQuery = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)  else { return }
        
        let url = "https://dictionary.yandex.net/api/v1/dicservice.json/lookup?key=\(key)&lang=en-ru&text=\(formatedQuery)"
        
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            let decoder = JSONDecoder()
            do {
                let word = try decoder.decode(DictWord.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(word))
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
}
