//
//  User.swift
//  WaysToMakeAsynchronousAPICalls
//
//  Created by Eknath Kadam on 9/19/22.
//

import Foundation

struct User : Codable, Identifiable {
    var id: Int
    var name: String = ""
    
}
