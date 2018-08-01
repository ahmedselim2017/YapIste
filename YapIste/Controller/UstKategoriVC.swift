//
//  UstKategoriVC.swift
//  YapIste
//
//  Created by Ahmed Selim Üzüm on 1.08.2018.
//  Copyright © 2018 Ahmed Selim Üzüm. All rights reserved.
//

import UIKit;
import CoreData;

class UstKategoriVC: UITableViewController {

    var ustKategoriListe=[UstKategori]();
    let icerik=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        verileriGetir(nil);
    }

    @IBAction func btnEkleBasildi(_ sender: Any) {
        
        let alarm=UIAlertController(title: "Yeni Kategori Ekle", message: "", preferredStyle: .alert);
        
        let aksiyon=UIAlertAction(title: "Yeni Kategori Ekle", style: .default) { (aksiyon) in
            if alarm.textFields![0].text==""{
                self.present(alarm, animated: true, completion: nil);
            }
            else{
                let kategori=UstKategori(context: self.icerik);
                kategori.isim=alarm.textFields![0].text!;
                self.ustKategoriListe.append(kategori);
                self.verileriYaz();
                
            }
        }
        
        let aksiyonGeri=UIAlertAction(title: "Geri Dön", style: UIAlertAction.Style.destructive) { (aksiyon) in
            alarm.dismiss(animated: true, completion: nil);
        }
        
        
        alarm.addAction(aksiyon);
        alarm.addAction(aksiyonGeri);
        alarm.addTextField { (txt) in
            txt.placeholder="Lütfen Kategorinin Adını Giriniz";
        }
        self.present(alarm, animated: true);
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ustKategoriListe.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let hucre=tableView.dequeueReusableCell(withIdentifier: "ustKategoriHucresi") as? UITableViewCell;
        
        hucre?.textLabel?.text=ustKategoriListe[indexPath.row].isim;
        
        return hucre!;
    }
    
    
    
    func verileriYaz(){
        do{
            try icerik.save();
        }
        catch{
            print("VERİ YAZILAMADI");
        }
        self.tableView.reloadData();
    }
    
    func verileriGetir(_ verilenIstek:NSFetchRequest<UstKategori>?){
        do{
            if verilenIstek==nil{
                let istek:NSFetchRequest<UstKategori>=UstKategori.fetchRequest();
                ustKategoriListe=try icerik.fetch(istek);
            }
            else{
                ustKategoriListe=try icerik.fetch(verilenIstek!);
            }
            self.tableView.reloadData();
        }
        catch{
            print("VERİ GETİRİLEMEDİ");
        }
    }
    
    
    
}
