//
//  CategoryData+CoreDataProperties.swift
//  Todoey
//
//  Created by Erencan Karadağ on 10.05.2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//
//
/*
import Foundation
import CoreData


extension CategoryData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryData> {
        return NSFetchRequest<CategoryData>(entityName: "CategoryData")
    }

    @NSManaged public var name: String?
    @NSManaged public var item: Item?

}
