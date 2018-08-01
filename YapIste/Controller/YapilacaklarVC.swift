//
//  ViewController.swift
//  YapIste
//
//  Created by Ahmed Selim Üzüm on 28.07.2018.
//  Copyright © 2018 Ahmed Selim Üzüm. All rights reserved.
//

import UIKit;
import CoreData;

class YapilacaklarVC: UITableViewController {
    
    var secilenKategori:UstKategori?{
        didSet{
            print(secilenKategori?.isim);
        }
    }
    
    @IBOutlet weak var aramaBari: UISearchBar!
    
    var kategorilerListesi=[Kategori]();

    let veriDosyaYolu=FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Kategoriler.plist");
    let icerik=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        aramaBari.delegate=self;
        verileriGetir(nil,nil);
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

//        icerik.delete(kategorilerListesi[indexPath.row]);
//        kategorilerListesi.remove(at: indexPath.row);
        
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
        
        
        
        let alarm=UIAlertController(title: "Yeni Yapılacak Ekle", message: "", preferredStyle: .alert);
        
        let aksiyonGeri=UIAlertAction(title: "Geri Dön", style: UIAlertAction.Style.destructive) { (aksiyon) in
            alarm.dismiss(animated: true, completion: nil);
        }
        
        let aksiyon=UIAlertAction(title: "Yeni Yapılacak Ekle", style: .default) { (aksiyon) in
            if alarm.textFields![0].text==""{
                self.present(alarm, animated: true, completion: nil);
            }
            else{
                print(alarm.textFields![0].text!);
                let kategori=Kategori(context: self.icerik);
                kategori.isaretlenmisMi=false;
                kategori.kategoriAdi=alarm.textFields![0].text!;
                kategori.ustKategori=self.secilenKategori?.isim;
                self.kategorilerListesi.append(kategori);

                self.verileriYaz();
                
            }
        }
        alarm.addTextField { (txt) in
            txt.placeholder="Yeni Yapılacağın Adı";
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
    
    func verileriGetir(_ verilenIstek:NSFetchRequest<Kategori>?,_ sorgu:NSPredicate?){
        do{
            if verilenIstek==nil{
                let istek:NSFetchRequest<Kategori>=Kategori.fetchRequest();
                istek.predicate=NSPredicate(format: "ustKategori MATCHES %@", (secilenKategori?.isim)!);
                kategorilerListesi=try icerik.fetch(istek);
            }
            else{
                
                verilenIstek?.predicate=NSCompoundPredicate.init(andPredicateWithSubpredicates: [sorgu!,NSPredicate(format: "ustKategori MATCHES %@", (secilenKategori?.isim)!)]);
                
                kategorilerListesi=try icerik.fetch(verilenIstek!);
            }
            self.tableView.reloadData();
        }
        catch{
            print("VERİ GETİRİLEMEDİ");
        }
    }
    
    
    func kategoriAra(_ metin:String){
        let istek:NSFetchRequest<Kategori>=Kategori.fetchRequest();
        
       
        
        istek.sortDescriptors=[NSSortDescriptor(key: "kategoriAdi", ascending: true)];
        verileriGetir(istek,NSPredicate(format: "kategoriAdi CONTAINS[cd] %@", metin));
    }
  
}

extension YapilacaklarVC:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        kategoriAra(searchBar.text!);
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            verileriGetir(nil,nil);
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder();
            }
        }
        else{
            kategoriAra(searchBar.text!);
        }
    }

}
