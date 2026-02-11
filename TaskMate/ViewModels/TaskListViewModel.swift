//
//  TaskListViewModel.swift
//  TaskMate
//
//  Created by Shivanand Koli on 06/02/26.
//

import Foundation

final class TaskListViewModel {
//    private var storageService = TaskStorageService()
    private var currentSortOption: TaskSortOption = .creationDate
    private var storageService: TaskStorageServiceProtocol
    private var tasks: [Task] = []
    
    var onTasksUpdated: (() -> Void)?
    
    init(storageService: TaskStorageServiceProtocol = CoreDataTaskStorageService()) {
        self.storageService = storageService
        loadTasks()
    }
    
    func numberOfTask() -> Int {
        tasks.count
    }
    
    func task(at index: Int) -> Task {
        tasks[index]
    }
    
    func loadTasks() {
        tasks = storageService.fetchTasks(sortedBy: currentSortOption)
        onTasksUpdated?()
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
}
