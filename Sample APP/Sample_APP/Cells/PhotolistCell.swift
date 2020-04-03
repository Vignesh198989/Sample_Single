//
//  PhotolistCell.swift
//  Sample APP
//
//  Created by Vignesh Radhakrishnan on 01/04/20.
//  Copyright © 2020 Sample. All rights reserved.
//

import Foundation
import UIKit

struct Image {
    struct PhotoList {
        static let profilePlaceHolder = "placeholder_list"
    }
}
class PhotolistCell : UITableViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
     private var profilePicturePath: String?
    
    struct ViewModel: ListCellViewModel {
        let name: String
        let profilePicturePath: String?
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = UIImage(named:Image.PhotoList.profilePlaceHolder)
    }
    
    func configureCell(withViewModel viewModel: ListCellViewModel) {
        self.titleLabel.text = viewModel.name
        if let path = viewModel.profilePicturePath {
            profilePicturePath = path
            ImageDownloader.sharedImageDownloader.download(path: path, placeHolderImage: UIImage(named: Image.PhotoList.profilePlaceHolder)) { [weak self] (image) in
                guard let self = self else {
                    return
                }
                if self.profilePicturePath == path {
                    self.photoImageView.image = image
                }
            }
        }
    }
}
extension PhotolistCell.ViewModel {
    
    init(photo : Photo) {
        self.name = photo.title ?? ""
        self.profilePicturePath = String(format: Server.ImageDownloadPath.ImagePath, photo.farm,photo.server,photo.id,photo.secret)
    }
    
}
