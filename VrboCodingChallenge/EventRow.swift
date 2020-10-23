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
    var event: SeatGeekEvent
    private let options: KingfisherOptionsInfo = [.processor(ResizingImageProcessor(referenceSize: .init(width: 60, height: 60), mode: .aspectFill))]
    
    var body: some SwiftUI.View {
        VStack(alignment: .leading) {
            HStack(alignment: .top, spacing: 24) {
                KFImage(event.performers.first?.image, options: options)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .clipped()
                    .cornerRadius(8)
                VStack(alignment: .leading, spacing: 4) {
                    Text(event.title ?? "")
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
                .alignmentGuide(.top) { d in
                    d[.top] + 4
                }
            }
            .padding(8)
        }
    }
}
