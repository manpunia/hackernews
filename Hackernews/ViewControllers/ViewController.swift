//
//  ViewController.swift
//  Hackernews
//
//  Created by Manish Punia on 20/09/21.
//

import UIKit
import WebKit

let urlFormat = "https://hn.algolia.com/api/v1/search?query=%@&hitsPerPage=%d&page=%d"

class ViewController: UIViewController, UISearchResultsUpdating, UITableViewDelegate, UISearchBarDelegate, UITableViewDataSource {
   

    
    @IBOutlet var tableView: UITableView!
    private var itemListVM :NewsItemListViewModel = NewsItemListViewModel(items: [])
    var isCanLoadMore = false
    var currentPage = 1
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Setup()
    }
    
    private func Setup()
    {
        let searchController = UISearchController(searchResultsController: nil)

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search news"
        searchController.showsSearchResultsController = false
        searchController.automaticallyShowsCancelButton = false
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self;
        definesPresentationContext = true
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        loadItems(for: "", pageNo: currentPage)
    }
    
    //MARK: Table View
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
        
        let vm = self.itemListVM.itemAtIndex(indexPath.row)
        
        cell.textLabel?.text = vm.title
        cell.detailTextLabel?.text = vm.subtitle
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemListVM.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let urlStr = self.itemListVM.itemAtIndex(indexPath.row).subtitle
        if let url = URL(string: urlStr) {
            let vc = UINavigationController(rootViewController:DetailViewController(url: url))
            vc.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
            self.present(vc, animated: true, completion: nil)
        }
        else{
            let alert = UIAlertController(title: "Alert", message: "No URL found for item", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: { (_) in
                 }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if isCanLoadMore {
               
            
            if self.itemListVM.numberOfRowsInSection(indexPath.section) - 1 == indexPath.row {
                       isCanLoadMore = false
                       currentPage += 1
                loadItems(for: self.navigationItem.searchController?.searchBar.text ?? "", pageNo: currentPage)
               }
           }
      
    }
    
    // MARK: Load Data
    func loadItems(for query:String, pageNo:Int, hitsPerPage:Int = 20){
        self.isCanLoadMore = false
        let urlScheme = String(format:urlFormat, query,  hitsPerPage, pageNo)
        if let url = URL(string: urlScheme){
            WebService().getArticles(url: url) { items in
                if let items = items
                {
                    self.itemListVM.add(items:items)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    self.isCanLoadMore = true
                }
            }
        }
        else{
            print("Something went wrong while creating URL")
        }
    }
    
//MARK: Search
    func updateSearchResults(for searchController: UISearchController) {
        //Searching only when clicking search button
        if let text = searchController.searchBar.text, text.count > 0 {
            self.itemListVM = NewsItemListViewModel(items: [])
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        else
        {
            //while nothing is searching, searching with empty string
            loadItems(for: searchController.searchBar.text ?? "", pageNo: 1)
        }
      }
    //MARK: Searching only when clicking search button
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        loadItems(for: searchBar.text ?? "", pageNo: 1)
    }
    
    // MSRK: Utility
    @objc func done() {
        dismiss(animated: true, completion: nil)
    }
}

