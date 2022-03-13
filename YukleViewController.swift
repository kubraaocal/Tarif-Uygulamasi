//
//  YükleViewController.swift
//  projeTarifim
//
//  Created by Aleyna on 19.03.2021.
//  Copyright © 2021 Aleyna. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import SDWebImage
class YukleViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var kullaniciFoto: UIImageView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var tarifDetay: UITextView!

    let viewController: ViewController = ViewController()//sınıf çağırma
    var profilResim: Any?
   
    @IBOutlet weak var kullanici: UILabel!
   
    @IBOutlet weak var paylasButon: UIButton!
    @IBOutlet weak var tarifText: UITextField!
    @IBOutlet weak var tarifResim: UIImageView!
    var kullaniciDizisi = [String]()
    var dizi = [String]()
    var id = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firebaseVeriAl()
        //tarifResim.roundedImage() bunu çağırmadan bu bunu nasıl çekti
        
        tarifResim.isUserInteractionEnabled = true //kullanıcı bu resmin üzerine tıklayabilir
        let getureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gorselSec))
        tarifResim.addGestureRecognizer(getureRecognizer)        // Do any additional setup after loading the view.
        
        tarifDetay.layer.borderWidth = 3
        tarifDetay.layer.borderColor = UIColor.lightGray.cgColor
        tarifDetay.layer.cornerRadius = 10
        pickerView.delegate = self
        pickerView.dataSource = self
        kullaniciFoto.layer.borderWidth = 3
        kullaniciFoto.layer.borderColor = UIColor.lightGray.cgColor
        kullaniciFoto.layer.cornerRadius = 10
        //
        kullanici.layer.borderWidth = 3
        kullanici.layer.borderColor = UIColor.lightGray.cgColor
        kullanici.layer.cornerRadius = 10
        //
        pickerView.layer.borderWidth = 3
        pickerView.layer.borderColor = UIColor.lightGray.cgColor
        pickerView.layer.cornerRadius = 10
        //
        tarifResim.layer.borderWidth = 3
        tarifResim.layer.borderColor = UIColor.lightGray.cgColor
        tarifResim.layer.cornerRadius = 10
        //
        paylasButon.layer.borderWidth = 3
        paylasButon.layer.borderColor = UIColor.lightGray.cgColor
        paylasButon.layer.cornerRadius = 10
        
    }
    
    var cesit = ["İçecek", "Tatlı", "Yemek"]
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cesit.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cesit[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        tarifDetay.text = cesit[row]//burası veritabanında yeni bir sütun olarak eklenebilir.
    }
    
    @objc func gorselSec() {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated:  true, completion: nil)
    }
    
    func firebaseVeriAl()
    {
        let firestoreDatabase = Firestore.firestore()
        firestoreDatabase.collection("DiziKullanıcı")
            .addSnapshotListener { (snapshot, error) in
                if error != nil {
                    print(error?.localizedDescription as Any)
                } else  {
                    if snapshot?.isEmpty != true && snapshot != nil{
                        self.kullaniciDizisi.removeAll(keepingCapacity: false)
                        
                        for document in snapshot!.documents {
                            
                            if let kullanicilar = document.get("Kullanıcı Adı") as? String {
                                self.kullaniciDizisi.append(kullanicilar)
                                
                            }
                            if let ppurl = document.get("gorselurl") as? String {
                                
                                if(Auth.auth().currentUser?.email == document.data()["Email"] as? String)
                                {
                                    self.profilResim = ppurl//foto durumu düzeldi.
                                    self.kullaniciFoto.sd_setImage(with: URL(string: self.profilResim as! String), completed: nil)
                                }
                            }
                            
                            for name in self.kullaniciDizisi {
                                
                                //self.kullanici.text = name
                                if(Auth.auth().currentUser?.email == document.data()["Email"] as? String)
                                {
                                    self.kullanici.text = name
                                    //self.kullanici.text = ""
                                }
                                //yeni kullanıcı kayıt olduğunda kullanıcı ismi değiştiriyor.ve en son kaydedilen kullaıcıda öylece kalıyor, yeni kullanıcı gelmeden eski kullanıcılar giriş yaptığında yine son kullanıcının kullanıcı adı gözüküyor.
                            }
                            
                            
                        }
                    }
                }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey :  Any]) {
        
        tarifResim.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func paylasButon(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: "Paylaşılıyor.. Lütfen Bekleyin\n\n", preferredStyle: .alert)

        let spinnerIndicator = UIActivityIndicatorView(style: .whiteLarge)

        spinnerIndicator.center = CGPoint(x: 135.0, y: 65.5)
        spinnerIndicator.color = UIColor.black
        spinnerIndicator.startAnimating()

        alertController.view.addSubview(spinnerIndicator)
        self.present(alertController, animated: false, completion: nil)
        //imageviewlwei image olarak kaydedemeyiz, bytelar ile kaydederiz
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        let mediaFolder = storageReference.child("mediaTarif")
        
        if let data = tarifResim.image?.jpegData(compressionQuality: 0.5){
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
                                let firestorePost = ["gorselurl" : imageUrl , "tarif" : self.tarifText.text!, "email": Auth.auth().currentUser!.email as Any,"id": Auth.auth().currentUser!.uid ,"kullaniciprofilresmi": self.profilResim,"kullaniciAdi": self.kullanici.text!,"tarifdetayi": self.tarifDetay.text!,"tarih" : FieldValue.serverTimestamp()] as [String : Any]
                                
                                alertController.dismiss(animated: true, completion: nil)
                                
                                firestoreDatabase.collection("Tarifler").addDocument(data: firestorePost) { (error) in
                                    if error != nil
                                    {
                                        self.hataMesajiGoster(title: "Hata!", message: error?.localizedDescription ?? "Hata Aldınız, Tekrar Deneyiniz")
                                    }
                                    else {
                                        self.tarifResim.image = UIImage(systemName:"square.and.arrow.up")
                                        //yukarıdaki kapatmak 2.bir tarifi yüklemeye olanak sağladı.
                                        self.tarifDetay.text = " "
                                        self.tarifText.text = " "
                                        self.tabBarController?.selectedIndex = 0
                                        //self.dismiss(animated: true, completion: nil)//direkt kapatıyor.
                                    }//012indexler sırayla!!
                                }
                                firestoreDatabase.collection("TarifProfil").document(Auth.auth().currentUser!.uid).collection("tarif").addDocument(data: firestorePost)  { (error) in
                                    if error != nil
                                    {
                                        self.hataMesajiGoster(title: "Hata!", message: error?.localizedDescription ?? "Hata Aldınız, Tekrar Deneyiniz")
                                    }
                                    
                                }
                            }
                            
                        }
                    }
                }
            }
            
            
        }
        
    }
    func hataMesajiGoster(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }}

