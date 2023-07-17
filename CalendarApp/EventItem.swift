//
//  EventItem.swift
//  CalendarApp
//
//  Created by Sanzhar Burumbay on 17.07.2023.
//

import Foundation
import RealmSwift

final class EventItem: Object {
    @Persisted var title: String
    @Persisted var date: Date
}
