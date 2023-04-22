//
//  NewWordPresenter .swift
//  Flashcards
//
//  Created by Рафия Сафина on 18.04.2023.
//

import UIKit

protocol NewWordViewProtocol: AnyObject {
    func setWord(word: Word)
    func showButton()
    func setUpdatingStatus()
}

protocol NewWordPresenterProtocol: AnyObject {
    var word: Word? { get set }
    func setWord()
    func updateInterface()
    func setStatus()
    func update(newName: String, newTranslation: String)
    func create(word: String, translation: String)
    func goBackToRoot()
}

class WordPresenter: NewWordPresenterProtocol {

    private var isButtonShown = false    
    private var isUpdating = false
    
    var word: Word?
    var dictWord: DictWord?
    
    weak var view: NewWordViewProtocol?
    var router: RouterProtocol?
    var storageManager: StorageManagerProtocol?
    
    init(router: RouterProtocol, storageManager: StorageManagerProtocol, word: Word?) {
        self.router = router
        self.storageManager = storageManager
        self.word = word
        self.isUpdating = true
    } //updating word
    
    init(router: RouterProtocol, storageManager: StorageManagerProtocol, word: DictWord?) {
        self.router = router
        self.storageManager = storageManager
        self.dictWord = word
        self.isButtonShown = true
    } //create word from dictWord
    
    init(router: RouterProtocol, storageManager: StorageManagerProtocol) {
        self.router = router
        self.storageManager = storageManager
    } // creating new word

    func setWord() {
        guard let word = word else { return }
        view?.setWord(word: word)
    }
    
    func update(newName: String, newTranslation: String) {
        guard let word = word else { return }
        storageManager?.update(word, newName: newName, newTranslation: newTranslation)
    }
    
    func create(word: String, translation: String) {
        storageManager?.create(word, translation: translation, completion: {
            [weak self] word in
            guard let self = self else { return }
            self.word = word
        })
    }

    func goBackToRoot() {
        router?.goBackToRoot()
    }
    
    func updateInterface() {
        if isButtonShown {
            view?.showButton()
        }
    }
    
    func setStatus() {
        if isUpdating {
            view?.setUpdatingStatus()
        }
    }
}

