//
//  SeatGeekModels.swift
//  VrboCodingChallenge
//
//  Created by Matthew Waller on 10/23/20.
//

import Foundation

// Find details here: http://platform.seatgeek.com

struct SeatGeekResponse: Codable {
    let events: [SeatGeekEvent]
}

struct SeatGeekEvent: Codable, Identifiable {
    let id: Int
    let title: String?
    let url: URL?
    let dateTimeLocal: Date
    let performers: [Performer]
    let venue: Venue
    let timeTBD: Bool?
    let dateTBD: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case url
        case dateTimeLocal = "datetime_local"
        case performers
        case venue
        case timeTBD = "time_tbd"
        case dateTBD = "date_tbd"
    }
}

struct Performer: Codable {
    let name: String
    let image: URL?
}

struct Venue: Codable {
    let city: String
    let name: String
    let state: String?
    let country: String
    let address: String?
    let extendedAddress: String?
    
    enum CodingKeys: String, CodingKey {
        case city
        case name
        case state
        case country
        case address
        case extendedAddress = "extended_address"
    }
}
