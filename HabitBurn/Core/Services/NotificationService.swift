import Foundation
import UserNotifications

class NotificationService: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationService()
    
    private override init() { }
    
    
    func requestAuthorization(completion: ((Bool) -> Void)? = nil) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            DispatchQueue.main.async {
                completion?(granted)
            }
        }
        center.delegate = self
    }
    
    func configureNotifications(enabled: Bool) {
        if enabled {
            requestAuthorization { _ in }
        } else {
            cancelAll()
        }
    }
    
    
    func scheduleDailyReminder(for habit: Habit) {
        guard let reminderTime = habit.reminderTime else { return }
        let content = UNMutableNotificationContent()
        content.title = "Reminder: \(habit.title)"
        content.body = "Don't forget to complete your habit today."
        content.sound = .default
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: reminderTime)
        var dateComponents = DateComponents()
        dateComponents.hour = components.hour
        dateComponents.minute = components.minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: habit.id.uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func cancelReminder(for habitId: UUID) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [habitId.uuidString])
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [habitId.uuidString])
    }
    
    func rescheduleAllHabits(habits: [Habit], enabled: Bool) {
        if !enabled {
            cancelAll()
            return
        }
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        for habit in habits where habit.reminderTime != nil {
            scheduleDailyReminder(for: habit)
        }
    }
    
    func cancelAll() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}


