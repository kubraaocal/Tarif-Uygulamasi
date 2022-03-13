//
//  tarifCell.swift
//  projeTarifim
//
//  Created by Aleyna on 1.04.2021.
//  Copyright © 2021 Aleyna. All rights reserved.
//

import UIKit

class tarifCell: UITableViewCell {

    @IBOutlet weak var tarifResim: UIImageView!
    @IBOutlet weak var tarifAdi: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tarifResim.layer.borderWidth = 3
        tarifResim.layer.borderColor = UIColor.gray.cgColor
        tarifResim.layer.cornerRadius = 10
        //
        tarifAdi.layer.borderWidth = 3
        tarifAdi.layer.cornerRadius = 10
        tarifAdi.layer.borderColor = UIColor.gray.cgColor
        tarifAdi.textAlignment = .center
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
