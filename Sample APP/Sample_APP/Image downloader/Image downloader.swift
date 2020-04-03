//
//  Image downloader.swift
//  Sample_APP
//
//  Created by Vignesh Radhakrishnan on 02/04/20.
//  Copyright © 2020 Sample. All rights reserved.
//

import Foundation
import UIKit

final class ImageDownloader {
    
    static let sharedImageDownloader = ImageDownloader()
    private var networkManager: NetworkManager?
    private var cache: Cache?
    private let queue = DispatchQueue(label: "queue.imagedownload", attributes: .concurrent)
    
    private init() {
        configure()
    }
    
    func configure(cache: Cache = SimpleCache.sharedCache,networkManager: NetworkManager = NetworkManager()) {
        self.cache = cache
        self.networkManager = networkManager
    }
    
    func download(path: String, placeHolderImage: UIImage?, completion: @escaping (UIImage) -> Void) {
        queue.async { [weak self] in
            guard let self = self else {
                return
            }
            if let cachedData = self.cache?.getData(forKey: path), let image = UIImage.init(data: cachedData) {
                DispatchQueue.main.async {
                    completion(image)
                }
                return
            }
            let info = RequestInfo(path: path, parameters: nil, method: .get)
            self.networkManager?.download(requestInfo: info) { (result) in
                if let data = try? result.get(), let image = UIImage.init(data: data) {
                    self.queue.sync {
                        self.cache?.setData(data, forKey: info.path)
                        DispatchQueue.main.async {
                            completion(image)
                        }
                    }
                } else if let placeHolderImage = placeHolderImage {
                    DispatchQueue.main.async {
                        completion(placeHolderImage)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(UIImage())
                    }
                }
            }
        }
    }
}

