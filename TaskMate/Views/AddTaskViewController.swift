//
//  AddTaskViewController.swift
//  TaskMate
//
//  Created by Shivanand Koli on 06/02/26.
//

import UIKit

final class AddTaskViewController: UIViewController {
    
    private let titleTextField = UITextField()
    private let notesTextView = UITextView()
    private let dueDatePicker = UIDatePicker()
    private let priorityControl = UISegmentedControl(items: TaskPriority.allCases.map { $0.rawValue.capitalized})
    
    var onTaskCreated: ((Task) -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        
    }
    
    func setupUI() {
        title = "Add Task"
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Save",
            style: .done,
            target: self,
            action: #selector(saveTapped)
        )
        
        titleTextField.placeholder = "Task title"
        titleTextField.borderStyle = .roundedRect
        titleTextField.autocapitalizationType = .sentences
        
        notesTextView.font = .systemFont(ofSize: 14)
        notesTextView.layer.borderWidth = 1
        notesTextView.layer.borderColor = UIColor.separator.cgColor
        notesTextView.layer.cornerRadius = 8
        
        dueDatePicker.datePickerMode = .dateAndTime
        dueDatePicker.preferredDatePickerStyle = .compact
        
        priorityControl.selectedSegmentIndex = 1 // Medium
    }
    
    func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: [
            titleTextField,
            notesTextView,
            dueDatePicker,
            priorityControl
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            notesTextView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    @objc func saveTapped() {
        guard let title = titleTextField.text,
              !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlert(message: "Task title cannot be empty.")
            return
        }
        
        let priority = TaskPriority.allCases[priorityControl.selectedSegmentIndex]
        
        let task = Task(
            id: UUID(),
            title: title,
            notes: notesTextView.text,
            dueDate: dueDatePicker.date,
            priority: priority,
            isCompleted: false
        )
        
        onTaskCreated?(task)
        dismiss(animated: true)
    }

        func showAlert(message: String) {
            let alert = UIAlertController(
                title: "Invalid Input",
                message: message,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
}

