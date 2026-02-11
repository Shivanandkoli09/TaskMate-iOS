//
//  CoreDataTaskStorageService.swift
//  TaskMate
//
//  Created by Shivanand Koli on 09/02/26.
//

import CoreData

final class CoreDataTaskStorageService: TaskStorageServiceProtocol {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = CoreDataStack.shared.viewContext) {
        self.context = context
    }

    // MARK: - Fetch
    func fetchTasks() -> [Task] {
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "createdAt", ascending: false)
        ]

        do {
            let entities = try context.fetch(request)
            return entities.map { Task(entity: $0) }
        } catch {
            print("Fetch error:", error)
            return []
        }
    }

    // MARK: - Save
    func saveTask(_ task: Task) {
        let entity = TaskEntity(context: context)
        entity.update(from: task)
        saveContext()
    }

    // MARK: - Update
    func updateTask(_ task: Task) {
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", task.id as CVarArg)

        do {
            if let entity = try context.fetch(request).first {
                entity.update(from: task)
                saveContext()
            }
        } catch {
            print("Update error:", error)
        }
    }

    // MARK: - Delete
    func deleteTask(_ task: Task) {
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", task.id as CVarArg)

        do {
            if let entity = try context.fetch(request).first {
                context.delete(entity)
                saveContext()
            }
        } catch {
            print("Delete error:", error)
        }
    }

    // MARK: - Save Context
    private func saveContext() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            print("Core Data save error:", error)
        }
    }
}
