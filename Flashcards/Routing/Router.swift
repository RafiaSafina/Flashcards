//
//  Router.swift
//  Flashcards
//
//  Created by Рафия Сафина on 18.04.2023.
//

import UIKit

protocol RouterMain: AnyObject {
    var mainViewController: UIViewController? { get set }
    var navigationController: UINavigationController? { get set }
    var builder: BuilderProtocol { get set }
}

protocol RouterProtocol: RouterMain {
    func initialMainViewController()
    func showMyWord(word: Word, delegate: DataUpdateDelegate)
    func showTests()
    func goToDictWord(word: DictWord)
    func goToNewWord()
    func goBackToRoot()
    
}

class Router: RouterProtocol {
   
    lazy private var networkManager: NetworkManagerProtocol = NetworkManager()
    lazy private var storageManager: StorageManagerProtocol = StorageManager()
    
    var builder: BuilderProtocol
    weak var navigationController: UINavigationController?
    weak var mainViewController: UIViewController?
    
    init(builder: BuilderProtocol, navigationController: UINavigationController) {
        self.builder = builder
        self.navigationController = navigationController
    }
    
    func initialMainViewController() {
        if let navigationController = navigationController {
            let mainViewController = builder.createMainViewController(storageManager: storageManager, router: self)
            navigationController.viewControllers = [mainViewController]
        }
    }
    
    func showMyWord(word: Word, delegate: DataUpdateDelegate) {
        let newWordVC = builder.createMyWordController(storageManager: storageManager, router: self, word: word, delegate: delegate)
        newWordVC.modalPresentationStyle = .popover
        navigationController?.present(newWordVC, animated: true)
    }
    
    func goToNewWord() {
        let newWordVC = builder.createNewWordController(storageManager: storageManager, router: self)
        newWordVC.modalPresentationStyle = .popover
        navigationController?.present(newWordVC, animated: true)
    }
    
    func showTests() {
        let testVC = builder.createTestViewController(storageManager: storageManager, router: self)
        navigationController?.pushViewController(testVC, animated: true)
    }
    
    func goBackToRoot() {
        if let navigationController = navigationController {
            navigationController.dismiss(animated: true)
        }
    }
    
    func goToDictWord(word: DictWord) {
        print()
    }
}
