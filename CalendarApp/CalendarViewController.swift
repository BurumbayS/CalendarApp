//
//  CalendarViewController.swift
//  CalendarApp
//
//  Created by Sanzhar Burumbay on 17.07.2023.
//

import UIKit
import SnapKit

final class CalendarViewController: UIViewController {
    
    private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        let calendarView = UICalendarView()
        calendarView.calendar = Calendar(identifier: .gregorian)
        calendarView.delegate = self
        calendarView.selectionBehavior = UICalendarSelectionSingleDate(delegate: self)
        view.addSubview(calendarView)
        calendarView.snp.makeConstraints { view in
            view.leading.trailing.top.equalToSuperview()
        }
        
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.register(EventItemCell.self, forCellReuseIdentifier: String(describing: EventItemCell.self))
        view.addSubview(tableView)
        tableView.snp.makeConstraints { view in
            view.leading.trailing.bottom.equalToSuperview()
            view.top.equalTo(calendarView.snp.bottom).offset(10)
        }
    }
}

extension CalendarViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: EventItemCell.self), for: indexPath) as? EventItemCell else {
            return UITableViewCell()
        }
        
        cell.configure(title: "Hello", time: "15:23")
        return cell
    }
}

extension CalendarViewController: UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
    
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        return .default(color: .blue, size: .medium)
    }
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        
    }
}
