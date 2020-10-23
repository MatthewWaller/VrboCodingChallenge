//
//  EventDetail.swift
//  VrboCodingChallenge
//
//  Created by Matthew Waller on 10/22/20.
//

import SwiftUI
import KingfisherSwiftUI

struct EventDetail: View {
    @AppStorage("favorites") var favoritesStorage: Data = Data()
    
    var favorites: [Int] {
        let strings = try? JSONSerialization.jsonObject(with: favoritesStorage, options: []) as? [Int]
        return strings ?? []
    }
    
    var event: SeatGeekEvent
    
    var isFavorite: Bool {
        favorites.contains(event.id)
    }
    
    func setFavorite() {
        var newFavorites = favorites
        if isFavorite {
            newFavorites.removeAll {
                $0 == event.id
            }
        } else {
            newFavorites.append(event.id)
        }
        
        if let data = try? JSONSerialization.data(withJSONObject: newFavorites, options: []) {
            favoritesStorage = data
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if let title = event.title {
                    Text(title)
                        .font(Font.largeTitle.weight(.bold))
                        .padding(16)
                    Divider()
                }
                VStack {
                    if let imageURL = event.performers.first?.image {
                        KFImage(imageURL)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity)
                            .cornerRadius(8)
                            
                    }
                }
                .padding(16)
                VStack(alignment: .leading, spacing: 8) {
                    if let date = event.dateTimeLocal {
                        Text(DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .medium))
                            .font(Font.title2.weight(.bold))
                    }
                    VStack(alignment: .leading) {
                        if let city = event.venue.city,
                           let state = event.venue.state {
                            Text("\(city), \(state)")
                            
                        } else if let city = event.venue.city {
                            Text(city)
                            
                        } else if let state = event.venue.state {
                            Text(state)
                        }
                    }
                    .font(.body)
                    .foregroundColor(.gray)
                }
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16))
                Spacer()
            }
        }
        .navigationBarTitle(Text("Event Details"), displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            setFavorite()
        }, label: {
            VStack {
                if isFavorite {
                    Image(systemName: "heart.fill")
                        .font(.title)
                        .foregroundColor(.red)
                } else {
                    Image(systemName: "heart")
                        .font(.title)
                        .foregroundColor(.red)
                }
            }
        }))
    }
}
