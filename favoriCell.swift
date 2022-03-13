//
//  favoriCell.swift
//  projeTarifim
//
//  Created by Aleyna on 29.03.2021.
//  Copyright © 2021 Aleyna. All rights reserved.
//

import UIKit

class favoriCell: UITableViewCell {

    @IBOutlet weak var info: UILabel!
    @IBOutlet weak var kullaniciAd: UILabel!
    @IBOutlet weak var kullaniciResim: UIImageView!
    @IBOutlet weak var lbl: UILabel!
    
    @IBOutlet weak var tarifResmi: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        kullaniciAd.layer.borderWidth = 3
        kullaniciAd.layer.borderColor = UIColor.gray.cgColor
        kullaniciAd.layer.cornerRadius = 10
        kullaniciAd.textAlignment = .center
        //
        kullaniciResim.layer.borderWidth = 3
        kullaniciResim.layer.borderColor = UIColor.gray.cgColor
        kullaniciResim.layer.cornerRadius = 10
        //
        lbl.layer.borderWidth = 3
        lbl.layer.borderColor = UIColor.gray.cgColor
        lbl.layer.cornerRadius = 10
        lbl.textAlignment = .center
        //
        tarifResmi.layer.borderWidth = 3
        tarifResmi.layer.borderColor = UIColor.gray.cgColor
        tarifResmi.layer.cornerRadius = 10
        //
        info.layer.borderWidth = 5
        info.layer.borderColor = UIColor.gray.cgColor
        info.textAlignment = .center
        info.textColor = UIColor.purple
    }

  
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
