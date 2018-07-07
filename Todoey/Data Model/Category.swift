//
//  Category.swift
//  Todoey
//
//  Created by William Soliman on 5/7/18.
//  Copyright © 2018 William Soliman. All rights reserved.
//

import Foundation
import RealmSwift

// "Object" is a class that is used to define Realm model objects
// You can think of "Category" as a generic line item / row in the database
class Category: Object {
    
    // "@objc dynamic" keyword allows Realm to monitor any changes to the "name" and "colour" properties
    @objc dynamic var name : String = ""
    @objc dynamic var colour : String = ""
    
    // "List" is the container type in Realm that is used to define to-many relationships (in this case, from Category to Item)
    // Note that, once you have "read" all Category objects from Realm, you will be able to access its "items" simply with the dot operator
    let items = List<Item>()
    
}
