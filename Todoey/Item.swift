//
//  Item.swift
//  Todoey
//
//  Created by Erencan Karadağ on 11.05.2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item:Object {
    
    @objc dynamic var title:String = ""
    @objc dynamic var done:Bool = false
    @objc dynamic var date: Double = Date().timeIntervalSince1970
      @objc dynamic var color:String = ""
//    @objc dynamic var dateAsTimeStamp: Date? Burada da timestamp olarak kullanmak istersek nasıl kullanabileceğimiz var
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items") // Sadece Category yazarsak type olmaz class olur eğer Category.sel yazarsak type olur. Burada da baba ilişkisini gösteriyoruz items dediğimiz child relation adı
}
