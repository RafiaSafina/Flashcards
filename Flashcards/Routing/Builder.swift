//
//  File.swift
//  Flashcards
//
//  Created by Рафия Сафина on 18.04.2023.
//

import UIKit

protocol BuilderProtocol {
    func createMainViewController(storageManager: StorageManagerProtocol, router: RouterProtocol) -> UIViewController
    func createSearchViewController(networkManager: NetworkManagerProtocol, router: RouterProtocol) -> UIViewController
    func createTestViewController(storageManager: StorageManagerProtocol, router: RouterProtocol) -> UIViewController
    func createMyWordController(storageManager: StorageManagerProtocol, router: RouterProtocol, word: Word, delegate: DataUpdateDelegate) -> UIViewController
    func createNewWordController(storageManager: StorageManagerProtocol, router: RouterProtocol, delegate: DataUpdateDelegate) -> UIViewController
    func createDictWordController(storageManager: StorageManagerProtocol, router: RouterProtocol, word: DictWord, delegate: DataUpdateDelegate) -> UIViewController
}

struct Builder: BuilderProtocol {
    func createMainViewController(storageManager: StorageManagerProtocol, router: RouterProtocol) -> UIViewController {
        let presenter = MainPresenter(storageManager: storageManager, router: router)
        let view = MainViewController(presenter: presenter)
        
        presenter.view = view
        return view
    }
    
    func createSearchViewController(networkManager: NetworkManagerProtocol, router: RouterProtocol) -> UIViewController {
        let presenter = SearchPresenter(networkManager: networkManager, router: router)
        let view = SearchViewController(presenter: presenter)
        
        presenter.view = view
        return view
    }
    
    func createMyWordController(storageManager: StorageManagerProtocol, router: RouterProtocol, word: Word, delegate: DataUpdateDelegate) -> UIViewController {
        let presenter = WordPresenter(router: router, storageManager: storageManager, word: word)
        let view = MyWordViewController(presenter: presenter, delegate: delegate)
        
        presenter.view = view
        return view
    }
    
    func createNewWordController(storageManager: StorageManagerProtocol, router: RouterProtocol, delegate: DataUpdateDelegate) -> UIViewController {
        let presenter = WordPresenter(router: router, storageManager: storageManager)
        let view = MyWordViewController(presenter: presenter, delegate: delegate)
        
        presenter.view = view
        return view
    }
    
    func createTestViewController(storageManager: StorageManagerProtocol, router: RouterProtocol) -> UIViewController {
        let presenter = TestPresenter(router: router, storageManager: storageManager)
        let view = TestViewController(presenter: presenter)
        
        presenter.view = view
        return view
    }
    
    func createDictWordController(storageManager: StorageManagerProtocol, router: RouterProtocol, word: DictWord, delegate: DataUpdateDelegate) -> UIViewController {
        let presenter = WordPresenter(router: router, storageManager: storageManager, word: word)
        let view = MyWordViewController(presenter: presenter, delegate: delegate)
        
        presenter.view = view
        return view
    }
}
