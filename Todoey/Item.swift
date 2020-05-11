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
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items") // Sadece Category yazarsak type olmaz class olur eğer Category.sel yazarsak type olur. Burada da baba ilişkisini gösteriyoruz items dediğimiz child relation adı
}
