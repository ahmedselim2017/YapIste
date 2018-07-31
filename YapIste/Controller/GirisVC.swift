//
//  ViewController.swift
//  YapIste
//
//  Created by Ahmed Selim Üzüm on 28.07.2018.
//  Copyright © 2018 Ahmed Selim Üzüm. All rights reserved.
//

import UIKit;
import CoreData;

class GirisVC: UITableViewController {
    
    
    var kategorilerListesi=[Kategori]();

    let veriDosyaYolu=FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Kategoriler.plist");
    let icerik=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        print(veriDosyaYolu);


        
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kategorilerListesi.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let hucre=tableView.dequeueReusableCell(withIdentifier: "girisHucresi");
        hucre?.textLabel?.text=kategorilerListesi[indexPath.row].kategoriAdi;
        
        if kategorilerListesi[indexPath.row].isaretlenmisMi{
            hucre?.accessoryType=UITableViewCell.AccessoryType.checkmark;
            kategorilerListesi[indexPath.row].isaretlenmisMi=true;
        }
        else{
            hucre?.accessoryType=UITableViewCell.AccessoryType.none;
            kategorilerListesi[indexPath.row].isaretlenmisMi=false;
        }
        
        return hucre!;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row);
        if kategorilerListesi[indexPath.row].isaretlenmisMi{
            tableView.cellForRow(at: indexPath)?.accessoryType=UITableViewCell.AccessoryType.none;
            kategorilerListesi[indexPath.row].isaretlenmisMi=false;
        }
        else{
            tableView.cellForRow(at: indexPath)?.accessoryType=UITableViewCell.AccessoryType.checkmark;
            kategorilerListesi[indexPath.row].isaretlenmisMi=true;
        }
        tableView.deselectRow(at: indexPath, animated: true);
        verileriYaz();
    }

    @IBAction func btnYeniSeyEkleBasildi(_ sender: UIBarButtonItem) {
        
        
        
        let alarm=UIAlertController(title: "Yeni Kategori Ekle", message: "", preferredStyle: .alert);
        
        let aksiyonGeri=UIAlertAction(title: "Geri Dön", style: UIAlertAction.Style.destructive) { (aksiyon) in
            alarm.dismiss(animated: true, completion: nil);
        }
        
        let aksiyon=UIAlertAction(title: "Yeni Kategori Ekle", style: .default) { (aksiyon) in
            if alarm.textFields![0].text==""{
                self.present(alarm, animated: true, completion: nil);
            }
            else{
                print(alarm.textFields![0].text!);
                let kategori=Kategori(context: self.icerik);
                kategori.isaretlenmisMi=false;
                kategori.kategoriAdi=alarm.textFields![0].text!;
                self.kategorilerListesi.append(kategori);

                self.verileriYaz();
                
            }
        }
        alarm.addTextField { (txt) in
            txt.placeholder="Yeni Listenin Adı";
        }
        alarm.addAction(aksiyon);
        alarm.addAction(aksiyonGeri);
        present(alarm, animated: true, completion: nil);
        
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
    
//    func verileriGetir(){
//        guard let veri = try? Data(contentsOf: veriDosyaYolu!) else{return;}
//        let decoder=PropertyListDecoder();
//        do{
//            kategorilerListesi=try decoder.decode([Kategori].self, from: veri);
//        }
//        catch{
//            print(error.localizedDescription);
//        }
//    }
}

