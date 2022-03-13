//
//  tumunuGuncelleViewController.swift
//  projeTarifim
//
//  Created by Aleyna on 8.04.2021.
//  Copyright © 2021 Aleyna. All rights reserved.
//

import UIKit
import Firebase
class tumunuGuncelleViewController: UIViewController {
    var id = [String]()
    var dizi = String() //güncellenmiş diziden gelen ad.
    var diziFoto = String()
    var email = String()
    var profilResmi: Any?
    
      var idfav = [String]()
      var dizifav = String() //güncellenmiş diziden gelen ad.
      var emailfav = String()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.diziFoto)
        firebaseVeriAl()
        
    }
    
    //olan yerde yeni güncelleme yap.
    @IBAction func tumunuGuncelle(_ sender: Any) {
        let db = Firestore.firestore()
        performSegue(withIdentifier: "durumGüncelleme", sender: nil)
        db.collection("Tarifler")
            .addSnapshotListener { (snapshot, error) in
                if error != nil {
                    print(error?.localizedDescription)
                } else  {
                    if snapshot?.isEmpty != true && snapshot != nil{
                        
                        for document in snapshot!.documents {
                            //o anki kullanıcının documentIdsni alıyorum
                            if(Auth.auth().currentUser?.email == document.get("email") as? String)
                            {
                                self.id.append(document.documentID as! String)
                            }
                            
                            //self.email.append(document.get("email") as! String)
                            //alınmış documentidyi yani o anki kullanıcının adını değiştiriyorum.
                            for i in self.id {
                                if(document.documentID as? String == i) {
                                    db.collection("Tarifler").document(i).updateData(["kullaniciAdi" : self.dizi, "kullaniciprofilresmi": self.profilResmi]) { (err) in
                                        if err != nil {
                                            print(err?.localizedDescription)
                                        } else {
                                            print("güncelleme")
                                            
                                        }
                                    }
                                    
                                }
                            }
                    
                        }
                   
                    }
                    
                }
                
        }
        
        /*   db.collection("Favoriler").document(Auth.auth().currentUser!.uid).collection("fav")
                  .addSnapshotListener { (snapshot, error) in
                      if error != nil {
                          print(error?.localizedDescription)
                      } else  {
                          if snapshot?.isEmpty != true && snapshot != nil{
                              
                              for document in snapshot!.documents {
                                  //o anki kullanıcının documentIdsni alıyorum
                                  if(Auth.auth().currentUser?.email == document.get("email") as? String)
                                  {
                                      self.idfav.append(document.documentID as! String)
                                  }
                                  
                                  //self.email.append(document.get("email") as! String)
                                  //alınmış documentidyi yani o anki kullanıcının adını değiştiriyorum.
                                  for i in self.idfav {
                                      if(document.documentID as? String == i) {
                                          db.collection("Favoriler").document(i).updateData(["kullaniciAdi" : self.dizifav]) { (err) in
                                              if err != nil {
                                                  print(err?.localizedDescription)
                                              } else {
                                                  print("güncelleme")
                                                  
                                              }
                                          }
                                          
                                      }
                                  }
                          
                              }
                         
                          }
         
                  
}
}*/
}
    //zaten kullanıcıayarlarında güncellendiği için paylaşılmış tarif bilgilerindeki güncellemeyi güncellenmiş diziden
                 //çektim.
                 //ama adı kullanıcıayarları sınıfındaki textten çektim.
                 func firebaseVeriAl()
                 {
                     let firestoreDatabase = Firestore.firestore()
                     
                     firestoreDatabase.collection("DiziKullanıcı")
                         .addSnapshotListener { (snapshot, error) in
                             if error != nil {
                                 print(error?.localizedDescription)
                             } else  {
                                 if snapshot?.isEmpty != true && snapshot != nil{
                                     
                                     for document in snapshot!.documents {
                                         
                                         if let ppurl = document.get("gorselurl") as? String {
                                             
                                             if(Auth.auth().currentUser?.email == document.data()["Email"] as? String)
                                             {
                                                 self.profilResmi = ppurl//foto durumu düzeldi.
                                                 
                                             }
                                             
                                         }
                                         
                                     }
                                 }
                             }
                     }
                 }
}
