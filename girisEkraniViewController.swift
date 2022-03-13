//
//  girisEkraniViewController.swift
//  projeTarifim
//
//  Created by Aleyna on 21.06.2021.
//  Copyright © 2021 Aleyna. All rights reserved.
//

import UIKit

class girisEkraniViewController: UIViewController {

    @IBOutlet weak var tarifGiris: UIButton!
    @IBAction func tarifimGiris(_ sender: Any) {
        self.performSegue(withIdentifier: "tarifimGiris", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.purple
        tarifGiris.layer.borderWidth = 5
        tarifGiris.layer.cornerRadius = 15
        tarifGiris.layer.borderColor = UIColor.black.cgColor
        

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
