//
//  DataModel.swift
//  persistentDataTest
//
//  Created by Kiran Kishore on 18/08/19.
//  Copyright © 2019 CDNS. All rights reserved.
//

import Foundation


class Item : Encodable, Decodable{ // or adopt 'Codable' protocol
    
    var itemName : String = ""
    var done : Bool = false
    
    
}
