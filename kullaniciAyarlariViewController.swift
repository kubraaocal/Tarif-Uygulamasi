//
//  kullaniciAyarlariViewController.swift
//  projeTarifim
//
//  Created by Aleyna on 1.04.2021.
//  Copyright © 2021 Aleyna. All rights reserved.
//

import UIKit
import Firebase

class kullaniciAyarlariViewController: UIViewController {
    var gonderAd = String()
    var uid = [String]()
    var id  =  String()
    var email = String()
    var url = String()
    @IBOutlet weak var imageProfilView: UIImageView!
    var uidTarif = [String]()
    var idTarif  =  String()
    var emailTarif = String()
    
    @IBOutlet weak var guncellebtn: UIButton!
    @IBOutlet weak var updateKullaniciAdi: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageProfilView.layer.borderWidth = 3
        imageProfilView.layer.borderColor = UIColor.gray.cgColor
        imageProfilView.layer.cornerRadius = 10
        //
        guncellebtn.layer.borderWidth = 3
        guncellebtn.layer.borderColor = UIColor.gray.cgColor
        guncellebtn.layer.cornerRadius = 10
        //
        updateKullaniciAdi.layer.borderColor = UIColor.gray.cgColor
        updateKullaniciAdi.layer.borderWidth = 3
        updateKullaniciAdi.layer.cornerRadius = 10
        updateKullaniciAdi.textAlignment = .center
        self.updateKullaniciAdi.text = ""//döngü durumunu kurtarıyor.
        
        imageProfilView.isUserInteractionEnabled=true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapProfilResmiDegistir))
        imageProfilView.addGestureRecognizer(gesture)
        
    }
    func güncelle(resimUrl: String, isim: String)
    {
        let db = Firestore.firestore()
        db.collection("DiziKullanıcı")
            .addSnapshotListener { (snapshot, error) in
                if error != nil {
                    print(error?.localizedDescription)
                } else  {
                    if snapshot?.isEmpty != true && snapshot != nil{
                        
                        for document in snapshot!.documents {
                            //self.id.removeAll(keepingCapacity: false)
                            //self.email.removeAll(keepingCapacity: false)
                            
                            //o anki kullanıcının documentIdsni alıyorum
                            if(Auth.auth().currentUser?.email == document.get("Email") as? String)
                            {
                                self.id.append(document.documentID as! String)
                            }
                            
                            self.email.append(document.get("Email") as! String)
                            //alınmış documentidyi yani o anki kullanıcının adını değiştiriyorum.
                            if(document.documentID == self.id) {
                                db.collection("DiziKullanıcı").document(self.id).updateData(["Kullanıcı Adı" : isim, "gorselurl": resimUrl]) { (err) in
                                    if err != nil {
                                        print(err?.localizedDescription)
                                    } else {
                                        print("güncelleme")
                                        self.url.append(resimUrl)
                                        
                                    }
                                }
                                
                            }
                            
                        }
                        
                        
                    }
                    
                }
                // print(self.mail)
        }
        
    }
    
    @objc private func didTapProfilResmiDegistir(){
        presentPhotoActionSheet()
        
    }
    
    
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
            if((segue.destination as? tumunuGuncelleViewController) != nil) //beğenme ve detaya aynı çalışır durumda gidememe durumunu çözdü.
            {
                let viewController = segue.destination as! tumunuGuncelleViewController
                viewController.dizi=self.updateKullaniciAdi.text!
                viewController.dizifav=self.updateKullaniciAdi.text!
            }
            
            
            
            
            
        }
        @IBAction func updateButton(_ sender: Any) {
            self.resimYukleme()
            //keşfet, favoriler ve tarif detayı dışında hepsinde kullanıcı adını güncelliyor.
            performSegue(withIdentifier: "tumGuncelle", sender: nil)
            
            
            
        }
        
        func resimYukleme(){
            let storage = Storage.storage()
            let storageReference = storage.reference()
            
            let profilResmi = storageReference.child("updateFoto")
            
            if let data = imageProfilView.image?.jpegData(compressionQuality: 0.5){
                
                let uuid = UUID().uuidString
                
                let resimReference = profilResmi.child("\(uuid).jpg")
                
                resimReference.putData(data, metadata: nil) { (storagemetadata, error) in
                    if error != nil {
                        print("hata")
                    } else {
                        resimReference.downloadURL { (url, error) in
                            if error == nil {
                                let resimUrl = url?.absoluteString
                                
                                if let resimUrl = resimUrl {
                                    self.güncelle(resimUrl: resimUrl, isim: self.updateKullaniciAdi.text!)
                                }
                            }
                        }
                    }
                }
                
            }
            
        }
        
        
    }
    
    
    extension kullaniciAyarlariViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
        func presentPhotoActionSheet(){
            let actionSheet = UIAlertController(title: "Profil Resmi", message: "Profil resmini nasıl yüklemek istiyorsun?", preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Hayır", style: .cancel, handler: nil))
            actionSheet.addAction(UIAlertAction(title: "Fotoğraf Çek", style: .default, handler:{[weak self] _ in self?.presentKamera()}))
            actionSheet.addAction(UIAlertAction(title: "Fotoğraf Seç", style: .default, handler: {[weak self] _ in self?.presentFotografSecici()}))
            
            present(actionSheet,animated: true)
            
        }
        
        func presentKamera(){
            let vc=UIImagePickerController()
            vc.sourceType = .camera
            vc.delegate = self
            vc.allowsEditing = true
            present(vc,animated: true)
            
        }
        func presentFotografSecici(){
            let vc=UIImagePickerController()
            vc.sourceType = .photoLibrary
            vc.delegate = self
            vc.allowsEditing = true
            present(vc,animated: true)
            
        }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            picker.dismiss(animated: true, completion: nil)
            guard let secilenResim=info[UIImagePickerController.InfoKey.editedImage] as? UIImage else{
                return
            }
            
            self.imageProfilView.image = secilenResim
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
        
}

