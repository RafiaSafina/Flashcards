//
//  TestPresenter.swift
//  Flashcards
//
//  Created by Рафия Сафина on 11.04.2023.
//

import Foundation

protocol TestViewProtocol: AnyObject {
    
}

protocol TestPresenterProtocol: AnyObject {
    var words: [Word]? { get set }
    func fetchData()
    func saveWord(word: Word, isLearnt: Bool)
}

class TestPresenter: TestPresenterProtocol {
    
    var words: [Word]?
    
    weak var view: TestViewProtocol?
    var router: RouterProtocol?
    let storageManager: StorageManagerProtocol?
    
    init(router: RouterProtocol, storageManager: StorageManagerProtocol) {
        self.router = router
        self.storageManager = storageManager
        fetchData()
    }
    
    func saveWord(word: Word, isLearnt: Bool) {
        storageManager?.updateStatus(word, isLearnt: isLearnt)
    }
    
    func fetchData() {
        storageManager?.fetchData(completion: { result in
            switch result {
            case .success(let words):
                self.words = words.filter { $0.isLearnt == false }
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
}
