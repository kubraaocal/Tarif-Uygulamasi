//
//  ViewController.swift
//  projeTarifim
//
//  Created by Aleyna on 13.03.2021.
//  Copyright © 2021 Aleyna. All rights reserved.
//
import GoogleSignIn
import UIKit
import FirebaseAuth
import Firebase
import MaterialComponents.MaterialTextControls_FilledTextAreas
import MaterialComponents.MaterialTextControls_FilledTextFields
import MaterialComponents.MaterialTextControls_OutlinedTextAreas
import MaterialComponents.MaterialTextControls_OutlinedTextFields

class ViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(textEmailField)
        view.addSubview(textPassField)
        view.backgroundColor = UIColor.gray
        let estimatedButtonFrame = CGRect(x: self.view.frame.width*0.30, y: self.view.frame.height*0.52, width: self.view.frame.width-250, height: 50)
        let buttonGiris = UIButton(frame: estimatedButtonFrame)
        buttonGiris.setTitle("Giriş", for: .normal)
        buttonGiris.setTitleColor(.purple, for: .normal)
        buttonGiris.layer.cornerRadius = 5
        buttonGiris.layer.borderWidth = 1
        buttonGiris.layer.borderColor = UIColor.black.cgColor
        view.addSubview(buttonGiris)
        buttonGiris.addTarget(self, action: #selector(buttonTiklandi), for: .touchUpInside)
        
        let estimatedLabelFrame = CGRect(x: self.view.frame.width*0.55, y: self.view.frame.height*0.65, width: self.view.frame.width-100, height: 50)
        let labelKayitOl = UILabel(frame: estimatedLabelFrame)
        labelKayitOl.text="Kayıt olmadınız mı?"
        labelKayitOl.textColor=UIColor.purple
        view.addSubview(labelKayitOl)
        let tap=UITapGestureRecognizer(target: self, action: #selector(tapFunction))
        labelKayitOl.isUserInteractionEnabled=true
        labelKayitOl.addGestureRecognizer(tap)
        
        //Eklenen elemanlar görünsün diye yapılıyor
        view.addSubview(labelBaslik)
    }
    
    
    @objc func buttonTiklandi(sender: UIButton){
        if textEmailField.text != "" && textPassField.text != ""{
            Auth.auth().signIn(withEmail: textEmailField.text!, password: textPassField.text!) { (authResult, error) in
                if error != nil {
                    self.hataMesaji(titleInput: "Hata!", messageInput: error?.localizedDescription ?? "Hata aldınız, Tekrar deneyin!")
                } else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        } else {
            hataMesaji(titleInput: "Hata!", messageInput: "Email ve Şifre Giriniz!")
        }
    }
    
    //Bu metot elemanların nereye yerleştirilmesi gerektiği için
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
             
        labelBaslik.frame=CGRect(x: self.view.frame.width*0.05, y: self.view.frame.height*0.2, width: self.view.frame.width-40, height: 50)
        textEmailField.frame=CGRect(x: self.view.frame.width*0.05, y: self.view.frame.height*0.3, width: self.view.frame.width-40, height: 50)
        textPassField.frame=CGRect(x: self.view.frame.width*0.05, y: self.view.frame.height*0.4, width: self.view.frame.width-40, height: 50)
        
        
    }
    //Farklı şekilde oluşturma
    private let labelBaslik:UILabel={
        let labelGiris=UILabel()
        labelGiris.textAlignment = .center
        labelGiris.text = "Giriş Yap"
        labelGiris.font = .systemFont(ofSize: 20, weight: .bold)
        return labelGiris
        
    }()
    private let textEmailField:MDCOutlinedTextField={
        let textEmailField = MDCOutlinedTextField()
        textEmailField.label.text = "Email"
        textEmailField.placeholder = "xx@gmail.com"
        textEmailField.autocapitalizationType = .none
        textEmailField.setOutlineColor(.purple, for: .editing)
        textEmailField.setFloatingLabelColor(.purple, for: .editing)
        return textEmailField
    }()
    
    private let textPassField:MDCOutlinedTextField={
        let textPassField = MDCOutlinedTextField()
        textPassField.label.text = "Şifre"
        textPassField.placeholder = "••••••••"
        textPassField.setOutlineColor(.purple, for: .editing)
        textPassField.setFloatingLabelColor(.purple, for: .editing)
        textPassField.sizeToFit()
        textPassField.isSecureTextEntry=true
        return textPassField
    }()
    
    
    @objc func tapFunction(sender: UITapGestureRecognizer){
        performSegue(withIdentifier: "toKayitOlViewController", sender: nil)
    }
    
    
    func hataMesaji(titleInput: String, messageInput: String)
    {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
        
    }
    
    
}
