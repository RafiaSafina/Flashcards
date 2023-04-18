//
//  NewWordPresenter .swift
//  Flashcards
//
//  Created by Рафия Сафина on 18.04.2023.
//

import Foundation

protocol NewWordViewProtocol: AnyObject {
    func configure(word: String, translation: String)
}

protocol NewWordPresenterProtocol: AnyObject {
    func receiveData(word: String?, translation: String?)
}

class NewWordPresenter: NewWordPresenterProtocol {
    
    private var word: String?
    private var translation: String?
    
    weak var view: NewWordViewProtocol?
    var router: RouterProtocol?
    var storageManager: StorageManagerProtocol?
    
    init(router: RouterProtocol, storageManager: StorageManagerProtocol) {
        self.router = router
        self.storageManager = storageManager
    }
    
    
}

extension NewWordPresenter: PassDataDelegate {
    func receiveData(word: String?, translation: String?) {
        self.word = word
        self.translation = translation
        
        guard let word = word, let translation = translation else { return }
        view?.configure(word: word, translation: translation)
    }
}
