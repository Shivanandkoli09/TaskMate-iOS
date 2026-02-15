//
//  NotificationManager.swift
//  TaskMate
//
//  Created by Shivanand Koli on 15/02/26.
//

import UserNotifications

final class NotificationManager {

    static let shared = NotificationManager()

    private init() {}

    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge]
        ) { granted, error in
            if let error = error {
                print("Permission error:", error)
            } else {
                print("Permission granted:", granted)
            }
        }
    }
    
    func scheduleNotification(for task: Task) {

        guard let dueDate = task.dueDate, dueDate > Date() else { return }

        let content = UNMutableNotificationContent()
        content.title = "Task Reminder"
        content.body = task.title
        content.sound = .default

        let components = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: dueDate
        )

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: components,
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: task.id.uuidString,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }
    
    func cancelNotification(for task: Task) {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(
                withIdentifiers: [task.id.uuidString]
            )
    }
}
