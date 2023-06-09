//
//  DataManager.swift
//  Flashcards
//
//  Created by Рафия Сафина on 24.03.2023.
//

import CoreData

protocol StorageManagerProtocol: AnyObject {
    func create(_ wordName: String, translation: String, completion: (Word) -> Void)
    func fetchData(completion: (Result<[Word], Error>) -> Void)
    func update(_ word: Word, newName: String, newTranslation: String)
    func updateStatus(_ word: Word, isLearnt: Bool)
    func delete(_ word: Word)
}

final class StorageManager: StorageManagerProtocol {

    // MARK: - Core Data stack
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WordModel")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    private let viewContext: NSManagedObjectContext
    
    init() {
        viewContext = persistentContainer.viewContext
    }
    
    // MARK: - CRUD
    
    func fetchData(completion: (Result<[Word], Error>) -> Void) {
        let fetchRequest = Word.fetchRequest()
        
        do {
            let words = try viewContext.fetch(fetchRequest)
            completion(.success(words))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func create(_ wordName: String, translation: String, completion: (Word) -> Void) {
        let word = Word(context: viewContext)
        word.name = wordName
        word.translation = translation
        word.isLearnt = false
        word.category = Constants.Categories.myWords
        completion(word)
        saveContext()
    }
    
    func update(_ word: Word, newName: String, newTranslation: String) {
        word.name = newName
        word.translation = newTranslation
        saveContext()
    }
    
    func updateStatus(_ word: Word, isLearnt: Bool) {
        word.isLearnt = isLearnt
        saveContext()
    }
    
    func updateCategory(_ word: Word, category: String) {
        word.category = category
        saveContext()
    }
    
    func delete(_ word: Word) {
        viewContext.delete(word)
        saveContext()
    }

    // MARK: - Core Data Saving support
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
