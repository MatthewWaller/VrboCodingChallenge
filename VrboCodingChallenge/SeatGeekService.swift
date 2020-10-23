//
//  SeatGeekService.swift
//  VrboCodingChallenge
//
//  Created by Matthew Waller on 10/22/20.
//

import SwiftUI
import Combine

class SeatGeekService: ObservableObject {
    private let clientID = "MjEzNjI0ODB8MTYwMzM4MzE5Ni4zMjM4OTE5"
    @Published var events: [SeatGeekEvent] = []
    
    enum Endpoint: String {
        case seatGeek = "api.seatgeek.com"
    }
    
    init() {
        getAllEvents()
    }
    
    func getAllEvents() {
        var components = URLComponents()
        components.scheme = "https"
        components.host = Endpoint.seatGeek.rawValue
        components.path = "/2/events"
        let token = URLQueryItem(name: "client_id", value: clientID)
        components.queryItems = [token]
        
        guard let url = components.url else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            self?.handle(data: data, andResponse: response)
        }.resume()
    }
    
    func handle(data: Data?, andResponse response: URLResponse?) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(formatter)
            
        guard let data = data else {
            return
        }
                
        do {
            let eventsToUse = try decoder.decode(SeatGeekResponse.self, from: data).events
            DispatchQueue.main.async { [weak self] in
                withAnimation {
                    self?.events = eventsToUse
                }
            }
        } catch {
            // TODO handle error logging
            print(error)
        }
    }
}

struct SeatGeekResponse: Codable {
    let events: [SeatGeekEvent]
}

struct SeatGeekEvent: Codable, Identifiable {
    let id = UUID()
    let title: String?
    let url: URL?
    let dateTimeLocal: Date
    let performers: [Performer]
    let venue: Venue
    let timeTBD: Bool?
    let dateTBD: Bool?
    
    enum CodingKeys: String, CodingKey {
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
