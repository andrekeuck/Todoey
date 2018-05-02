//
//  Category.swift
//  Todoey
//
//  Created by Andre Keuck on 5/1/18.
//  Copyright © 2018 Andre Keuck. All rights reserved.
//

import Foundation
import RealmSwift //import RealmSwift

class Category: Object { //create class called Category with Superclass Object which is a Realm Object
    @objc dynamic var name : String = "" //creates a variabe/property called "Name". Since it's a Realm object we have to include the @objc. The 'dynamic' means it's a variable that can be updated while the app is running.
    let items = List<Item>() //create a relationship with "child" items, via a list of items (similar to an array) containing data of type Item (set in our Item.swift file)
    
}


