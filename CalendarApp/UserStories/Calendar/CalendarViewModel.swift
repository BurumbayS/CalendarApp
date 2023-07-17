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
    func loadDatesWithEvents(for dateComponents: DateComponents)
}

final class CalendarViewModel: CalendarViewModeling {
    
    weak var view: CalendarViewProtocol?
    
    func loadEvents(for dateComponents: DateComponents) {
        guard let date = Calendar.current.date(from: dateComponents) else {
            return
        }
        
        let realm = try! Realm()
        let objects = Array(realm.objects(EventItemDTO.self).filter { event in
            let eventDateComponents = Calendar.current.dateComponents([.day, .month, .year], from: event.date)
            let dateComponents = Calendar.current.dateComponents([.day, .month, .year], from: date)
            
            return dateComponents == eventDateComponents
        })
        let events = objects.map({ EventItem(title: $0.title, date: $0.date) })
        view?.updateEventsList(with: events)
    }
    
    func loadDatesWithEvents(for dateComponents: DateComponents) {
        guard let date = Calendar.current.date(from: dateComponents) else {
            return
        }
        
        let realm = try! Realm()
        let objects = Array(realm.objects(EventItemDTO.self).filter { event in
            let eventDateComponents = Calendar.current.dateComponents([.month, .year], from: event.date)
            let dateComponents = Calendar.current.dateComponents([.month, .year], from: date)
            
            return dateComponents == eventDateComponents
        })
        var dates: Set<DateComponents> = []
        objects.forEach { object in
            let dateComponents = Calendar.current.dateComponents([.day, .month, .year], from: object.date)
            dates.insert(dateComponents)
        }
        view?.updateDatesWithEvents(with: Array(dates))
    }
}
