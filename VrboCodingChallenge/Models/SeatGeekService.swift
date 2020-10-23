//
//  SeatGeekService.swift
//  VrboCodingChallenge
//
//  Created by Matthew Waller on 10/22/20.
//

import SwiftUI
import Combine
import os.log

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!
    
    static let network = Logger(subsystem: subsystem, category: "network")
}

class SeatGeekService: ObservableObject {
    enum Endpoint: String {
        case seatGeek = "api.seatgeek.com"
    }
    
    enum APIError: Error, LocalizedError {
        case sessionFailed(error: URLError)
        case decodingFailed
        case other(Error)
        
        var errorDescription: String? {
            switch self {
            case .sessionFailed(let error):
                return error.localizedDescription
            case .decodingFailed:
                return "Decoding Failed"
            case .other(let error):
                return error.localizedDescription
            }
        }
    }
    
    private let clientID = "MjEzNjI0ODB8MTYwMzM4MzE5Ni4zMjM4OTE5"
    private var cancellables = Set<AnyCancellable>()
    private var searchEvents = PassthroughSubject<String, Never>()
    private let decoder: JSONDecoder
    
    /// Use this as a publisher to receive the list of events
    @Published var events: [SeatGeekEvent] = []
    
    init() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let initialDecoder = JSONDecoder()
        initialDecoder.dateDecodingStrategy = .formatted(formatter)
        decoder = initialDecoder
        
        searchEvents
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .sink { [weak self] text in
            self?.searchEvents(withText: text)
        }
        .store(in: &cancellables)
        
        getAllEvents()
    }
    
    /// Use this method to search for events
    ///
    /// - Parameters:
    ///     - event: The search string you want to submit for the event.
    func search(event: String) {
        searchEvents.send(event)
    }
    
    /// Use this method to get the default events
    func getAllEvents() {
        guard let url = baseComponents.url else {
            return
        }
        
        getEvents(url: url) { [weak self] (response: SeatGeekResponse) in
            withAnimation {
                self?.events = response.events
            }
        }
    }
    
    private var baseComponents: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = Endpoint.seatGeek.rawValue
        components.path = "/2/events"
        let token = URLQueryItem(name: "client_id", value: clientID)
        components.queryItems = [token]
        return components
    }
    
    private func searchEvents(withText text: String) {
        var components = baseComponents
        let searchString = URLQueryItem(name: "q", value: text)
        components.queryItems?.append(searchString)
        
        guard let url = components.url else {
            return
        }
        
        getEvents(url: url) { [weak self] (response: SeatGeekResponse) in
            withAnimation {
                self?.events = response.events
            }
        }
    }
    
    private func getEvents<V: Codable>(url: URL, completion: @escaping (V) -> Void) {
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
              .decode(type: V.self, decoder: decoder)
            .mapError({ error -> APIError in
                switch error {
                case is Swift.DecodingError:
                  return .decodingFailed
                case let urlError as URLError:
                  return .sessionFailed(error: urlError)
                default:
                  return .other(error)
                }
              })
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    Logger.network.error("getAllEvents: \(error.localizedDescription)")
                }
            } receiveValue: { eventResponse in
                completion(eventResponse)
            }
            .store(in: &cancellables)
    }
}
