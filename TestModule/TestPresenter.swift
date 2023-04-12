//
//  TestPresenter.swift
//  Flashcards
//
//  Created by Рафия Сафина on 11.04.2023.
//

import Foundation

protocol MainViewProtocol: AnyObject {
    func success()
    func failure(error: Error)
}

protocol MainViewPresenterProtocol: AnyObject {
    
}

class MainPresenter: MainViewPresenterProtocol {
    
}
