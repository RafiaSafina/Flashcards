//
//  SearchPresenter.swift
//  Flashcards
//
//  Created by Рафия Сафина on 18.04.2023.
//

import Foundation

protocol SearchViewProtocol: AnyObject {
   
}

protocol SearchPresenterProtocol: AnyObject {
    func fetchData(text: String, completion: @escaping ((DictWord) -> Void))
    func didTapOnCell(word: DictWord)
}

class SearchPresenter: SearchPresenterProtocol {
    
    var dictWord: DictWord?
    
    weak var view: SearchViewProtocol?
    var router: RouterProtocol?
    let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol, router: RouterProtocol) {
        self.networkManager = networkManager
        self.router = router
        
    }
    
    func fetchData(text: String, completion: @escaping ((DictWord) -> Void)) {
        networkManager.fetchData(text: text) { result in
            switch result {
            case .success(let word):
                completion(word)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func didTapOnCell(word: DictWord) {
        router?.showDictWord(word: word)
    }
}
