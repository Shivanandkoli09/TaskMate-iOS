//
//  Task+CoreDataMapping.swift
//  TaskMate
//
//  Created by Shivanand Koli on 08/02/26.
//

import CoreData

extension Task {

    init(entity: TaskEntity) {
        self.id = entity.id ?? UUID()
        self.title = entity.title ?? "Untitle Task"
        self.notes = entity.notes
        self.dueDate = entity.dueDate ?? Date()
        self.priority = TaskPriority(rawValue: entity.priority!) ?? .low
        self.isCompleted = entity.isCompleted
    }
}

extension TaskEntity {

    func update(from task: Task) {
        self.id = task.id
        self.title = task.title
        self.notes = task.notes
        self.dueDate = task.dueDate
        self.priority = task.priority.rawValue
        self.isCompleted = task.isCompleted
    }
}
