//
//  TaskListViewModel.swift
//  TaskMate
//
//  Created by Shivanand Koli on 06/02/26.
//

import Foundation

final class TaskListViewModel {

    // MARK: - Properties

    private var storageService: TaskStorageServiceProtocol
    private var currentSortOption: TaskSortOption = .creationDate
    private var currentFilterOption: TaskFilterOption = .all

    private var allTasks: [Task] = []

    private(set) var tasks: [Task] = [] {
        didSet {
            onTasksUpdated?()
        }
    }

    var onTasksUpdated: (() -> Void)?

    // MARK: - Init

    init(storageService: TaskStorageServiceProtocol = CoreDataTaskStorageService()) {
        self.storageService = storageService
    }

    func numberOfTasks() -> Int {
        return tasks.count
    }

    func task(at index: Int) -> Task {
        return tasks[index]
    }

    func loadTasks() {
        allTasks = storageService.fetchTasks(sortedBy: currentSortOption)
        applyFilter()
    }

    func updateFilterOption(_ option: TaskFilterOption) {
        currentFilterOption = option
        applyFilter()
    }

    func updateSortOption(_ option: TaskSortOption) {
        currentSortOption = option
        loadTasks()
    }

    func addTask(_ task: Task) {
        storageService.saveTask(task)
        loadTasks()
    }

    func deleteTask(at index: Int) {
        let task = tasks[index]
        storageService.deleteTask(task)
        loadTasks()
    }

    func toggleTaskCompletion(at index: Int) {
        var task = tasks[index]
        task.isCompleted.toggle()
        storageService.updateTask(task)
        loadTasks()
    }

    // MARK: - Private

    private func applyFilter() {
        switch currentFilterOption {
        case .all:
            tasks = allTasks
        case .pending:
            tasks = allTasks.filter { !$0.isCompleted }
        case .completed:
            tasks = allTasks.filter { $0.isCompleted }
        }
    }
}
