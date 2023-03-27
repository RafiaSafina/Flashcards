//
//  Alert.swift
//  Flashcards
//
//  Created by Рафия Сафина on 26.03.2023.
//

import UIKit

extension UIAlertController {
    
    static func createAlertController(withTitle title: String) -> UIAlertController {
        UIAlertController(title: title, message: "Add new word", preferredStyle: .alert)
    }
    
    func action(word: Word?, completion: @escaping (String, String) -> Void) {
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let newWord = self?.textFields?.first?.text else { return }
            guard !newWord.isEmpty else { return }
            
            guard let newTranslation = self?.textFields?[1].text else { return }
            guard !newTranslation.isEmpty else { return }
            
            completion(newWord, newTranslation)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        addAction(saveAction)
        addAction(cancelAction)
        
        addTextField { textField in
            textField.placeholder = "Word"
            textField.text = word?.name
        }
        addTextField { textField in
            textField.placeholder = "Translation"
            textField.text = word?.translation
        }
    }
}

