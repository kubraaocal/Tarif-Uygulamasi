//
//  ayarlarViewController.swift
//  projeTarifim
//
//  Created by Aleyna on 13.03.2021.
//  Copyright © 2021 Aleyna. All rights reserved.
//

import UIKit
import Firebase
import SideMenu
import SDWebImage
class kullaniciProfilViewController: UIViewController, MenuControllerDelegate,UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var profilBaslik: UILabel!
    var kullaniciAdiDizi = [String]()
    var tarifBaslik = [String]()
    var tarifResimi = [String]()
    var selectedRow = String()
    
    @IBOutlet weak var tableView: UITableView!
    var profilResim: Any?
    @IBOutlet weak var kullaniciResim: UIImageView!
    @IBOutlet weak var kullaniciAd: UILabel!
    private var sideMenu: SideMenuNavigationController?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilBaslik.layer.borderWidth = 3
        profilBaslik.layer.borderColor = UIColor.gray.cgColor
        profilBaslik.layer.cornerRadius = 10
        profilBaslik.textColor = UIColor.purple
        kullaniciAd.layer.borderWidth = 3
        kullaniciAd.layer.borderColor = UIColor.gray.cgColor
        kullaniciAd.layer.cornerRadius = 10
        kullaniciAd.textAlignment = .center
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
        let menu = MenuController(with: ["Çıkış Yap","Kullanıcı Ayarları"])
        menu.delegate = self
        sideMenu = SideMenuNavigationController(rootViewController: menu)
        sideMenu?.leftSide = true
        SideMenuManager.default.leftMenuNavigationController = sideMenu
        SideMenuManager.default.addPanGestureToPresent(toView: view)
        
        
        
        
        let firestoreDatabase = Firestore.firestore()
        firestoreDatabase.collection("DiziKullanıcı")
            .addSnapshotListener { (snapshot, error) in
                if error != nil {
                    print(error?.localizedDescription)
                } else  {
                    if snapshot?.isEmpty != true && snapshot != nil{
                        self.kullaniciAdiDizi.removeAll(keepingCapacity: false)
                        
                        for document in snapshot!.documents {
                            
                            if let kullanicilar = document.get("Kullanıcı Adı") as? String {
                                self.kullaniciAdiDizi.append(kullanicilar)
                                
                            }
                            if let ppurl = document.get("gorselurl") as? String {
                                
                                if(Auth.auth().currentUser?.email == document.data()["Email"] as? String)
                                {
                                    self.profilResim = ppurl//foto durumu düzeldi.
                                    self.kullaniciResim.sd_setImage(with: URL(string: self.profilResim as! String), completed: nil)
                                }
                                
                            }
                            
                            for name in self.kullaniciAdiDizi {
                                if(Auth.auth().currentUser?.email == document.data()["Email"] as? String)
                                {
                                    self.kullaniciAd.text = name
                                    
                                }
                                
                            }
                            
                            
                            
                        }
                    }
                }
                
                
        }
        //kullanıcı profili için veri alma
        firestoreDatabase.collection("TarifProfil").document(Auth.auth().currentUser!.uid).collection("tarif").order(by: "tarih",descending: true)
            .addSnapshotListener { (snapshot, error) in
                if error != nil {
                    print(error?.localizedDescription)
                } else  {
                    if snapshot?.isEmpty != true && snapshot != nil{
                        self.tarifBaslik.removeAll(keepingCapacity: false)
                        
                        for document in snapshot!.documents {
                            
                            if let tarif1 = document.get("tarif") as? String {
                                self.tarifBaslik.append(tarif1)
                                
                            }
                            if let gorsel = document.get("gorselurl") as? String {
                                self.tarifResimi.append(gorsel)
                            }
                        }
                    }
                }
                self.tableView.reloadData()
                
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tarifBaslik.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! tarifCell
        
        cell.tarifAdi.text = tarifBaslik[indexPath.row]
        cell.tarifResim.sd_setImage(with: URL(string: self.tarifResimi[indexPath.row]))
        
        return cell
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
    
    @IBAction func didTapMenuButton() {
        present(sideMenu!, animated: true)
    }
    func didSelectMenuItem(named: String) {
        sideMenu?.dismiss(animated: true, completion: { [weak self] in
            if named == "Çıkış Yap"
            {
                do {
                    try Auth.auth().signOut()
                    
                    self?.performSegue(withIdentifier: "cikisYap", sender: nil)
                }
                catch {
                    print("Hata")
                }
            }
            if named == "Kullanıcı Ayarları"
            {
                self?.performSegue(withIdentifier: "kullaniciAyar", sender: nil)
            }
        })
    }
    
    
}

protocol MenuControllerDelegate {
    func didSelectMenuItem(named: String)
    
}
class MenuController: UITableViewController {
    public var delegate: MenuControllerDelegate?
    private let menuItems:  [String]
    init(with menuItems: [String])
    {
        self.menuItems = menuItems
        super.init(nibName: nil, bundle: nil)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .darkGray
        view.backgroundColor = .darkGray
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = menuItems[indexPath.row]
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .darkGray
        cell.contentView.backgroundColor = .darkGray
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedItem = menuItems[indexPath.row]
        delegate?.didSelectMenuItem(named: selectedItem)
        
        
        
    }
}
