//
//  ViewController.swift
//  YapIste
//
//  Created by Ahmed Selim Üzüm on 28.07.2018.
//  Copyright © 2018 Ahmed Selim Üzüm. All rights reserved.
//

import UIKit

class GirisVC: UITableViewController {
    
    
//    let varsayilanlar=UserDefaults.standard;
    var kategorilerListesi=[Kategori]();

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let kategori1=Kategori(kategoritiAdi: "Uygulamayı Bitir", isaretlenmisMi: false);
        let kategori2=Kategori(kategoritiAdi: "Uygulafffmayı Bitir2", isaretlenmisMi: false);
        let kategori3=Kategori(kategoritiAdi: "ss Bitir3", isaretlenmisMi: false);
        let kategori4=Kategori(kategoritiAdi: "d Bitir", isaretlenmisMi: false);
        let kategori5=Kategori(kategoritiAdi: "d c", isaretlenmisMi: false);
        let kategori6=Kategori(kategoritiAdi: "c Bitir3", isaretlenmisMi: false);
        let kategori7=Kategori(kategoritiAdi: "Uygulamayı Bitir", isaretlenmisMi: false);
        let kategori8=Kategori(kategoritiAdi: "x Bitir2", isaretlenmisMi: false);
        let kategori9=Kategori(kategoritiAdi: "c <", isaretlenmisMi: false);
        let kategori10=Kategori(kategoritiAdi: "z Bitir", isaretlenmisMi: false);
        let kategori11=Kategori(kategoritiAdi: "v Bitir2", isaretlenmisMi: false);
        let kategori12=Kategori(kategoritiAdi: "Uygulamayı Bitir3", isaretlenmisMi: false);
        let kategori13=Kategori(kategoritiAdi: "Uygulamayı Bitir", isaretlenmisMi: false);
        let kategori14=Kategori(kategoritiAdi: "v Bitir2", isaretlenmisMi: false);
        let kategori15=Kategori(kategoritiAdi: "Uygulamayı w", isaretlenmisMi: false);
        let kategori16=Kategori(kategoritiAdi: "a", isaretlenmisMi: false);
        let kategori17=Kategori(kategoritiAdi: "1 Bitir2", isaretlenmisMi: false);
        let kategori18=Kategori(kategoritiAdi: "2 1", isaretlenmisMi: false);
        let kategori19=Kategori(kategoritiAdi: "v Bitir2", isaretlenmisMi: false);
        let kategori20=Kategori(kategoritiAdi: "Uygulamsayı Bitir3", isaretlenmisMi: false);
        let kategori21=Kategori(kategoritiAdi: "Uygulamswayı Bitir", isaretlenmisMi: false);
        let kategori22=Kategori(kategoritiAdi: "v Bitir2", isaretlenmisMi: false);
        let kategori23=Kategori(kategoritiAdi: "e w", isaretlenmisMi: false);
        let kategori24=Kategori(kategoritiAdi: "1", isaretlenmisMi: false);
        let kategori25=Kategori(kategoritiAdi: "1 2", isaretlenmisMi: false);
        let kategori26=Kategori(kategoritiAdi: "2 1", isaretlenmisMi: false);
        
        kategorilerListesi.append(kategori1);
        kategorilerListesi.append(kategori2);
        kategorilerListesi.append(kategori3);
        kategorilerListesi.append(kategori4);
        kategorilerListesi.append(kategori5);
        kategorilerListesi.append(kategori6);
        kategorilerListesi.append(kategori7);
        kategorilerListesi.append(kategori8);
        kategorilerListesi.append(kategori9);
        kategorilerListesi.append(kategori10);
        kategorilerListesi.append(kategori11);
        kategorilerListesi.append(kategori12);
        kategorilerListesi.append(kategori13);
        kategorilerListesi.append(kategori14);
        kategorilerListesi.append(kategori15);
        kategorilerListesi.append(kategori16);
        kategorilerListesi.append(kategori17);
        kategorilerListesi.append(kategori18);
        kategorilerListesi.append(kategori19);
        kategorilerListesi.append(kategori20);
        kategorilerListesi.append(kategori21);
        kategorilerListesi.append(kategori22);
        kategorilerListesi.append(kategori23);
        kategorilerListesi.append(kategori24);
        kategorilerListesi.append(kategori25);
        kategorilerListesi.append(kategori26);
//        if nil != varsayilanlar.array(forKey: "YapilacaklarKategorileri"){
//            kategorilerListesi=varsayilanlar.array(forKey: "YapilacaklarKategorileri")  as! [String];
//        }
        
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
//                self.varsayilanlar.set(self.kategorilerListesi, forKey: "YapilacaklarKategorileri");
                self.tableView.reloadData();
                
            }
        }
        alarm.addTextField { (txt) in
            txt.placeholder="Yeni Listenin Adı";
        }
        alarm.addAction(aksiyon);
        alarm.addAction(aksiyonGeri);
        present(alarm, animated: true, completion: nil);
        
    }
}

