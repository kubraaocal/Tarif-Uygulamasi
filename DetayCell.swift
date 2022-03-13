//
//  DetayCell.swift
//  projeTarifim
//
//  Created by Aleyna on 27.03.2021.
//  Copyright © 2021 Aleyna. All rights reserved.
//

import UIKit

class DetayCell: UITableViewCell {

    @IBOutlet weak var yorum: UILabel!
    @IBOutlet weak var kullaniciResmi: UIImageView!
    @IBOutlet weak var kullaniciAdi: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        yorum.layer.borderWidth = 3
        yorum.layer.borderColor = UIColor.gray.cgColor
        yorum.layer.cornerRadius = 10
        yorum.textAlignment = .center
        //
        kullaniciAdi.layer.borderWidth = 3
        kullaniciAdi.layer.borderColor = UIColor.gray.cgColor
        kullaniciAdi.layer.cornerRadius = 10
        kullaniciAdi.textAlignment = .center
        //
        kullaniciResmi.layer.borderWidth = 3
        kullaniciResmi.layer.borderColor = UIColor.gray.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //kullanıcı resmi yuvarlansa iyi olur
        // Configure the view for the selected state
    }

}

