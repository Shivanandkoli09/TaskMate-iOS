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
    
    func loadTasks() {
        tasks = storageService.fetchTasks()
    }
    
    func numberOfTask() -> Int {
        tasks.count
    }
    
    func task(at index: Int) -> Task {
        tasks[index]
    }
}
