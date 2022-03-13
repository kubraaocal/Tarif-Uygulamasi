//
//  tumFavoriCell.swift
//  projeTarifim
//
//  Created by Aleyna on 30.03.2021.
//  Copyright © 2021 Aleyna. All rights reserved.
//

import UIKit

class tumFavoriCell: UITableViewCell {

    @IBOutlet weak var resim: UIImageView!
    @IBOutlet weak var baslik: UILabel!
    @IBOutlet weak var isim: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        resim.layer.borderWidth = 3
        resim.layer.borderColor = UIColor.gray.cgColor
        resim.layer.cornerRadius = 10
        //
        baslik.layer.borderWidth = 3
        baslik.layer.borderColor = UIColor.gray.cgColor
        baslik.layer.cornerRadius = 10
        baslik.textAlignment = .center
        //
        isim.layer.borderWidth = 3
        isim.layer.borderColor = UIColor.gray.cgColor
        isim.layer.cornerRadius = 10
        isim.textAlignment = .center
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
