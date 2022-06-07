//
//  AutocompleteViewController.swift
//  Swift-Algorithm-UI
//
//  Created by Ethan Hess on 1/30/21.
//

import UIKit

//TODO add
//MARK: https://github.com/airbnb/lottie-ios

//MARK: TODO, complete, debug this VC and make autocomplete func. work

class AutocompleteViewController: UIViewController {

    var theTrie : Trie?
    var results : [String] = []
    
    //Also add animations
    var searchTable : UITableView = {
        let tv = UITableView()
        return tv
    }()
    
    var searchBar : UISearchBar = {
        let sb = UISearchBar()
        return sb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    //TODO make JSON file
    fileprivate func tableSetup() {
        //Register
        searchTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        searchTable.delegate = self
        searchTable.dataSource = self
        
        searchBar.delegate = self
    }
    
    fileprivate func addToTrie() {
        let trie = Trie()
        self.theTrie = trie
        
        self.theTrie!.insert(word: "cut")
        self.theTrie!.insert(word: "cute")
        self.theTrie!.insert(word: "cutest")

        trie.insert(word: "cut")
        
        //TODO, if trie contains, add to table w / search bar
    }
    
    //Iterate this
    fileprivate func checkIfTrieContainsThenAddAndRefresh(text: String) {
        guard let tTrie = self.theTrie else {
            return
        }
        if tTrie.contains(word: text) {
            results.append(text)
        }
    }
    
    fileprivate func refresh() {
        DispatchQueue.main.async {
            self.searchTable.reloadData()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AutocompleteViewController : UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = results[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    //MARK: Search
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        checkIfTrieContainsThenAddAndRefresh(text: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
}
