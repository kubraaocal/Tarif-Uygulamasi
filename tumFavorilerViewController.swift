//
//  tümFavorilerViewController.swift
//  projeTarifim
//
//  Created by Aleyna on 30.03.2021.
//  Copyright © 2021 Aleyna. All rights reserved.
//

import UIKit
import Firebase
import  SDWebImage
class tu_mFavorilerViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    var documentID = String()
    var kullaniciAdi = [String]()
    var tarifGorsel = [String]()
    var tarifBaslik =  [String]()
    var selectedRow = String()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        al()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return kullaniciAdi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "cell",  for: indexPath) as! tumFavoriCell
        if (kullaniciAdi.count > indexPath.row)
        {
            cell1.isim.text = kullaniciAdi[indexPath.row]
            cell1.resim.sd_setImage(with: URL(string: tarifGorsel[indexPath.row]))
            cell1.baslik.text = tarifBaslik[indexPath.row]
            
        } else {
            print("else")
        }
        
        return cell1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     self.selectedRow = self.tarifBaslik[indexPath.row]
     print("+++++++++++++++"+selectedRow)
     self.performSegue(withIdentifier: "toTarifDetayiViewController", sender: nil)
     //prepare(for: UIStoryboardSegue, sender: selectedRow)

     }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if((segue.destination as? TarifDetayViewController) != nil) //beğenme ve detaya aynı çalışır durumda gidememe durumunu çözdü.
        {
            let viewController = segue.destination as! TarifDetayViewController
            viewController.dizi=selectedRow
            print("+++++++++++++++"+selectedRow)
        }
    }
    func al() {
        let firestoreDatabase = Firestore.firestore()
        
        firestoreDatabase.collection("Favoriler").document(Auth.auth().currentUser!.uid).collection("fav").order(by: "tarih", descending: true).addSnapshotListener { (snapshot, error) in
            //order, verileri tarihe göre sıralama
            if error != nil {
                print(error?.localizedDescription)
            } else  {
                if snapshot?.isEmpty != true && snapshot != nil{
                    self.kullaniciAdi.removeAll(keepingCapacity: false)
                    self.tarifBaslik.removeAll(keepingCapacity: false)
                    self.tarifGorsel.removeAll(keepingCapacity: false)
                    for document in snapshot!.documents
                    {
                        
                        self.documentID.append(document.documentID)
                        
                        if let ad = document.get("kullaniciAdi") as? String {
                            self.kullaniciAdi.append(ad)
                        }
                        if let gorsel = document.get("gorselurl") as? String {
                            self.tarifGorsel.append(gorsel)
                        }
                        if let baslik = document.get("tarif") as? String{
                            self.tarifBaslik.append(baslik)
                        }
                    }
                    
                }
                self.tableView.reloadData()
            }
        }
    }
    
    
}
