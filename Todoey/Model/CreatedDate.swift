//
//  CreatedDate.swift
//  Todoey
//
//  Created by Alan on 8/21/18.
//  Copyright © 2018 AlanG. All rights reserved.
//

import Foundation
import RealmSwift

class CreatedDate: Object {
    @objc dynamic var date = Data()
    
    var parentItem = LinkingObjects(fromType: Item.self, property: "createdDate")
}
