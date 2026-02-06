//
//  TaskStorageService.swift
//  TaskMate
//
//  Created by Shivanand Koli on 06/02/26.
//

import Foundation

final class TaskStorageService {
    private let taskKey = "saved_task"
    
    func saveTasks(_ tasks: [Task]) {
        do {
            let data = try JSONEncoder().encode(tasks)
            UserDefaults.standard.set(data, forKey: taskKey)
        } catch {
            print("Failed to save tasks: \(error)")
        }
    }
    
    func fetchTasks() -> [Task]? {
        do {
            if let data = UserDefaults.standard.data(forKey: taskKey) {
                return try JSONDecoder().decode([Task].self, from: data)
            }
        } catch {
            print("Failed to fetch tasks: \(error)")
        }
        return nil
    }
    
    func clearTasks() {
        UserDefaults.standard.removeObject(forKey: taskKey)
    }
}
