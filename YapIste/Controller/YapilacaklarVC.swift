//
//  ViewController.swift
//  YapIste
//
//  Created by Ahmed Selim Üzüm on 28.07.2018.
//  Copyright © 2018 Ahmed Selim Üzüm. All rights reserved.
//

import UIKit;
import CoreData;
import SwipeCellKit;
import ChameleonFramework;

class YapilacaklarVC: UITableViewController ,SwipeTableViewCellDelegate{
    
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
        
        
        tableView.rowHeight=80;
        tableView.separatorStyle = .none;
        aramaBari.delegate=self;
        verileriGetir(nil,nil);
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor=UIColor(hexString: (secilenKategori?.renk)!);
        navigationController?.navigationBar.tintColor=ContrastColorOf(UIColor(hexString: (secilenKategori?.renk)!)!, returnFlat: true);
        navigationController?.navigationBar.largeTitleTextAttributes=[NSAttributedString.Key.foregroundColor:ContrastColorOf(UIColor(hexString: (secilenKategori?.renk)!)!, returnFlat: true)];
        title=secilenKategori?.isim;
        aramaBari.barTintColor=UIColor(hexString: (secilenKategori?.renk)!);
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor=#colorLiteral(red: 0.1052545831, green: 0.6784299016, blue: 0.9725491405, alpha: 1);
        navigationController?.navigationBar.tintColor=ContrastColorOf(#colorLiteral(red: 0.1052545831, green: 0.6784299016, blue: 0.9725491405, alpha: 1), returnFlat: true);
        navigationController?.navigationBar.largeTitleTextAttributes=[NSAttributedString.Key.foregroundColor:ContrastColorOf( #colorLiteral(red: 0.1052545831, green: 0.6784299016, blue: 0.9725491405, alpha: 1), returnFlat: true)];
            title="Yap İşte!";
    }
    
    
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kategorilerListesi.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let hucre=tableView.dequeueReusableCell(withIdentifier: "girisHucresi") as! SwipeTableViewCell;
        
        hucre.delegate=self;
        
        if kategorilerListesi.count>0{
            
            hucre.textLabel?.text=kategorilerListesi[indexPath.row].kategoriAdi;
            
            if kategorilerListesi[indexPath.row].isaretlenmisMi{
                hucre.accessoryType=UITableViewCell.AccessoryType.checkmark;
                kategorilerListesi[indexPath.row].isaretlenmisMi=true;
            }
            else{
                hucre.accessoryType=UITableViewCell.AccessoryType.none;
                kategorilerListesi[indexPath.row].isaretlenmisMi=false;
            }
            
            hucre.backgroundColor=UIColor(hexString: (secilenKategori?.renk)!)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(kategorilerListesi.count));
            hucre.textLabel?.textColor=ContrastColorOf(hucre.backgroundColor!, returnFlat: true);
        }
        
        else{
            hucre.textLabel?.text="Bişey Eklenmedi Daha";
        }
        
        return hucre;
    }
    
   
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {


        
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
    
    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            self.icerik.delete(self.kategorilerListesi[indexPath.row]);
            self.kategorilerListesi.remove(at: indexPath.row);
            do{
                try self.icerik.save();
            }
            catch{
                print("VERİ YAZILAMADI");
            }
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
