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
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = Theme.navigationBackground
        appearance.titleTextAttributes = [.foregroundColor: Theme.navigationTint]
        appearance.largeTitleTextAttributes = [.foregroundColor: Theme.navigationTint]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
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
