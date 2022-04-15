//
//  User.swift
//  sharest
//
//  Created by Faisal Jaffri on 4/1/22.
//

import Foundation
import UIKit
class User: Decodable, Encodable{
    var uuid:String = ""
    var firstName:String = ""
    var lastName:String = ""
    var emailAddress:String = ""
    var profileImageURL:String = ""
}

class UserInsight : Decodable {
    var numInteractions = 0
    var numAsks = 0
    var numPasses = 0
    var numPosts = 0
}
