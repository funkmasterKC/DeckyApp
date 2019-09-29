//
//  Deck.swift
//  Decky
//
//  Created by Armando Torres on 9/28/19.
//  Copyright © 2019 Funkmasters Inc. All rights reserved.
//

import Foundation
import RealmSwift

class Deck: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    let cards = List<Card>()
}
