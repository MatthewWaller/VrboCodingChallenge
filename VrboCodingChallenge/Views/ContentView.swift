//
//  ContentView.swift
//  VrboCodingChallenge
//
//  Created by Matthew Waller on 10/22/20.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var service: SeatGeekService
    @State private var searchText: String = ""
    
    init() {
        setNavigationColors()
    }
    
    private func searchEvents(text: String) {
        if text.isEmpty {
            return
        }
        
        service.search(event: text)
    }
    
    private func searchCancelled() {
        service.getAllEvents()
    }
    
    private func setNavigationColors() {
        let backgroundColor = UIColor(red: 17/255,
                                      green: 49/255,
                                      blue: 70/255,
                                      alpha: 1)
        let titleColor: UIColor = .white
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.backgroundColor = backgroundColor
        coloredAppearance.titleTextAttributes = [.foregroundColor: titleColor]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: titleColor]

        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if service.events.isEmpty {
                    ProgressView()
                } else {
                    List(service.events) { event in
                        NavigationLink(
                            destination: EventDetail(event: event),
                            label: {
                                EventRow(event: event)
                            }
                        )
                    }
                }
            }
            .listStyle(PlainListStyle())
            .navigationBarSearch($searchText, didSearch: searchEvents, didCancel: searchCancelled)
            .navigationTitle(Text("Events"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
