//
//  Persistance.swift
//  HomeWork14
//
//  Created by Victor Doshchenko on 21.02.2020.
//  Copyright © 2020 Victor Doshchenko. All rights reserved.
//

import Foundation
import RealmSwift

class Persistance {
    static let shared = Persistance()
       
    private let kUserFirstNameKey = "Persistance.kUserFirstNameKey"
    private let kUserLastNameKey = "Persistance.kUserLastNameKey"

    var userFirstName: String? {
        set { UserDefaults.standard.set(newValue, forKey: kUserFirstNameKey)}
        get { return UserDefaults.standard.string(forKey: kUserFirstNameKey) }
    }

    var userLastName: String? {
        set { UserDefaults.standard.set(newValue, forKey: kUserLastNameKey)}
        get { return UserDefaults.standard.string(forKey: kUserLastNameKey) }
    }
    
}

class TodoTask: Object {
    @objc dynamic var info = ""
}

class WeatherForecast: Object {
    @objc dynamic var info = ""
    @objc dynamic var image: Data?
}
