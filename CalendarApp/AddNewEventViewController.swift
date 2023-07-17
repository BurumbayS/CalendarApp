//
//  AddNewEventViewController.swift
//  CalendarApp
//
//  Created by Sanzhar Burumbay on 17.07.2023.
//

import UIKit

final class AddNewEventViewController: UIViewController {
    
    private let viewModel: AddNewEventViewModeling
    
    private var eventDateTextField: UITextField!
    private var eventTimeTextField: UITextField!
    private var titleTextField: UITextField!
    
    private let datePicker = UIDatePicker()
    private let timePicker = UIDatePicker()
    
    init(viewModel: AddNewEventViewModeling) {
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
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "New Event"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addNewEvent))
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        let vStack = UIStackView()
        vStack.alignment = .fill
        vStack.distribution = .equalSpacing
        vStack.spacing = 10
        vStack.axis = .vertical
        
        titleTextField = defaultTextField(placeholder: "Event name")
        vStack.addArrangedSubview(titleTextField)
        titleTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        
        eventDateTextField = defaultTextField(placeholder: "Event date")
        eventDateTextField.inputView = datePicker
        eventDateTextField.inputAccessoryView = datePickerToolBar(action: #selector(datePicked))
        
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.datePickerMode = .time
        
        eventTimeTextField = defaultTextField(placeholder: "Event time")
        eventTimeTextField.inputView = timePicker
        eventTimeTextField.inputAccessoryView = datePickerToolBar(action: #selector(timePicked))
        
        let hStack = UIStackView(arrangedSubviews: [eventDateTextField, eventTimeTextField])
        hStack.alignment = .fill
        hStack.distribution = .fillEqually
        hStack.spacing = 10
        hStack.axis = .horizontal
        vStack.addArrangedSubview(hStack)
        hStack.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        view.addSubview(vStack)
        vStack.snp.makeConstraints { view in
            view.leading.trailing.equalToSuperview().inset(16)
            view.top.equalTo(self.view.safeAreaLayoutGuide).inset(16)
        }
    }
    
    @objc private func datePicked() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        eventDateTextField.text = dateFormatter.string(from: datePicker.date)
        
        view.endEditing(true)
    }
    
    @objc private func timePicked() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        eventTimeTextField.text = dateFormatter.string(from: timePicker.date)
        
        view.endEditing(true)
    }
    
    @objc private func addNewEvent() {
        let dateString = "\(eventDateTextField.text) \(eventTimeTextField.text)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy hh:mm a"
        
        viewModel.addNewEvent(title: titleTextField.text, date: dateFormatter.date(from: dateString))
    }
}

private extension AddNewEventViewController {
    func defaultTextField(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.placeholder = placeholder
        textField.layer.cornerRadius = 15
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.backgroundColor = #colorLiteral(red: 0.9638205171, green: 0.9687921405, blue: 0.9730095267, alpha: 1)
        
        return textField
    }
    
    func datePickerToolBar(action: Selector?) -> UIToolbar {
        let doneButton = UIBarButtonItem.init(title: "Done", style: .done, target: self, action: action)
        let toolBar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 44))
        toolBar.setItems([UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil), doneButton], animated: true)
        return toolBar
    }
}
