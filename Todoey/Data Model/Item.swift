//
//  Item.swift
//  Todoey
//
//  Created by Andre Keuck on 4/27/18.
//  Copyright © 2018 Andre Keuck. All rights reserved.
//

import Foundation

class Item: Codable { //create a class called Item that is encodable/decodable ("codable") into JSON (ALL properties must be of standard data types)
    var title : String = "" //titles are empty by default
    var done : Bool = false //items are not done by default
}
