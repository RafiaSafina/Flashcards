//
//  File.swift
//  Flashcards
//
//  Created by Рафия Сафина on 18.04.2023.
//

import UIKit

protocol BuilderProtocol {
    func createMainViewController(storageManager: StorageManagerProtocol, router: RouterProtocol) -> UIViewController
    func createResultViewController(networkManager: NetworkManagerProtocol, router: RouterProtocol) -> UIViewController
    func createTestViewController(storageManager: StorageManagerProtocol, router: RouterProtocol) -> UIViewController
    func createMyWordController(storageManager: StorageManagerProtocol, router: RouterProtocol, word: Word, delegate: ReloadDataDelegate) -> UIViewController
    func createDictWordController(storageManager: StorageManagerProtocol, router: RouterProtocol, word: DictWord) -> UIViewController
}

struct Builder: BuilderProtocol {
    func createMainViewController(storageManager: StorageManagerProtocol, router: RouterProtocol) -> UIViewController {
        let presenter = MainPresenter(storageManager: storageManager, router: router)
        let view = MainViewController(presenter: presenter)
        
        presenter.view = view
        return view
    }
    
    func createMyWordController(storageManager: StorageManagerProtocol, router: RouterProtocol, word: Word, delegate: ReloadDataDelegate) -> UIViewController {
        let presenter = NewWordPresenter(router: router, storageManager: storageManager, word: word)
        let view = NewWordViewController(presenter: presenter, delegate: delegate)
        
        presenter.view = view
        return view
    }
    
    func createResultViewController(networkManager: NetworkManagerProtocol, router: RouterProtocol) -> UIViewController {
        let presenter = SearchPresenter(networkManager: networkManager, router: router)
        let view = SearchViewController(presenter: presenter)
        
        presenter.view = view
        return view
    }
    
    func createTestViewController(storageManager: StorageManagerProtocol, router: RouterProtocol) -> UIViewController {
        let presenter = TestPresenter(router: router, storageManager: storageManager)
        let view = TestViewController(presenter: presenter)
        
        presenter.view = view
        return view
    }
    
    func createDictWordController(storageManager: StorageManagerProtocol, router: RouterProtocol, word: DictWord) -> UIViewController {
        return UIViewController()
    }
}
