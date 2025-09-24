import Foundation

struct User: Codable {
    var name: String
    var createdAt: Date
    var notificationsEnabled: Bool
    var onboardingCompleted: Bool
    
    init(name: String = "") {
        self.name = name
        self.createdAt = Date()
        self.notificationsEnabled = true
        self.onboardingCompleted = false
    }
}


struct AppSettings: Codable {
    var notificationsEnabled: Bool
    var reminderTime: Date?
    var theme: String 
    
    init() {
        self.notificationsEnabled = true
        self.reminderTime = nil
        self.theme = "fire"
    }
}