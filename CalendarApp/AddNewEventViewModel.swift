//
//  AddNewEventViewModel.swift
//  CalendarApp
//
//  Created by Sanzhar Burumbay on 17.07.2023.
//

import Foundation
import RealmSwift

protocol AddNewEventViewModeling: AnyObject {
    func addNewEvent(title: String?, date: Date?)
}

final class AddNewEventViewModel: AddNewEventViewModeling {
    func addNewEvent(title: String?, date: Date?) {
        guard let title, let date else {
            return
        }
        
        let event = EventItem()
        event.title = title
        event.date = date
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(event)
        }
    }
}
