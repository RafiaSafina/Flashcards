//
//  Router.swift
//  Flashcards
//
//  Created by Рафия Сафина on 18.04.2023.
//

import UIKit

protocol RouterMain: AnyObject {
    var rootViewController: UINavigationController? { get set }
    var newWordViewController: UIViewController? { get set }
    var testViewController: UIViewController? { get set }
    var searchViewController: UITableViewController? { get set }
}

protocol RouterProtocol: RouterMain {
    func showNewWord()
    func showTests()
    func goBackToRoot()
}

class Router: RouterProtocol {
   
    lazy private var networkManager: NetworkManagerProtocol = NetworkManager()
    lazy private var storageManager: StorageManagerProtocol = StorageManager()
    
    var builder: BuilderProtocol
    
    weak var rootViewController: UINavigationController?
    weak var newWordViewController: UIViewController?
    weak var testViewController: UIViewController?
    weak var searchViewController: UITableViewController?
    
    init(builder: BuilderProtocol, rootViewController: UINavigationController, newWordViewController: UIViewController, testViewController: UIViewController, searchViewController: UITableViewController) {
        self.builder = builder
        self.rootViewController = rootViewController
        self.newWordViewController = newWordViewController
        self.testViewController = testViewController
        self.searchViewController = searchViewController
    }
    
    func showNewWord() {
        let newWordVC = builder.createNewWordController(storageManager: storageManager, router: self)
        rootViewController?.pushViewController(newWordVC, animated: true)
    }
    
    func showTests() {
        let testVC = builder.createTestViewController(storageManager: storageManager, router: self)
        rootViewController?.pushViewController(testVC, animated: true)
    }
    
    func goBackToRoot() {
        if let rootViewController = rootViewController {
            rootViewController.popToRootViewController(animated: true)
        }
    }
    
}
