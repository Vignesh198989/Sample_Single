//
//  ScrollView+Helper.swift
//  Sample_APP
//
//  Created by Vignesh Radhakrishnan on 03/04/20.
//  Copyright © 2020 Sample. All rights reserved.
//

import Foundation
import UIKit

extension UIScrollView {
    func hasScrolledTillEnd() -> Bool{
        if Float(self.contentOffset.y) >= roundf(Float(self.contentSize.height - self.frame.size.height)) {
            return true
        }
        return false
    }
}
