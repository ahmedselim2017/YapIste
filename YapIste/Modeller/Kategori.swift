//
//  Kategori.swift
//  YapIste
//
//  Created by Ahmed Selim Üzüm on 31.07.2018.
//  Copyright © 2018 Ahmed Selim Üzüm. All rights reserved.
//

import Foundation;

class Kategori {
    private var _kategoriAdi:String;
    private var _isaretlenmisMi:Bool;
    
    var kategoriAdi:String{
        return _kategoriAdi;
    }
    var isaretlenmisMi:Bool{
        return _isaretlenmisMi;
    }
    
    init(kategoritiAdi:String,isaretlenmisMi:Bool) {
        self._isaretlenmisMi=isaretlenmisMi;
        self._kategoriAdi=kategoritiAdi;
    }
    
    func isaretDegistir(yeniIsaret:Bool){
        self._isaretlenmisMi=yeniIsaret;
    }
    
}
