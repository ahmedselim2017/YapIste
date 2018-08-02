//
//  UstKategoriVC.swift
//  YapIste
//
//  Created by Ahmed Selim Üzüm on 1.08.2018.
//  Copyright © 2018 Ahmed Selim Üzüm. All rights reserved.
//

import UIKit;
import CoreData;
import SwipeCellKit;
import ChameleonFramework;

class UstKategoriVC: UITableViewController,SwipeTableViewCellDelegate{

    var ustKategoriListe=[UstKategori]();
    let icerik=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        tableView.separatorStyle = .none;
        tableView.rowHeight=80
        
        verileriGetir(nil);
        
        navigationController?.navigationBar.barTintColor=#colorLiteral(red: 0.1052545831, green: 0.6784299016, blue: 0.9725491405, alpha: 1);
        navigationController?.navigationBar.tintColor=ContrastColorOf(#colorLiteral(red: 0.1052545831, green: 0.6784299016, blue: 0.9725491405, alpha: 1), returnFlat: true);
        navigationController?.navigationBar.largeTitleTextAttributes=[NSAttributedString.Key.foregroundColor:ContrastColorOf( #colorLiteral(red: 0.1052545831, green: 0.6784299016, blue: 0.9725491405, alpha: 1), returnFlat: true)];
        title="Yap İşte!";
    
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
                kategori.renk=RandomFlatColor().hexValue();
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
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
//        cell.delegate = self
//        return cell
//    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ustKategoriListe.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let hucre=tableView.dequeueReusableCell(withIdentifier: "ustKategoriHucresi") as! SwipeTableViewCell;
        
        hucre.delegate=self
        hucre.textLabel?.text=ustKategoriListe[indexPath.row].isim;
        hucre.backgroundColor=UIColor(hexString: ustKategoriListe[indexPath.row].renk!);
        hucre.textLabel?.textColor=ContrastColorOf(UIColor(hexString: ustKategoriListe[indexPath.row].renk!)!, returnFlat: true);
        return hucre;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "kategoriSegue", sender: self);
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let sonVC=segue.destination as! YapilacaklarVC;

        let indeks=tableView.indexPathForSelectedRow;
        
        sonVC.secilenKategori=self.ustKategoriListe[(indeks?.row)!];
        
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
    
    func kategoriSil(_ indeks:IndexPath){
        
          do{
            let istek:NSFetchRequest<Kategori>=Kategori.fetchRequest();
            istek.predicate=NSPredicate(format: "ustKategori MATCHES %@", (self.ustKategoriListe[indeks.row].isim)!);
            
            let liste:[Kategori]=try icerik.fetch(istek);
            
            if liste.count>0{
                for k in liste{
                    self.icerik.delete(k);
                }
                
            }
            self.icerik.delete(self.ustKategoriListe[indeks.row]);
            self.ustKategoriListe.remove(at: indeks.row);
            try icerik.save();

            
            
        }
          catch{
            print("HATA 130");
        }
        
        
    }
    
    
    
    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            self.kategoriSil(indexPath);
        }
        
        // customize the action appearance
        deleteAction.image = #imageLiteral(resourceName: "Trash Icon");
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
}

