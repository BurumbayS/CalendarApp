//
//  CalendarViewController.swift
//  CalendarApp
//
//  Created by Sanzhar Burumbay on 17.07.2023.
//

import UIKit
import SnapKit

protocol CalendarViewProtocol: AnyObject {
    func updateEventsList(with events: [EventItem])
    func updateDatesWithEvents(with dates: [DateComponents])
}

final class CalendarViewController: UIViewController {
    
    private var viewModel: CalendarViewModeling?
    private var events: [EventItem] = []
    private var datesWithEvents: [DateComponents] = []
    
    private let calendarView = UICalendarView()
    private var dateSelection: UICalendarSelectionSingleDate!
    private var tableView: UITableView!
    
    init(viewModel: CalendarViewModeling?) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupViews()
        setupInitialState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let dateComponents = dateSelection.selectedDate {
            viewModel?.loadEvents(for: dateComponents)
            viewModel?.loadDatesWithEvents(for: calendarView.visibleDateComponents)
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Event Calendar"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addNewEvent))
    }
    
    private func setupViews() {
        view.backgroundColor = #colorLiteral(red: 0.9638205171, green: 0.9687921405, blue: 0.9730095267, alpha: 1)
        
        calendarView.calendar = Calendar(identifier: .gregorian)
        calendarView.delegate = self
        calendarView.tintColor = #colorLiteral(red: 0.5260997415, green: 0.7271208167, blue: 0.9652654529, alpha: 1)
        calendarView.backgroundColor = .white
        dateSelection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = dateSelection
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
    
    private func setupInitialState() {
        let todayDateComponents = Calendar.current.dateComponents([.day, .month, .year], from: Date())
        dateSelection.setSelected(todayDateComponents, animated: true)
        viewModel?.loadEvents(for: todayDateComponents)
        viewModel?.loadDatesWithEvents(for: calendarView.visibleDateComponents)
    }
    
    private func setSelectedFirstDayOfMonth() {
        let todayDateComponents = Calendar.current.dateComponents([.day, .month, .year], from: Date())
        var dateComponents = calendarView.visibleDateComponents
        dateComponents.day = (dateComponents.month == todayDateComponents.month && dateComponents.year == todayDateComponents.year) ? todayDateComponents.day : 1
        dateSelection.setSelected(dateComponents, animated: true)
        viewModel?.loadEvents(for: dateComponents)
        viewModel?.loadDatesWithEvents(for: calendarView.visibleDateComponents)
    }
    
    @objc private func addNewEvent() {
        let vc = AddNewEventViewController(viewModel: AddNewEventViewModel())
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension CalendarViewController: CalendarViewProtocol {
    func updateEventsList(with events: [EventItem]) {
        self.events = events
        self.tableView.reloadData()
    }
    
    func updateDatesWithEvents(with dates: [DateComponents]) {
        self.datesWithEvents = dates
        self.calendarView.reloadDecorations(forDateComponents: datesWithEvents, animated: true)
    }
}

extension CalendarViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: EventItemCell.self), for: indexPath) as? EventItemCell else {
            return UITableViewCell()
        }
        
        cell.configure(from: events[indexPath.row])
        return cell
    }
}

extension CalendarViewController: UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
    
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        let color = #colorLiteral(red: 1, green: 0.4512969851, blue: 0.6186520457, alpha: 1)
        return (datesWithEvents.contains(where: { $0.day == dateComponents.day })) ? .default(color: color, size: .medium) : nil
    }
    
    func calendarView(_ calendarView: UICalendarView, didChangeVisibleDateComponentsFrom previousDateComponents: DateComponents) {
        setSelectedFirstDayOfMonth()
    }
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let dateComponents else {
            return
        }
        viewModel?.loadEvents(for: dateComponents)
    }
}
