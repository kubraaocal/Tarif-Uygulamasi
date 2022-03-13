//
//  UIImageView.swift
//  projeTarifim
//
//  Created by Aleyna on 13.03.2021.
//  Copyright © 2021 Aleyna. All rights reserved.
//

import UIKit

extension UIImageView {
    func roundedImage() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
}
