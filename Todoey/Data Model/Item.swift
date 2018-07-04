//
//  Item.swift
//  Todoey
//
//  Created by William Soliman on 3/7/18.
//  Copyright © 2018 William Soliman. All rights reserved.
//

import Foundation

// Conform to the Codable protocols, so that the Item type can be encoded and stored in a .plist file, and also be decoded into the Item type
// The Codable protocol is short for the Encodable, Decodable protocols
class Item: Codable {
    var title : String = ""
    var done : Bool = false
}
