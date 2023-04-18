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
    var words: [Word]? { get set }
    func fetchData()
    func didSwipeToDelete(word: Word)
    func goToNewWord()
    func receiveData(word: String?, translation: String?)
    func learnButtonTapped()
}

class MainPresenter: MainPresenterProtocol {
    
    weak var delegate: PassDataDelegate?
    
    weak var view: MainViewProtocol?
    let storageManager: StorageManagerProtocol?
    var router: RouterProtocol?
    
    var words: [Word]?
    
    private var word: String? = nil
    private var translation: String? = nil 
    
    init(storageManager: StorageManagerProtocol, router: RouterProtocol) {
        self.storageManager = storageManager
        self.router = router
        fetchData()
        delegate = self
    }
    
    func fetchData() {
        storageManager?.fetchData(completion: { [weak self] result in
            switch result {
            case .success(let words):
                self?.words = words
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    func didSwipeToDelete(word: Word) {
        storageManager?.delete(word)
    }
    
    func goToNewWord() {
        router?.showNewWord()
    }
    
    func addButtonTapped() {
        router?.showNewWord()
    }
    
    func learnButtonTapped() {
        router?.showTests()
    }
}

extension MainPresenter: PassDataDelegate {
    func receiveData(word: String?, translation: String?) {
        self.word = word
        self.translation = translation
    }
}
