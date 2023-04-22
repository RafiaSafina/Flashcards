//
//  SearchTableViewController.swift
//  Flashcards
//
//  Created by Рафия Сафина on 13.04.2023.
//

import UIKit

class SearchViewController: UITableViewController {
    
    private var items: [String] = []
    
    private var words: [DictWord] = []
    
    var presenter: SearchPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.ReuseIdentifiers.searchCell)
        view.backgroundColor = .white
    }
    
    init(presenter: SearchPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    override init(style: UITableView.Style) {
        super.init(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError(Constants.String.initError)
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
        tableView.deselectRow(at: indexPath, animated: true)

        let word = words[indexPath.row]
        presenter?.didTapOnCell(word: word)
    }
}

//MARK: - UISearchResultsUpdating
extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
//        guard let resultController = searchController.searchResultsController as? SearchViewController else { return }
        
        presenter?.fetchData(text: text)
        
//        presenter?.fetchData(text: text) { [unowned self] word in
//            if !word.def.isEmpty {
//                let text = word.def[0].text
//                if text.count > resultController.items.last?.count ?? 0 {
//                    self.words.append(word)
//                    resultController.items.append(text)
//                    resultController.tableView.reloadData()
//                } else {
//                    self.words.removeLast()
//                    resultController.items.removeLast()
//                    resultController.tableView.reloadData()
//                }
//            }
//        }
    }
//    func getResults(searchController: UISearchController) {
//        guard let resultController = searchController.searchResultsController as? SearchViewController else { return }
//        if !word.def.isEmpty {
//            let text = word.def[0].text
//            if text.count > resultController.items.last?.count ?? 0 {
//                self.words.append(word)
//                resultController.items.append(text)
//                resultController.tableView.reloadData()
//            } else {
//                self.words.removeLast()
//                resultController.items.removeLast()
//                resultController.tableView.reloadData()
//            }
//        }
//    }
    
}
//MARK: - ResultViewProtocol
extension SearchViewController: SearchViewProtocol {
    func success(word: DictWord) {
        self.words.append(word)
        print(self.words)
        
    }
}

//MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            items.removeAll()
            words.removeAll()
            tableView.reloadData()
        }
    }
}
