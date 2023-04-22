//
//  SearchPresenter.swift
//  Flashcards
//
//  Created by Рафия Сафина on 18.04.2023.
//

import Foundation

protocol SearchViewProtocol: AnyObject {
    func success(word: DictWord)
}

protocol SearchPresenterProtocol: AnyObject {
    var dictWords: [DictWord] { get set }
    func fetchData(text: String)
    func didTapOnCell(word: DictWord)
}

class SearchPresenter: SearchPresenterProtocol {
    
    var dictWords: [DictWord] = []
    
    weak var view: SearchViewProtocol?
    var router: RouterProtocol?
    let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol, router: RouterProtocol) {
        self.networkManager = networkManager
        self.router = router
    }
    
    func fetchData(text: String) {
        networkManager.fetchData(text: text) { result in
            switch result {
            case .success(let word):
//                self.dictWords.append(word)
                self.view?.success(word: word)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func didTapOnCell(word: DictWord) {
        router?.goToDictWord(word: word)
    }
}
