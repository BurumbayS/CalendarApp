//
//  CalendarViewModel.swift
//  CalendarApp
//
//  Created by Sanzhar Burumbay on 18.07.2023.
//

import UIKit
import RealmSwift

protocol CalendarViewModeling: AnyObject {
    func loadEvents(for dateComponents: DateComponents)
}

final class CalendarViewModel: CalendarViewModeling {
    
    private weak var view: CalendarViewProtocol?
    
    init(view: CalendarViewProtocol) {
        self.view = view
    }
    
    func loadEvents(for dateComponents: DateComponents) {
        guard let date = Calendar.current.date(from: dateComponents) else {
            return
        }
        
        let realm = try! Realm()
        let objects = Array(realm.objects(EventItemDTO.self).filter { event in
            print(event.title)
            let eventDateComponents = Calendar.current.dateComponents([.day, .month, .year], from: event.date)
            let dateComponents = Calendar.current.dateComponents([.day, .month, .year], from: date)
            
            return dateComponents == eventDateComponents
        })
        let events = objects.map({ EventItem(title: $0.title, date: $0.date) })
        view?.updateEventsList(with: events)
    }
}
