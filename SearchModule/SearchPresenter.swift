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
    func receiveData(word: String?, translation: String?)
    func didTapOnCell()
}

class SearchPresenter: SearchPresenterProtocol {
    
    weak var delegate: PassDataDelegate?
    
    var dictWord: DictWord?
    
    private var word: String?
    private var translation: String?
    
    weak var view: SearchViewProtocol?
    var router: RouterProtocol?
    let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol, router: RouterProtocol) {
        self.networkManager = networkManager
        self.router = router
        delegate = self
    }
    
    func fetchData(text: String, completion: @escaping ((DictWord) -> Void)) {
        networkManager.fetchData(text: text) { result in
            switch result {
            case .success(let word):
                completion(word)
            case .failure(let error):
                print(error.localizedDescription) //view
            }
        }
    }
    
    func didTapOnCell() {
        router?.showNewWord()
    }
}

extension SearchPresenter: PassDataDelegate {
    func receiveData(word: String?, translation: String?) {
        self.word = word
        self.translation = translation
    }
}
