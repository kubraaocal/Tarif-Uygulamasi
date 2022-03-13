//
//  KesfetViewController.swift
//  projeTarifim
//
//  Created by Aleyna on 19.03.2021.
//  Copyright © 2021 Aleyna. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import Social 


class KesfetViewController: UIViewController,UITableViewDelegate, UITableViewDataSource{
    
    var kullaniciDizisi = [String]()
    
    var tarifDizisi = [String]()
    var gorselDizisi = [String]()
    var profilResmi = [String]()
    var documentID = [String]()
    var sayi = 0
    var id = [String]()
    var tarifDetayi = [String]()
    var selectedRow = String()
    var selectedRow1 = String()//favori tarifAdi
    var selectedRow2 = String()//favori tarifResmi
    var selectedRow3 = String()//favori kullaniciAdi
    var selectedRow4 = String()//favori kulllanisiResim
    var selectedRow5 = String()//yorumiçikullanıcıAdı
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        firebaseVerileriAl()
        self.tableView.backgroundColor = UIColor.white
    }
    func firebaseVerileriAl() {
        let firestoreDatabase = Firestore.firestore()
        
        firestoreDatabase.collection("Tarifler").order(by:"tarih", descending: true)
            .addSnapshotListener { (snapshot, error) in
                //order, verileri tarihe göre sıralama
                if error != nil {
                    print(error?.localizedDescription as Any)
                } else  {
                    if snapshot?.isEmpty != true && snapshot != nil{
                        self.kullaniciDizisi.removeAll(keepingCapacity: false)
                        //eklenen veride dizilerde kaymayı önlüyor bir önceki veri ile
                        self.gorselDizisi.removeAll(keepingCapacity: false)
                        self.tarifDizisi.removeAll(keepingCapacity: false)
                        self.profilResmi.removeAll(keepingCapacity: false)
                        //snapshot?.documents //tüm dökumanlar dizi içerisinde geliyor.
                        for document in snapshot!.documents {
                            //document.get("gorselurl")
                            //let documentId = document.documentID
                            self.documentID.append(document.documentID)
                            if let gorselUrl = document.get("gorselurl") as? String {
                                self.gorselDizisi.append(gorselUrl)
                            }
                            //eğer id ile document idleri alabiliriz. document.documentID
                            if let tarif = document.get("tarif") as? String {
                                self.tarifDizisi.append(tarif)
                            }
                            if let kullanici = document.get("kullaniciAdi") as? String {
                                self.kullaniciDizisi.append(kullanici)
                            }
                            if let kullanicifoto = document.get("kullaniciprofilresmi") as? String {
                                self.profilResmi.append(kullanicifoto)
                            }
                            if let id1 = document.documentID as? String {
                                self.id.append(id1)
                            }
                            if let tarifAyrinti = document.get("tarifdetayi") as? String {
                                self.tarifDetayi.append(tarifAyrinti)
                            }
                            
                        }
                        self.tableView.reloadData()
                    }
                }
        }
        //dokuman altındaki tüm veriler ve eklendikçe eklenecek verileri görüyorum.
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section != 0 {return nil}
        let fav = UIContextualAction(style: .normal, title: "Beğen") { (action, view, nil) in
            print("beğen")
            //let vc=self.storyboard?.instantiateViewController(withIdentifier: "toFavori") as? favorilerViewController
            self.selectedRow1 = self.gorselDizisi[indexPath.row]
            self.selectedRow2 = self.tarifDizisi[indexPath.row]
            self.selectedRow3 = self.kullaniciDizisi[indexPath.row]
            self.selectedRow4 = self.profilResmi[indexPath.row]
            
            self.performSegue(withIdentifier: "toFavori", sender: nil)//burada sender selectedrow du ama onun bi ataması yok o olmadan da çalışıyor
            tableView.reloadData()
            
        }
        let paylas = UIContextualAction(style: .normal, title: "Paylaş") { (action, view, nil) in
            print("paylas")
            self.sosyalMedya()
            tableView.reloadData()
        }
        paylas.backgroundColor = UIColor.systemGray
        fav.backgroundColor = UIColor.systemPurple
        
        let config = UISwipeActionsConfiguration(actions: [fav,paylas])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
    func sosyalMedya(){//burası paylaşım için
        let aciklama = "Tarifim"
        let textPaylas = [aciklama] as [Any]
        
        let activity = UIActivityViewController(activityItems: textPaylas, applicationActivities: nil)
        activity.popoverPresentationController?.sourceView = self.view //IPAD İÇİN
        self.present(activity, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tarifDizisi.count//fazladan tarif oluşumunu engelliyor.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {//kEŞFET EKRANINDAKİ GÖRÜNTÜ İÇİN
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        
        if (profilResmi.count > indexPath.row)
        {
            cell.tarifText.text = tarifDizisi[indexPath.row]
            cell .tarifImageView.sd_setImage(with: URL(string: self.gorselDizisi[indexPath.row]))
            cell.kullaniciText.text = kullaniciDizisi[indexPath.row]
            cell.kullaniciProfil.sd_setImage(with: URL(string: self.profilResmi[indexPath.row]))
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedRow = self.tarifDizisi[indexPath.row]
        print("+++++++++++++++"+selectedRow)
        self.performSegue(withIdentifier: "toTarifDetayiViewController", sender: nil)
        //prepare(for: UIStoryboardSegue, sender: selectedRow)
        
    }
    
    //prepare olmadan sadece tarif idsi seçebiliyorum şu an.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if((segue.destination as? TarifDetayViewController) != nil) //beğenme ve detaya aynı çalışır durumda gidememe durumunu çözdü.
        {
            let viewController = segue.destination as! TarifDetayViewController
            viewController.dizi=selectedRow 
        }
        if((segue.destination as? favorilerViewController) != nil)  {//Burası beğenmede yollanan yer
            //beğenme ve detaya aynı çalışır durumda gidememe durumunu çözdü.
            let v = segue.destination as! favorilerViewController
            v.dizi=selectedRow1
            v.dizi1 = selectedRow2
            v.kullaniciAdiDizi=selectedRow3
            v.kullaniciResimDizi=selectedRow4
            
        }
        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
}



