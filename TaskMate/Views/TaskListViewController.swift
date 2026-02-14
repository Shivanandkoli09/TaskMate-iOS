//
//  TaskListViewController.swift
//  TaskMate
//
//  Created by Shivanand Koli on 06/02/26.
//

import UIKit

final class TaskListViewController: UIViewController {

    // MARK: - Properties

    private let viewModel = TaskListViewModel()
    private let tableView = UITableView()
    private let emptyStateLabel = UILabel()

    private let filterSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["All", "Pending", "Completed"])
        control.selectedSegmentIndex = 0
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setUpTableView()
        setUpEmptyStateLabel()
        setupBindings()

        viewModel.loadTasks()
    }

    // MARK: - Setup

    private func setupBindings() {
        filterSegmentedControl.addTarget(self,action: #selector(filterChanged),for: .valueChanged)

        viewModel.onTasksUpdated = { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
            self.updateEmptyState()
        }
    }

    func setupUI() {
        title = "TaskMate"
        view.backgroundColor = .systemBackground

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addTaskTapped)
        )

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Sort",
            style: .plain,
            target: self,
            action: #selector(sortTapped)
        )

        view.addSubview(filterSegmentedControl)
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
            filterSegmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            filterSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            filterSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            tableView.topAnchor.constraint(equalTo: filterSegmentedControl.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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

    // MARK: - Actions

    @objc private func filterChanged() {
        switch filterSegmentedControl.selectedSegmentIndex {
        case 0:
            viewModel.updateFilterOption(.all)
        case 1:
            viewModel.updateFilterOption(.pending)
        case 2:
            viewModel.updateFilterOption(.completed)
        default:
            break
        }
    }

    @objc private func sortTapped() {
        let alert = UIAlertController(title: "Sort By", message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Creation Date", style: .default) { [weak self] _ in
            self?.viewModel.updateSortOption(.creationDate)
        })

        alert.addAction(UIAlertAction(title: "Due Date", style: .default) { [weak self] _ in
            self?.viewModel.updateSortOption(.dueDate)
        })

        alert.addAction(UIAlertAction(title: "Priority", style: .default) { [weak self] _ in
            self?.viewModel.updateSortOption(.priority)
        })

        alert.addAction(UIAlertAction(title: "Title", style: .default) { [weak self] _ in
            self?.viewModel.updateSortOption(.title)
        })

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(alert, animated: true)
    }

    @objc func addTaskTapped() {
        let addVC = AddTaskViewController()
        addVC.onTaskCreated = { [weak self] task in
            self?.viewModel.addTask(task)
        }
        
        let navController = UINavigationController(rootViewController: addVC)
        present(navController, animated: true)
    }

    private func updateEmptyState() {
        emptyStateLabel.isHidden = viewModel.numberOfTasks() > 0
    }
}


extension TaskListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfTasks()
    }

    func tableView(_ tableView: UITableView,cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TaskCell.identifier,
            for: indexPath
        ) as? TaskCell else {
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
