//
//  favorilerViewController.swift
//  projeTarifim
//
//  Created by Aleyna on 29.03.2021.
//  Copyright © 2021 Aleyna. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
class favorilerViewController: UIViewController,UITableViewDelegate, UITableViewDataSource{
    var dizi = String()
    var dizi1 = String()
    var kullaniciAdiDizi = String()
    var kullaniciResimDizi = String()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "Cell",  for: indexPath) as! favoriCell
        cell1.lbl.text = dizi1
        cell1.tarifResmi.sd_setImage(with: URL(string: dizi))
        cell1.kullaniciAd.text = kullaniciAdiDizi
        cell1.kullaniciResim.sd_setImage(with: URL(string: kullaniciResimDizi))
        
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        let mediaFolder = storageReference.child("favResim")
        
        if let data = cell1.tarifResmi.image?.jpegData(compressionQuality: 0.5){
            let uuid = UUID().uuidString
            let imageReference = mediaFolder.child("\(uuid).jpg")//sadece tek bir isimle kaydolmamasını sağlıyor.
            imageReference.putData(data, metadata: nil) { (storageMetaData, error) in
                if error != nil {
                    self.hataMesajiGoster(title: "Hata!", message: error?.localizedDescription ?? "Hata Aldınız, Tekrar Deneyiniz")
                } else {
                    imageReference.downloadURL { (url, error) in
                        if error == nil {
                            let imageUrl = url?.absoluteString
                            
                            if let imageUrl = imageUrl {
                                let firestoreDatabase = Firestore.firestore()
                                
                                //firestoreDatabase.collection("Post"//koleksiyona referans vermek
                                let firestorePost = ["gorselurl" : imageUrl , "email": Auth.auth().currentUser!.email,"tarif" : cell1.lbl.text! ,"kullaniciAdi": cell1.kullaniciAd.text!,"tarih" : FieldValue.serverTimestamp()] as [String : Any]
                                
                                firestoreDatabase.collection("Favoriler").document(Auth.auth().currentUser!.uid).collection("fav").addDocument(data: firestorePost) { (error) in
                                    if error != nil
                                    {
                                        self.hataMesajiGoster(title: "Hata!", message: error?.localizedDescription ?? "Hata Aldınız, Tekrar Deneyiniz")
                                    }
                                    else {
                                        print("else")
                                    }
                                }
                            }
                            
                            
                            
                        }
                    }
                }
            }
            
            
        }
        
        return cell1
        
    }
    
    
    func hataMesajiGoster(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}


