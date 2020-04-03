//
//  PhotoListAPIManager.swift
//  Sample APP
//
//  Created by Vignesh Radhakrishnan on 01/04/20.
//  Copyright © 2020 Sample. All rights reserved.
//

import Foundation

struct Server {
    static let baseurl = "https://www.flickr.com/services/rest"
    struct ConstantRequestParam {
        static let photosSearch = "flickr.photos.search"
        static let APIKey = "062a6c0c49e4de1d78497d13a7dbb360"
        static let ContentType = "json"
        static let NoJsonCallBack = "1"
    }
    struct ImageDownloadPath {
        static var ImagePath = "https://farm%d.staticflickr.com/%@/%@_%@.jpg"
    }
}
protocol PhotoListAPI {
    func getPhotoList(searchTerm : String,perPage : String,pageNo : String,completion: @escaping ((Result<Photos, Error>) -> Void))
}

struct PhotoListAPIManager: PhotoListAPI {
    
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func getPhotoList(searchTerm : String,perPage : String,pageNo : String,completion: @escaping ((Result<Photos, Error>) -> Void)) {
        
        let requestURL =  String(format:  Server .baseurl)
        let param = ["method" : Server.ConstantRequestParam.photosSearch, "api_key":Server.ConstantRequestParam.APIKey,"format": Server.ConstantRequestParam.ContentType,"nojsoncallback" : Server.ConstantRequestParam.NoJsonCallBack,"text" : searchTerm,"per_page" : perPage,"page" : pageNo]
        
        networkManager.request(requestInfo: RequestInfo(path: requestURL, parameters: param, method: RequestInfo.HTTPMethod.get)) { (result) in
            switch result {
            case .success(let data):
                do {
                    let response = try Parser<Response>().decode(data: data)
                    if let photos = response.photos {
                         completion(.success(photos))
                    }
                } catch {
                    if let error = Error.init(error: error) {
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
