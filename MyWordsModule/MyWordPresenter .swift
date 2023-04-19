//
//  NewWordPresenter .swift
//  Flashcards
//
//  Created by Рафия Сафина on 18.04.2023.
//

import UIKit

protocol NewWordViewProtocol: AnyObject {
    func setWord(word: Word)
    func reloadData()
}

protocol NewWordPresenterProtocol: AnyObject {
    func setWord()
    func update(newName: String, newTranslation: String)
    func goBackToRoot()
}

class NewWordPresenter: NewWordPresenterProtocol {
    
    var word: Word?
    
    weak var view: NewWordViewProtocol?
    var router: RouterProtocol?
    var storageManager: StorageManagerProtocol?
    
    init(router: RouterProtocol, storageManager: StorageManagerProtocol, word: Word?) {
        self.router = router
        self.storageManager = storageManager
        self.word = word
    }

    func setWord() {
        guard let word = word else { return }
        view?.setWord(word: word)
    }
    
    func update(newName: String, newTranslation: String) {
        guard let word = word else { return }
        storageManager?.update(word, newName: newName, newTranslation: newTranslation)
        view?.reloadData()
    }
    
    func goBackToRoot() {
        router?.goBackToRoot()
    }
    
}

