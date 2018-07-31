//
//  ViewController.swift
//  YapIste
//
//  Created by Ahmed Selim Üzüm on 28.07.2018.
//  Copyright © 2018 Ahmed Selim Üzüm. All rights reserved.
//

import UIKit

class GirisVC: UITableViewController {
    
    
    var kategorilerListesi=[Kategori]();

    let veriDosyaYolu=FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Kategoriler.plist");
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        print(veriDosyaYolu);
        
        let kategori1=Kategori(kategoritiAdi: "Uygulamayı Bitir", isaretlenmisMi: false);
        let kategori2=Kategori(kategoritiAdi: "Uygulafffmayı Bitir2", isaretlenmisMi: false);
        let kategori3=Kategori(kategoritiAdi: "ss Bitir3", isaretlenmisMi: false);
     
        
        
        
        kategorilerListesi.append(kategori1);
        kategorilerListesi.append(kategori2);
        kategorilerListesi.append(kategori3);

        
 
        
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kategorilerListesi.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let hucre=tableView.dequeueReusableCell(withIdentifier: "girisHucresi");
        hucre?.textLabel?.text=kategorilerListesi[indexPath.row].kategoriAdi;
        
        if kategorilerListesi[indexPath.row].isaretlenmisMi{
            hucre?.accessoryType=UITableViewCell.AccessoryType.checkmark;
            kategorilerListesi[indexPath.row].isaretDegistir(yeniIsaret: true);
        }
        else{
            hucre?.accessoryType=UITableViewCell.AccessoryType.none;
            kategorilerListesi[indexPath.row].isaretDegistir(yeniIsaret: false);
        }
        
        return hucre!;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row);
        if kategorilerListesi[indexPath.row].isaretlenmisMi{
            tableView.cellForRow(at: indexPath)?.accessoryType=UITableViewCell.AccessoryType.none;
            kategorilerListesi[indexPath.row].isaretDegistir(yeniIsaret: false);
        }
        else{
            tableView.cellForRow(at: indexPath)?.accessoryType=UITableViewCell.AccessoryType.checkmark;
            kategorilerListesi[indexPath.row].isaretDegistir(yeniIsaret: true);
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
                let kategori=Kategori(kategoritiAdi: alarm.textFields![0].text!, isaretlenmisMi: false);
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
        let encoder = PropertyListEncoder();
        do{
            let veri=try encoder.encode(self.kategorilerListesi);
            try veri.write(to: self.veriDosyaYolu!);
            
        }
        catch{
            print(error.localizedDescription);
        }
        self.tableView.reloadData();
    }
}

