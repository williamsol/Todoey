//
//  Item.swift
//  Todoey
//
//  Created by William Soliman on 5/7/18.
//  Copyright © 2018 William Soliman. All rights reserved.
//

import Foundation
import RealmSwift

// "Object" is a class used to define Realm model objects
class Item: Object {
    
    // "@objc dynamic" allows Realm to monitor any changes to the "title", "done" and "dateCreated" properties
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    
    // LinkingObjects defines the inverse relationship (from Item to Category)
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
