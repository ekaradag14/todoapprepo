//
//  Category.swift
//  Todoey
//
//  Created by Erencan Karadağ on 11.05.2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category:Object {
    
    @objc dynamic var name:String = ""
  let items = List<Item>() // burası bir relational data decleration'ı
//    let array = Array<Int>() burada farklı bir syntax ile boş bir array initiliaze ediyoruz. Bunu yukardakinin de aslında çok farklı bir şey olmadığını göstermek için yaptık
}
