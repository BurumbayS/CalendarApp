//
//  EventItem.swift
//  CalendarApp
//
//  Created by Sanzhar Burumbay on 18.07.2023.
//

import Foundation

struct EventItem {
    let title: String
    let time: String
    
    init(title: String, date: Date) {
        self.title = title
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        self.time = dateFormatter.string(from: date)
    }
}
