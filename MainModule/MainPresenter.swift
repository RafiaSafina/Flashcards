//
//  MainViewPresenter.swift
//  Flashcards
//
//  Created by Рафия Сафина on 11.04.2023.
//

import Foundation

protocol MainViewProtocol: AnyObject {
    
}

protocol MainPresenterProtocol: AnyObject {
    
}

class MainPresenter: MainPresenterProtocol {
    
    weak var view: MainViewProtocol?
    let storageManager: StorageManagerProtocol?
    
    var words: [Word]?
    
    init(storageManager: StorageManagerProtocol) {
        self.storageManager = storageManager
        fetchData()
    }
    
    func fetchData() {
        storageManager?.fetchData(completion: { [weak self] result in
            switch result {
            case .success(let words):
                self?.words = words
                //view func
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    func addButtonTapped() {
        
    }
    
    
}
