//
//  FeedCell.swift
//  projeTarifim
//
//  Created by Aleyna on 19.03.2021.
//  Copyright © 2021 Aleyna. All rights reserved.
//

import UIKit


class FeedCell: UITableViewCell {
    
    @IBOutlet weak var kullaniciProfil: UIImageView!
    @IBOutlet weak var tarifText: UILabel!
    @IBOutlet weak var tarifImageView: UIImageView!
    @IBOutlet weak var kullaniciText: UILabel!

    let viewController: ViewController = ViewController()//sınıf çağırma
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        //kullanıcı profil resmi yuvarlama yapmak gerekk
        kullaniciProfil.layer.cornerRadius = (kullaniciProfil.frame.height ?? 0.0) / 2.5
        kullaniciProfil.clipsToBounds = true
        kullaniciProfil.layer.borderWidth = 3.0
        kullaniciProfil.layer.borderColor = UIColor.lightGray.cgColor
        // Configure the view for the selected state
        kullaniciText.layer.borderWidth = 2
        kullaniciText.layer.cornerRadius = 5
        kullaniciText.layer.borderColor = UIColor.lightGray.cgColor
        kullaniciText.textAlignment = .center
        //
        tarifImageView.layer.borderWidth = 2
        tarifImageView.layer.borderColor = UIColor.lightGray.cgColor
        tarifImageView.layer.cornerRadius = (tarifImageView.frame.height ?? 0.0) / 2.5
        //
        tarifText.layer.borderWidth = 2
        tarifText.layer.borderColor = UIColor.lightGray.cgColor
        tarifText.layer.cornerRadius = 5
        tarifText.textAlignment = .center
    }
  
}
