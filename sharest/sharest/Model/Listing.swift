//
//  Listing.swift
//  sharest
//
//  Created by Cole Hutson on 4/13/22.
//

import Foundation

class Listing: Decodable, Encodable {
    var listingID: String = ""
    var itemName: String = ""
    var uuid: String = ""
    var description: String = ""
    var datePosted : String = ""
    var imageURL: String = ""
}

class Interaction : Encodable {
    var listingID = 0
    var ownerID = ""
    var interactorID = ""
    var didPass = true
}
