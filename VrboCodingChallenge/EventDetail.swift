//
//  EventDetail.swift
//  VrboCodingChallenge
//
//  Created by Matthew Waller on 10/22/20.
//

import SwiftUI
import KingfisherSwiftUI

struct EventDetail: View {
    var event: SeatGeekEvent
    
    var body: some View {
        VStack(alignment: .leading) {
            KFImage(event.performers.first?.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
                .cornerRadius(8)
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
        .navigationBarTitle(Text(event.title ?? "Event Detail"), displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            
        }, label: {
            Image(systemName: "heart.fill")
                .font(.title)
                .foregroundColor(.red)
        }))
    }
}
