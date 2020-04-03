//
//  CellProtocols.swift
//  Sample APP
//
//  Created by Vignesh Radhakrishnan on 01/04/20.
//  Copyright © 2020 Sample. All rights reserved.
//

import Foundation

protocol ListCellViewModel {
    var name: String {get}
    var profilePicturePath: String? {get}
}
