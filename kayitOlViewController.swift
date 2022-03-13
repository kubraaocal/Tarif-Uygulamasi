//
//  kayitOlViewController.swift
//  projeTarifim
//
//  Created by Aleyna on 24.03.2021.
//  Copyright © 2021 Aleyna. All rights reserved.
//

import UIKit
import Firebase
class kayitOlViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(labelBaslik)
        view.addSubview(imageProfilView)
        view.addSubview(textAdSoyadField)
        view.addSubview(textEmailField)
        view.addSubview(textSifreField)
        view.addSubview(buttonKayit)
        view.addSubview(textAdField)
        view.backgroundColor = UIColor.gray
        
        imageProfilView.isUserInteractionEnabled=true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapProfilResmiDegistir))
        imageProfilView.addGestureRecognizer(gesture)
    }
    @objc private func didTapProfilResmiDegistir(){
        presentPhotoActionSheet()
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //scroll.frame=view.bounds
        
        labelBaslik.frame=CGRect(x: self.view.frame.width*0.05, y: self.view.frame.height*0.1, width: self.view.frame.width-40, height: 50)
        imageProfilView.frame=CGRect(x: self.view.frame.width*0.34, y: self.view.frame.height*0.18, width: 120, height: 120)
        imageProfilView.layer.cornerRadius = 120/2
        textAdSoyadField.frame=CGRect(x: self.view.frame.width*0.05, y: self.view.frame.height*0.4, width: self.view.frame.width-40, height: 50)
         textAdField.frame=CGRect(x: self.view.frame.width*0.05, y: self.view.frame.height*0.5, width: self.view.frame.width-40, height: 50)
        textEmailField.frame=CGRect(x: self.view.frame.width*0.05, y: self.view.frame.height*0.6, width: self.view.frame.width-40, height: 50)
        textSifreField.frame=CGRect(x: self.view.frame.width*0.05, y: self.view.frame.height*0.7, width: self.view.frame.width-40, height: 50)
        buttonKayit.frame=CGRect(x: self.view.frame.width*0.34, y: self.view.frame.height*0.82, width: self.view.frame.width-250, height: 50)
    }
    
    @objc private let labelBaslik:UILabel={
        let labelKayitOl=UILabel()
        labelKayitOl.textAlignment = .center
        labelKayitOl.text = "Kayıt Ol"
        //labelKayitOl.backgroundColor = .blue
        labelKayitOl.font = .systemFont(ofSize: 20, weight: .semibold)
        return labelKayitOl
    }()
    
    /*private let scroll:UIScrollView={
     let scroll=UIScrollView()
     return scroll
     }()*/
    
    private let imageProfilView:UIImageView={
        let imageProfilResmi=UIImageView()
        imageProfilResmi.image=UIImage(systemName: "person.circle")
        imageProfilResmi.tintColor = .purple
        imageProfilResmi.contentMode = .scaleAspectFit
        imageProfilResmi.layer.masksToBounds=true
        //imageProfilResmi.clipsToBounds=true
        imageProfilResmi.layer.borderWidth=2
        imageProfilResmi.layer.borderColor = UIColor.lightGray.cgColor
        return imageProfilResmi
    }()
    
    private let textAdSoyadField:UITextField={
        let textAdSoyad=UITextField()
        textAdSoyad.placeholder="Kullanıcı Adı"
        textAdSoyad.layer.borderWidth = 1
        textAdSoyad.layer.borderColor = UIColor.purple.cgColor
        textAdSoyad.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: textAdSoyad.frame.height))
        textAdSoyad.leftViewMode = .always//For left side padding
        textAdSoyad.rightViewMode = .always//For right side padding
        textAdSoyad.layer.cornerRadius = 5
        return textAdSoyad
    }()
    private let textAdField:UITextField={
          let textAd=UITextField()
          textAd.placeholder="Ad Soyad"
          textAd.layer.borderWidth = 1
          textAd.layer.borderColor = UIColor.purple.cgColor
          textAd.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: textAd.frame.height))
          textAd.leftViewMode = .always//For left side padding
          textAd.rightViewMode = .always//For right side padding
          textAd.layer.cornerRadius = 5
          return textAd
      }()
    private let textEmailField:UITextField={
        let textEmail=UITextField()
        textEmail.placeholder="Email"
        textEmail.layer.borderWidth = 1
        textEmail.layer.borderColor = UIColor.purple.cgColor
        textEmail.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: textEmail.frame.height))
        textEmail.leftViewMode = .always//For left side padding
        textEmail.rightViewMode = .always//For right side padding
        textEmail.layer.cornerRadius = 5
        textEmail.autocapitalizationType = .none
        return textEmail
    }()
    
    private let textSifreField:UITextField={
        let textSifre=UITextField()
        textSifre.placeholder="Şifre"
        textSifre.layer.borderWidth = 1
        textSifre.layer.borderColor = UIColor.purple.cgColor
        textSifre.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: textSifre.frame.height))
        textSifre.leftViewMode = .always//For left side padding
        textSifre.rightViewMode = .always//For right side padding
        textSifre.layer.cornerRadius = 5
        textSifre.sizeToFit()
        textSifre.isSecureTextEntry=true
        return textSifre
    }()
    
    private let buttonKayit:UIButton={
        let buttonKayitOl=UIButton()
        buttonKayitOl.setTitle("Kayıt Ol", for: .normal)
        buttonKayitOl.setTitleColor(.purple, for: .normal)
        buttonKayitOl.layer.cornerRadius = 5
        buttonKayitOl.layer.borderWidth = 1
        buttonKayitOl.layer.borderColor = UIColor.black.cgColor
        buttonKayitOl.addTarget(self, action: #selector(buttonKayitOlTiklandi), for: .touchUpInside)
        return buttonKayitOl
    }()
    
    @objc func buttonKayitOlTiklandi(_ sender: Any){
        //self.kayitBasarili(titleInput: "message", messageInput: "kayit başarılı")
        let adSoyad=textAdSoyadField.text!
        let email=textEmailField.text!
        let sifre=textSifreField.text!
        if !adSoyad.isEmpty && adSoyad != " " && !email.isEmpty && !sifre.isEmpty{
            //Kayıt olma işlemleri
            Auth.auth().createUser(withEmail: textEmailField.text!, password: textSifreField.text!) { (authResult, error) in
                if error != nil {
                    
                    self.hataMesaji(titleInput: "Hata!", messageInput: error?.localizedDescription ?? "Hata aldınız, Tekrar Deneyin")
                } else {
                    self.resimYukleme()
                    self.performSegue(withIdentifier: "toBack", sender: nil)
                    //self.dismiss(animated: true, completion: nil)
                    
                }
            }
        } else {
            hataMesaji(titleInput: "Hata!", messageInput: "Lütfen boş alan bırakmayınız!")
        }
    }
    func hataMesaji(titleInput: String, messageInput: String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton=UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert,animated: true,completion: nil)
    }
    /* func kayitBasarili(titleInput: String, messageInput: String){
     let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
     let okButton=UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
     alert.addAction(okButton)
     self.present(alert,animated: true,completion: nil)
     }*/
    public func kullaniciVeriKaydetme(resimUrl:String){
        let firestoreDatabase = Firestore.firestore()
        let firestoreKullanici=["Ad Soyad":textAdField.text!,"gorselurl" : resimUrl, "Kullanıcı Adı" : textAdSoyadField.text!, "Email" : textEmailField.text!, "uid": Auth.auth().currentUser?.uid]
        firestoreDatabase.collection("DiziKullanıcı").addDocument(data: firestoreKullanici) { (error) in
            if error != nil {
                self.hataMesaji(titleInput: "Hata", messageInput: error?.localizedDescription ?? "Hata ile karşılaşıldı")
            } else {
                print("Kayıt başarılı")
            }
            
        }
        
    }
    func resimYukleme(){
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        let profilResmi = storageReference.child("profil_resmi")
        
        if let data = imageProfilView.image?.jpegData(compressionQuality: 0.5){
            
            let uuid = UUID().uuidString
            
            let resimReference = profilResmi.child("\(uuid).jpg")
            
            resimReference.putData(data, metadata: nil) { (storagemetadata, error) in
                if error != nil {
                    self.hataMesaji(titleInput: "Hata!", messageInput: error?.localizedDescription ?? "Hata aldınız, Tekrar deneyin!")
                } else {
                    resimReference.downloadURL { (url, error) in
                        if error == nil {
                            let resimUrl = url?.absoluteString
                            
                            if let resimUrl = resimUrl {
                                self.kullaniciVeriKaydetme(resimUrl: resimUrl)
                            }
                        }
                    }
                }
            }
            
        }
        
    }
    
    
}
extension kayitOlViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func presentPhotoActionSheet(){
        let actionSheet = UIAlertController(title: "Profil Resmi", message: "Profil resmini nasıl yüklemek istiyorsun?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Hayır", style: .cancel, handler: nil))

        actionSheet.addAction(UIAlertAction(title: "Fotoğraf Çek", style: .default, handler:{[weak self] _ in self?.presentKamera()}))
        
        actionSheet.addAction(UIAlertAction(title: "Fotoğraf Seç", style: .default, handler: {[weak self] _ in self?.presentFotografSecici()}))
        
        present(actionSheet,animated: true)
        
    }
    
    func presentKamera(){
        /*let vc=UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc,animated: true)*/
        print("Kamera Açıldı")
        
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

