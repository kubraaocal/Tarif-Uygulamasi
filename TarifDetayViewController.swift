//
//  TarifDetayViewController.swift
//  projeTarifim
//
//  Created by Aleyna on 26.03.2021.
//  Copyright © 2021 Aleyna. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
class TarifDetayViewController: UIViewController,UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var paylasimTarihi: UILabel!
    @IBOutlet weak var paylasanKullaniciResmi: UIImageView!
    @IBOutlet weak var paylasanKullaniciAdi: UILabel!
    var isimgetir = [String]()
    var kullaniciDizi = [String]()
    var isim = String()
    
    var resimgetir = [String]()
    var resimDizi = [String]()
    var resim = String()
    
    
    var paylasimid = String()
    var yorumDizi = [String()]
    
    var dizi = String()
    var kullaniciAdiDizi = String()
    
    var dizi1 = String()
    
    var yorumYapanAd = String()
    
    @IBOutlet weak var paylasimSaati: UILabel!
    @IBOutlet weak var textYorum: UITextField!
    @IBOutlet weak var imagePaylasimView: UIImageView!
    @IBOutlet weak var labelPaylasimTarif: UITextView!
    @IBOutlet weak var labelPaylasimTarifBaslik: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        firestoreVeriAl()
        firebaseVeriAl()
        paylasimSaati.layer.borderWidth = 3
        paylasimSaati.layer.borderColor = UIColor.gray.cgColor
        paylasimSaati.layer.cornerRadius = 10
        paylasimSaati.textAlignment = .center
        //
        paylasimTarihi.layer.borderWidth = 3
        paylasimTarihi.layer.borderColor = UIColor.gray.cgColor
        paylasimTarihi.layer.cornerRadius = 10
        paylasimTarihi.textAlignment = .center
        //
        paylasanKullaniciAdi.layer.borderWidth = 3
        paylasanKullaniciAdi.layer.borderColor = UIColor.gray.cgColor
        paylasanKullaniciAdi.layer.cornerRadius = 10
        paylasanKullaniciAdi.textAlignment = .center
        //
        imagePaylasimView.layer.borderWidth = 3
        imagePaylasimView.layer.borderColor = UIColor.gray.cgColor
        imagePaylasimView.layer.cornerRadius = 10
        //
        labelPaylasimTarif.layer.borderWidth = 3
        labelPaylasimTarif.layer.borderColor = UIColor.gray.cgColor
        labelPaylasimTarif.layer.cornerRadius = 10
        labelPaylasimTarif.textAlignment = .center
        //
        labelPaylasimTarifBaslik.layer.borderWidth = 3
        labelPaylasimTarifBaslik.layer.borderColor = UIColor.gray.cgColor
        labelPaylasimTarifBaslik.layer.cornerRadius = 10
        labelPaylasimTarifBaslik.textAlignment = .center
        
    }
    @IBAction func yorumPaylas(_ sender: Any) {
        yorumYap()
        textYorum.text = ""
    }
    func firestoreVeriAl(){
        let firestoreDatabase = Firestore.firestore()
        firestoreDatabase.collection("Tarifler").whereField("tarif", isEqualTo: dizi ).getDocuments { (snapshot, error) in
            if error != nil {
                print(error)
            } else {
                for document in (snapshot?.documents)! {
                    self.paylasimid = document.documentID
                    if let tarifbaslik = document.data()["tarif"] as? String{
                        self.labelPaylasimTarifBaslik.text = tarifbaslik                        
                    }
                    if let tarif = document.data()["tarifdetayi"] as? String{
                        self.labelPaylasimTarif.text = tarif
                        //self.profilResim=resim
                    }
                    if let resim = document.data()["gorselurl"] as? String{
                        self.imagePaylasimView.sd_setImage(with: URL(string: resim))
                    }
                    if let kullaniciAdi = document.data()["kullaniciAdi"] as? String{
                        self.paylasanKullaniciAdi.text = kullaniciAdi
                    }
                    if let kullaniciResmi = document.data()["kullaniciprofilresmi"] as? String{
                        self.paylasanKullaniciResmi.sd_setImage(with: URL(string: kullaniciResmi))
                    }
                    if let tarih = document.data()["tarih"] as? Timestamp{
                        let date = tarih.dateValue()
                        let formatter1 = DateFormatter()
                        formatter1.dateStyle = .short
                        print(formatter1.string(from: date))
                        self.paylasimTarihi.text=formatter1.string(from: date)
                        let formatter2 = DateFormatter()
                        formatter2.timeStyle = .short
                        self.paylasimSaati.text = formatter2.string(from: date)
                     }
                    
                }
                self.yorumlariAl()
            }
        }
    }
    func yorumYap(){
        let firestoreDatabase = Firestore.firestore()
        
        let firestoreYorum =  ["kullaniciId": Auth.auth().currentUser?.uid,"kullaniciAdi": isim,"kullaniciResmi": resim, "yorum": self.textYorum.text as Any, "tarih": FieldValue.serverTimestamp(), "paylasimId": dizi]as [String : Any]
        firestoreDatabase.collection("Paylasim").document(paylasimid).collection("yorumlar").addDocument(data: firestoreYorum){ (error) in
            if error != nil {
                // self.hataMesaji(titleInput: "Hata", messageInput: error?.localizedDescription ?? "Hata ile karşılaşıldı")
            } else {
                print("Kayıt başarılı")
            }
            
        }
    }
    
    
    func yorumlariAl(){
        let firestoreYorum = Firestore.firestore()
        firestoreYorum.collection("Paylasim").document(paylasimid).collection("yorumlar").order(by:"tarih", descending: true).addSnapshotListener{ (snapshot, error) in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                
                self.yorumDizi.removeAll(keepingCapacity: false)
                self.isimgetir.removeAll(keepingCapacity: false)
                self.resimgetir.removeAll(keepingCapacity: false)
                for document in snapshot!.documents {
                    if let isim = document.get("kullaniciAdi") as? String {
                        self.isimgetir.append(isim)
                    }
                    
                    if let yorum = document.get("yorum") as? String{
                        self.yorumDizi.append(yorum)
                    }
                    if let rsm = document.get("kullaniciResmi") as? String {
                        self.resimgetir.append(rsm)
                    }
                }
                self.tableView.reloadData()
                
            }
        }
    }
    func firebaseVeriAl()
    {
        let firestoreDatabase = Firestore.firestore()
        
        firestoreDatabase.collection("DiziKullanıcı")
            .addSnapshotListener { (snapshot, error) in
                if error != nil {
                    print(error?.localizedDescription)
                } else  {
                    if snapshot?.isEmpty != true && snapshot != nil{
                        self.kullaniciDizi.removeAll(keepingCapacity: false)
                        self.resimDizi.removeAll(keepingCapacity: false)
                        for document in snapshot!.documents {
                            
                            if let kullanicilar = document.get("Ad Soyad") as? String {
                                self.kullaniciDizi.append(kullanicilar)
                                
                            }
                            if let gorsel = document.get("gorselurl") as? String {
                                self.resimDizi.append(gorsel)
                            }
                            
                            for name in self.kullaniciDizi {
                                
                                if(Auth.auth().currentUser?.email == document.data()["Email"] as? String)
                                {
                                    self.isim = name
                                }
                                
                            }
                            
                            for image in self.resimDizi {
                                
                                if(Auth.auth().currentUser?.email == document.data()["Email"] as? String)
                                {
                                    self.resim = image
                                }
                                
                            }
                            
                            
                        }
                    }
                    self.tableView.reloadData()
                }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return yorumDizi.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DetayCell
        if(isimgetir.count > indexPath.row)
        {
            cell.kullaniciAdi.text = isimgetir[indexPath.row]
            cell.yorum.text = yorumDizi[indexPath.row]
        }
        
        return cell
    }
    
}


