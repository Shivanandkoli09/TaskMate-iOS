//
//  CoreDataStack.swift
//  TaskMate
//
//  Created by Shivanand Koli on 08/02/26.
//

import CoreData

final class CoreDataStack {

    static let shared = CoreDataStack()

    private init() {}

    // MARK: - Persistent Container
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskMateDataModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved Core Data error: \(error)")
            }
        }
        return container
    }()

    // MARK: - Main Context (UI)
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    // MARK: - Background Context
    func newBackgroundContext() -> NSManagedObjectContext {
        persistentContainer.newBackgroundContext()
    }

    // MARK: - Save
    func saveContext() {
        let context = viewContext
        guard context.hasChanges else { return }

        do {
            try context.save()
        } catch {
            print("Core Data save error:", error)
        }
    }
}
