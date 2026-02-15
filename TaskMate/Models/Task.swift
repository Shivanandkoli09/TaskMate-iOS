//
//  Task.swift
//  TaskMate
//
//  Created by Shivanand Koli on 06/02/26.
//

import Foundation


enum TaskPriority: String, Codable, CaseIterable {
    case low
    case medium
    case high
}

struct Task: Codable, Identifiable {
    var id: UUID
    var title: String
    var notes: String?
    var dueDate: Date?
    var priority: TaskPriority
    var isCompleted: Bool
    
    init(id: UUID, title: String, notes: String? = nil, dueDate: Date, priority: TaskPriority, isCompleted: Bool) {
        self.id = id
        self.title = title
        self.notes = notes
        self.dueDate = dueDate
        self.priority = priority
        self.isCompleted = isCompleted
    }
}
