//
//  SearchTableViewController.swift
//  Flashcards
//
//  Created by Рафия Сафина on 13.04.2023.
//

import UIKit

class ResultViewController: UITableViewController {
    
    private var items: [String] = []
    private var words: [DictWord] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.ReuseIdentifiers.searchCell)
        view.backgroundColor = .white
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ReuseIdentifiers.searchCell, for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = items[indexPath.row]
        content.textProperties.color = .black
        
        var backgroundConfig = UIBackgroundConfiguration.listPlainCell()
        backgroundConfig.backgroundColor = .white
        
        cell.contentConfiguration = content
        cell.backgroundConfiguration = backgroundConfig
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//
//        let def = words[indexPath.row].def[0]
//
//        let newWordVC = NewWordViewController()
//        newWordVC.dictWord = def
//
//        show(newWordVC, sender: nil)
    }
}

//MARK: - UISearchResultsUpdating
extension ResultViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        guard let resultController = searchController.searchResultsController as? ResultViewController else { return }
        
        NetworkManager.shared.fetchData(text: text) { [unowned self] result in
            switch result {
            case .success(let word):
                if !word.def.isEmpty {
                    let text = word.def[0].text
                    if text.count > resultController.items.last?.count ?? 0 {
                        words.append(word)
                        resultController.items.append(text)
                        resultController.tableView.reloadData()
                    } else {
                        words.removeLast()
                        resultController.items.removeLast()
                        resultController.tableView.reloadData()
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

//MARK: - UISearchBarDelegate
extension ResultViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            items.removeAll()
            words.removeAll()
            tableView.reloadData()
        }
    }
}

