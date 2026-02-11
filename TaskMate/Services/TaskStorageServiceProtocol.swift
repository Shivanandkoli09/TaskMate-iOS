//
//  TaskStorageServiceProtocol.swift
//  TaskMate
//
//  Created by Shivanand Koli on 09/02/26.
//

protocol TaskStorageServiceProtocol {
    func fetchTasks() -> [Task]
    func saveTask(_ task: Task)
    func updateTask(_ task: Task)
    func deleteTask(_ task: Task)
}
