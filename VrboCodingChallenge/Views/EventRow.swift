//
//  EventRow.swift
//  VrboCodingChallenge
//
//  Created by Matthew Waller on 10/22/20.
//

import SwiftUI
import KingfisherSwiftUI
import Kingfisher

struct EventRow: SwiftUI.View {
    @AppStorage("favorites") var favoritesStorage: Data = Data()
    
    var favorites: [Int] {
        let strings = try? JSONSerialization.jsonObject(with: favoritesStorage, options: []) as? [Int]
        return strings ?? []
    }
    
    var isFavorite: Bool {
        favorites.contains(event.id)
    }
    
    var event: SeatGeekEvent
    private let options: KingfisherOptionsInfo = [
        .processor(ResizingImageProcessor(referenceSize: .init(width: 60, height: 60),
                                          mode: .aspectFill))
    ]
    
    var body: some SwiftUI.View {
        ZStack(alignment: .leading) {
            HStack(alignment: .top, spacing: 24) {
                ZStack {
                    if let imageURL = event.performers.first?.image {
                        KFImage(imageURL, options: options)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 60, height: 60)
                            .cornerRadius(8)
                            .clipped()
                    } else {
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 60)
                            .cornerRadius(8)
                            .clipped()
                    }
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(event.title ?? "")
                        .font(.body)
                        .lineLimit(1)
                    VStack(alignment: .leading, spacing: 4) {
                        if let city = event.venue.city,
                           let state = event.venue.state {
                            Text("\(city), \(state)")
                            
                        } else if let city = event.venue.city {
                            Text(city)
                            
                        } else if let state = event.venue.state {
                            Text(state)
                            
                        }
                        if let date = event.dateTimeLocal {
                            Text(DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .medium))
                        }
                    }
                    .font(.caption)
                    .foregroundColor(.gray)
                }
                .offset(y: UIFont.preferredFont(forTextStyle: .body, compatibleWith: nil).descender)
                .offset(y: 1) // needs just a tiny nudge to make it appear more aligned than it is, because of the corner radius of the image.
            }
            .padding(8)
            if isFavorite {
                VStack {
                    HStack {
                        ZStack {
                            Image(systemName: "heart.fill")
                                .font(Font.system(size: 24))
                                .foregroundColor(.white)
                            Image(systemName: "heart.fill")
                                .font(Font.system(size: 20))
                                .foregroundColor(.red)
                        }
                        Spacer()
                    }
                    Spacer()
                }
                .offset(x: -4)
            }
        }
    }
}
