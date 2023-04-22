//
//  MainViewPresenter.swift
//  Flashcards
//
//  Created by Рафия Сафина on 11.04.2023.
//

import UIKit

protocol MainViewProtocol: AnyObject {
   
}

protocol MainPresenterProtocol: AnyObject {
    var words: [Word] { get set }
    func fetchData()
    func didSwipeToDelete(word: Word)
    func goToMyWord(word: Word, delegate: DataUpdateDelegate)
    func goToNewWord()
    func learnButtonTapped()
}

class MainPresenter: MainPresenterProtocol {
   
    weak var view: MainViewProtocol?
    let storageManager: StorageManagerProtocol?
    var router: RouterProtocol?
    var words: [Word] = []
    
    init(storageManager: StorageManagerProtocol, router: RouterProtocol) {
        self.storageManager = storageManager
        self.router = router
        fetchData()
    }
    
    func fetchData() {
        storageManager?.fetchData(completion: { result in
            switch result {
            case .success(let words):
                self.words = words
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    func didSwipeToDelete(word: Word) {
        storageManager?.delete(word)
    }
    
    func goToMyWord(word: Word, delegate: DataUpdateDelegate) {
        router?.showMyWord(word: word, delegate: delegate)
    }
    
    func goToNewWord() {
        router?.goToNewWord()
    }
    
    func learnButtonTapped() {
        router?.showTests()
    }
}


