//
//  TaskListViewController.swift
//  TaskMate
//
//  Created by Shivanand Koli on 06/02/26.
//

import UIKit

final class TaskListViewController: UIViewController {
    
    private let viewModel = TaskListViewModel()
    private var tableView = UITableView()
    private var emptyStateLabel = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setUpTableView()
        setUpEmptyStateLabel()
        
        viewModel.onTasksUpdated = { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
            self.updateEmptyState()
        }
    }
    
    private func updateEmptyState() {
        emptyStateLabel.isHidden = viewModel.numberOfTask() > 0
    }
    
    func setupUI() {
        title = "TaskMate"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTaskTapped))
        
        view.addSubview(tableView)
        view.addSubview(emptyStateLabel)
        
    }
    
    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TaskCell.self, forCellReuseIdentifier: TaskCell.identifier)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView()
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func setUpEmptyStateLabel() {
        emptyStateLabel.text = "No tasks added yet. Tap the plus button to add a task."
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.numberOfLines = 0
        emptyStateLabel.textColor = .secondaryLabel
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        emptyStateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
        emptyStateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
    
    func loadData() {
        viewModel.loadTasks()
        updateUI()
    }
    
    func updateUI() {
        emptyStateLabel.isHidden = viewModel.numberOfTask() > 0
        tableView.reloadData()
    }
    
    @objc func addTaskTapped() {
        let addVC = AddTaskViewController()
        addVC.onTaskCreated = { [weak self] task in
            self?.viewModel.addTask(task)
            self?.updateUI()
        }
        
        let navController = UINavigationController(rootViewController: addVC)
        present(navController, animated: true)
    }
    
}


extension TaskListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfTask()
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.identifier,for: indexPath) as? TaskCell else {
            return UITableViewCell()
        }

        let task = viewModel.task(at: indexPath.row)
        cell.configure(with: task)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        viewModel.toggleTaskCompletion(at: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView,commit editingStyle: UITableViewCell.EditingStyle,forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteTask(at: indexPath.row)
        }
    }
}
