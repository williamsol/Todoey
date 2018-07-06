//
//  Category.swift
//  Todoey
//
//  Created by William Soliman on 5/7/18.
//  Copyright © 2018 William Soliman. All rights reserved.
//

import Foundation
import RealmSwift

// "Object" is a class used to define Realm model objects
class Category: Object {
    
    // "@objc dynamic" allows Realm to monitor any changes to the "name" property
    @objc dynamic var name : String = ""
    
    // List is the container type in Realm used to define to-many relationships (from Category to Item)
    let items = List<Item>()
    
}
