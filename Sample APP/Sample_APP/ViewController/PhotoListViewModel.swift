//
//  PhotoListViewModel.swift
//  Sample APP
//
//  Created by Vignesh Radhakrishnan on 01/04/20.
//  Copyright © 2020 Sample. All rights reserved.
//

import Foundation

enum FetchMode : Int {
    case Normal
    case PullUp
}
protocol ListViewModel {
    var currentPageNo : Int {get set}
    var indexesToInsertData : [Int] {get set}
    associatedtype Item
    func numberOfSections() -> Int
    func numberOfItems(inSection index: Int) -> Int
    func getCellViewModel(atIndex index:Int, inSection sectionIndex: Int) -> ListCellViewModel?
    func getItem(atIndex index: Int, inSection sectionIndex: Int) -> Item?
    func fetchItems(searchTerm : String,fetchMode: FetchMode,completion: @escaping ((Result<Bool, Error>) -> Void))
    func canLoadNextPage() ->Bool
     func beginningFetch(_ fetchMode: FetchMode)
}

class PhotoListViewModel : ListViewModel {
    
    var indexesToInsertData: [Int] = []
    typealias Item = Photo
    typealias CellViewModel = PhotolistCell.ViewModel
    private var list: [Item] = []
    private let service: PhotoGetListService
    private var perPage : Int = 60
    private var totalRecords : Int = 0
    var currentPageNo : Int = 1
    
    init(service: PhotoGetListService = PhotoService()) {
        self.service = service
    }
    
    private func resetData() {
        list.removeAll()
    }
    
    func beginningFetch(_ fetchMode: FetchMode) {
        switch fetchMode {
        case .Normal:
            currentPageNo = 1
        //    resetData()
        case .PullUp:
            currentPageNo += 1
        }
    }
    
    func canLoadNextPage() ->Bool {
        return list.count < totalRecords
    }
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfItems(inSection index: Int) -> Int {
        guard index < list.count else {
            return 0
        }
        return list.count
    }
    
    func getCellViewModel(atIndex index: Int, inSection sectionIndex: Int) -> ListCellViewModel? {
        let item = list[index]
        let viewModel: CellViewModel = CellViewModel(photo: item)
        return viewModel
    }
    
    
    func getItem(atIndex index: Int, inSection sectionIndex: Int) -> Photo? {
        return list[index]
    }
    
    func fetchItems(searchTerm : String,fetchMode: FetchMode,completion: @escaping ((Result<Bool, Error>) -> Void)) {
        service.getPhotoList(searchTerm: searchTerm, perPage: "\(perPage)", pageNo: "\(currentPageNo)") { [weak self](result) in
            switch result {
            case .success(let photos) :
                if fetchMode == .PullUp {
                    self?.indexesToInsertData =  self?.calculateIndexToInsertData(photos: photos.photo ?? [] ) ?? []
                    self?.list += photos.photo ?? []
                } else {
                    self?.list = photos.photo ?? []
                    self?.indexesToInsertData .removeAll()
                }
                self?.totalRecords = Int(photos.total) ?? 0
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    private func calculateIndexToInsertData(photos : [Photo]) -> [Int]? {
        if self.currentPageNo > 1 {
            let lasIndex = self.list.count
            var latestIndexes = [Int]()
            for (index,_) in photos.enumerated() {
                latestIndexes.append(lasIndex+index)
            }
            return latestIndexes
        } else {
            return nil
        }
    }
}
