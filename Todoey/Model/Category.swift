//
//  Data.swift
//  Todoey
//
//  Created by Alan on 8/20/18.
//  Copyright © 2018 AlanG. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    var items = List<Item>()
}
