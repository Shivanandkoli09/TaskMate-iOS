//
//  TaskListViewModel.swift
//  TaskMate
//
//  Created by Shivanand Koli on 06/02/26.
//

import Foundation

final class TaskListViewModel {
    private var storageService = TaskStorageService()
    private var tasks: [Task] = []
    
    var onTasksUpdated: (() -> Void)?
    
    init() {
        loadTasks()
    }
    
    func loadTasks() {
        tasks = storageService.fetchTasks()
        onTasksUpdated?()
    }
    
    func numberOfTask() -> Int {
        tasks.count
    }
    
    func task(at index: Int) -> Task {
        tasks[index]
    }
    
    func addTask(_ task: Task) {
        tasks.append(task)
        storageService.saveTasks(tasks)
        onTasksUpdated?()
    }
    
    func toggleTaskCompletion(at index: Int) {
        guard tasks.indices.contains(index) else { return }
        tasks[index].isCompleted.toggle()
        storageService.saveTasks(tasks)
        onTasksUpdated?()
    }
    
    func deleteTask(at index: Int) {
        guard tasks.indices.contains(index) else { return }
        tasks.remove(at: index)
        storageService.saveTasks(tasks)
        onTasksUpdated?()
    }
}
