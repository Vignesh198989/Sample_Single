//
//  PhotoService.swift
//  Sample APP
//
//  Created by Vignesh Radhakrishnan on 01/04/20.
//  Copyright © 2020 Sample. All rights reserved.
//

import Foundation

protocol PhotoGetListService {
    func getPhotoList(searchTerm : String,perPage : String,pageNo : String,completion: @escaping ((Result<Photos, Error>) -> Void))
}

struct PhotoService : PhotoGetListService {
    
    private let api: PhotoListAPI
    
    init(api: PhotoListAPI = PhotoListAPIManager()) {
        self.api = api
    }
    func getPhotoList(searchTerm : String,perPage : String,pageNo : String,completion: @escaping ((Result<Photos, Error>) -> Void)) {
        api.getPhotoList(searchTerm: searchTerm, perPage: perPage, pageNo: pageNo) { (result) in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
}
