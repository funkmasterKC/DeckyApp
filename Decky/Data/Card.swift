//
//  Card.swift
//  Decky
//
//  Created by Armando Torres on 9/28/19.
//  Copyright © 2019 Funkmasters Inc. All rights reserved.
//

import Foundation
import RealmSwift

class Card: Object{
    
    @objc dynamic var name: String = ""
    @objc dynamic var done: Bool = false
    
}
