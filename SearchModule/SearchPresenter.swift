//
//  SearchPresenter.swift
//  Flashcards
//
//  Created by Рафия Сафина on 18.04.2023.
//

import Foundation

protocol SearchViewProtocol: AnyObject {}

protocol SearchPresenterProtocol: AnyObject {
    var dictWords: [DictWord]? { get set }
    func request(text: String, completion: @escaping (DictWord) -> Void)
    func didTapOnCell(word: DictWord)
}

class SearchPresenter: SearchPresenterProtocol {
    
    var dictWords: [DictWord]?
    
    weak var view: SearchViewProtocol?
    var router: RouterProtocol?
    let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol, router: RouterProtocol) {
        self.networkManager = networkManager
        self.router = router
    }
    
    func request(text: String, completion: @escaping (DictWord) -> Void) {
        networkManager.request(text: text) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let word):
                self.dictWords?.append(word)
                completion(word)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func didTapOnCell(word: DictWord) {
        router?.goToDictWord(word: word)
    }
}
