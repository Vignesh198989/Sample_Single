//
//  PhotoListViewController.swift
//  Sample APP
//
//  Created by Vignesh Radhakrishnan on 01/04/20.
//  Copyright © 2020 Sample. All rights reserved.
//

import UIKit

class PhotoListViewController <T: ListViewModel> : UIViewController,UITableViewDataSource,UITableViewDelegate,CentralSpinnerProtocol,UISearchBarDelegate {
    
    @IBOutlet weak var searchBarView: UISearchBar!
    @IBOutlet weak var photoTableView: UITableView!
    
    var centralSpinner: UIActivityIndicatorView?
    private var viewModel: T
    private var searchText : String = "%22%22" // Passing empty string restricts from the API layer from the URL request
    private var tableViewDefaultEstimatedHeight : CGFloat = 120.0
    lazy var bottomSpinner : UIActivityIndicatorView = {
        let bottomSpinner = UIActivityIndicatorView.init(style: .gray)
        bottomSpinner.hidesWhenStopped = true
        bottomSpinner.accessibilityIdentifier = "centralSpinner"
        return bottomSpinner
    }()
    private var currentFetchMode : FetchMode = .Normal
    
    init(viewModel: T) {
        self.viewModel = viewModel
        super.init(nibName: "PhotoListViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initCenterSpinner()
        setupTableView()
        setupNavigationBar()
        setupSearchBar()
        fetchPhotoList()
    }
    private func setupNavigationBar() {
        self.title = "Photo list"
    }
    private func setupSearchBar() {
        searchBarView.delegate =  self
    }
    private func fetchPhotoList() {
        if currentFetchMode == .PullUp {
            self.setupBottomSpinner()
        } else {
            self.animateCentralSpinner()
            self.photoTableView.tableFooterView = UIView()
        }
        self.viewModel.beginningFetch(currentFetchMode)
        
        viewModel.fetchItems(searchTerm: searchText, fetchMode: currentFetchMode) { (result) in
            self.stopAnimating()
            switch result {
            case .success(_) :
                self.reloadData()
            case .failure(let error) :
                print(error)
            }
        }
    }
    private func stopAnimating() {
        self.stopAnimatingCentralSpinner()
        self.bottomSpinnerStopAnimating()
    }
    private func reloadData() {
        if self.viewModel.indexesToInsertData.count == 0 || self.viewModel.currentPageNo == 1 {
            photoTableView.reloadData()
        } else {
            var indexPathToInsertArray = [IndexPath]()
            for index in  self.viewModel.indexesToInsertData {
                indexPathToInsertArray.append(IndexPath(row: index, section: 0))
            }
            photoTableView.insertRows(at: indexPathToInsertArray, with: .automatic)
            self.viewModel.indexesToInsertData.removeAll()
        }
    }
    
    private func setupTableView () {
        photoTableView.register(UINib(nibName: String(describing: PhotolistCell.self), bundle: nil), forCellReuseIdentifier: String(describing: PhotolistCell.self))
        photoTableView.delegate  = self
        photoTableView.dataSource  = self
        photoTableView.tableFooterView = UIView()
        photoTableView.estimatedRowHeight = tableViewDefaultEstimatedHeight
    }
    private func setupBottomSpinner() {
        photoTableView.tableFooterView = bottomSpinner
        bottomSpinnerStartAnimating()
    }
    private func bottomSpinnerStartAnimating() {
        bottomSpinner.startAnimating()
    }
    
    private func bottomSpinnerStopAnimating() {
        bottomSpinner.stopAnimating()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.numberOfSections()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfItems(inSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PhotolistCell.self), for: indexPath)
        if let cell = cell as? PhotolistCell, let cellViewModel = viewModel.getCellViewModel(atIndex: indexPath.row, inSection: indexPath.section) {
            cell.configureCell(withViewModel: cellViewModel)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.searchText  = "%22%22"
        } else {
            self.searchText = searchText
        }
        currentFetchMode = .Normal
        searchByText(fetchMode: .Normal)
    }
    
    private func searchByText(fetchMode : FetchMode) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(PhotoListViewController.performSearchList), object: nil)
        self.perform(#selector(PhotoListViewController.performSearchList), with: nil, afterDelay: 0.3)
    }
    
    @objc func performSearchList() {
        self.fetchPhotoList()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.hasScrolledTillEnd() && self.viewModel.canLoadNextPage() {
            currentFetchMode = .PullUp
            fetchPhotoList()
        }
    }
}


