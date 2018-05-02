//
//  Item.swift
//  Todoey
//
//  Created by Andre Keuck on 5/1/18.
//  Copyright © 2018 Andre Keuck. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated: Date? 
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items") //the inverse/linking connection to the relationship established in Category.swift
}
