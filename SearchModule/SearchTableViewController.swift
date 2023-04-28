//
//  SearchTableViewController.swift
//  Flashcards
//
//  Created by Рафия Сафина on 13.04.2023.
//

import UIKit

class SearchViewController: UITableViewController {
    
    private var dictWords: [DictWord] = []
    
    var presenter: SearchPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.ReuseIdentifiers.searchCell)
        view.backgroundColor = .white
        dictWords = presenter?.dictWords ?? []
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
        dictWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ReuseIdentifiers.searchCell, for: indexPath)
        
        let word = dictWords[indexPath.row].def[0].text
        
        var content = cell.defaultContentConfiguration()
        content.text = word
        content.textProperties.color = .black
        
        var backgroundConfig = UIBackgroundConfiguration.listPlainCell()
        backgroundConfig.backgroundColor = .white
        
        cell.contentConfiguration = content
        cell.backgroundConfiguration = backgroundConfig
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let word = dictWords[indexPath.row]
        presenter?.didTapOnCell(word: word)
    }
}

//MARK: - UISearchResultsUpdating
extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        guard let resultController = searchController.searchResultsController as? SearchViewController else { return }
        
        presenter?.request(text: text, completion: { word in
            if !word.def.isEmpty {
                
                let text = word.def[0].text
                guard let dictWord = resultController.dictWords[0].def.last?.text else { return }
                
                if text.count > dictWord.count {
                    resultController.dictWords.append(word)
                    resultController.tableView.reloadData()
                } else {
                    resultController.dictWords.removeLast()
                    resultController.tableView.reloadData()
                }
            }
        })
    }    
}
//MARK: - ResultViewProtocol
extension SearchViewController: SearchViewProtocol {}

//MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            dictWords.removeAll()
            tableView.reloadData()
        }
    }
}
