//
//  ViewController.swift
//  YapIste
//
//  Created by Ahmed Selim Üzüm on 28.07.2018.
//  Copyright © 2018 Ahmed Selim Üzüm. All rights reserved.
//

import UIKit

class GirisVC: UITableViewController {
    
    let kategorilerListesi=["Uygulamayı Bitir","Kursu Bitir","Diğer Kursları Da Bitir"];
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kategorilerListesi.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let hucre=tableView.dequeueReusableCell(withIdentifier: "girisHucresi");
        hucre?.textLabel?.text=kategorilerListesi[indexPath.row];
        return hucre!;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row);
        if tableView.cellForRow(at: indexPath)?.accessoryType==UITableViewCell.AccessoryType.checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType=UITableViewCell.AccessoryType.none;
        }
        else{
            tableView.cellForRow(at: indexPath)?.accessoryType=UITableViewCell.AccessoryType.checkmark;
        }
        tableView.deselectRow(at: indexPath, animated: true);
    }

}

