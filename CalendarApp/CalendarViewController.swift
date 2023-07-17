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
        setupNavigationBar()
        setupViews()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Event Calendar"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addNewEvent))
    }
    
    private func setupViews() {
        view.backgroundColor = #colorLiteral(red: 0.9638205171, green: 0.9687921405, blue: 0.9730095267, alpha: 1)
        
        let calendarView = UICalendarView()
        calendarView.calendar = Calendar(identifier: .gregorian)
        calendarView.delegate = self
        calendarView.tintColor = #colorLiteral(red: 0.5260997415, green: 0.7271208167, blue: 0.9652654529, alpha: 1)
        calendarView.backgroundColor = .white
        calendarView.selectionBehavior = UICalendarSelectionSingleDate(delegate: self)
        view.addSubview(calendarView)
        calendarView.snp.makeConstraints { view in
            view.leading.trailing.top.equalToSuperview()
        }
        
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.register(EventItemCell.self, forCellReuseIdentifier: String(describing: EventItemCell.self))
        view.addSubview(tableView)
        tableView.snp.makeConstraints { view in
            view.leading.trailing.bottom.equalToSuperview()
            view.top.equalTo(calendarView.snp.bottom).offset(20)
        }
    }
    
    @objc private func addNewEvent() {
        let vc = AddNewEventViewController()
        navigationController?.pushViewController(vc, animated: true)
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
        let color = #colorLiteral(red: 1, green: 0.4512969851, blue: 0.6186520457, alpha: 1)
        return .default(color: color, size: .medium)
    }
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        
    }
}
