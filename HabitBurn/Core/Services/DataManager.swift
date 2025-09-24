import Foundation

class DataManager: ObservableObject {
    static let shared = DataManager()
    
    private let userDefaults = UserDefaults.standard
    
    
    private enum Keys {
        static let habits = "habits"
        static let user = "user"
        static let settings = "settings"
        static let onboardingCompleted = "onboardingCompleted"
    }
    
    
    @Published var habits: [Habit] = []
    @Published var user: User = User()
    @Published var settings: AppSettings = AppSettings()
    @Published var onboardingCompleted: Bool = false
    
    private init() {
        loadData()
        NotificationService.shared.configureNotifications(enabled: settings.notificationsEnabled)
        NotificationService.shared.rescheduleAllHabits(habits: habits, enabled: settings.notificationsEnabled)
    }
    
    
    private func loadData() {
        loadHabits()
        loadUser()
        loadSettings()
        loadOnboardingStatus()
    }
    
    private func loadHabits() {
        if let data = userDefaults.data(forKey: Keys.habits),
           let decodedHabits = try? JSONDecoder().decode([Habit].self, from: data) {
            self.habits = decodedHabits
        } else {
            self.habits = []
        }
    }
    
    private func loadUser() {
        if let data = userDefaults.data(forKey: Keys.user),
           let decodedUser = try? JSONDecoder().decode(User.self, from: data) {
            self.user = decodedUser
        } else {
            self.user = User()
        }
    }
    
    private func loadSettings() {
        if let data = userDefaults.data(forKey: Keys.settings),
           let decodedSettings = try? JSONDecoder().decode(AppSettings.self, from: data) {
            self.settings = decodedSettings
        } else {
            self.settings = AppSettings()
        }
    }
    
    private func loadOnboardingStatus() {
        self.onboardingCompleted = userDefaults.bool(forKey: Keys.onboardingCompleted)
    }
    
    
    func saveHabits() {
        if let encoded = try? JSONEncoder().encode(habits) {
            userDefaults.set(encoded, forKey: Keys.habits)
        }
        NotificationService.shared.rescheduleAllHabits(habits: habits, enabled: settings.notificationsEnabled)
    }
    
    func saveUser() {
        if let encoded = try? JSONEncoder().encode(user) {
            userDefaults.set(encoded, forKey: Keys.user)
        }
    }
    
    func saveSettings() {
        if let encoded = try? JSONEncoder().encode(settings) {
            userDefaults.set(encoded, forKey: Keys.settings)
        }
        NotificationService.shared.configureNotifications(enabled: settings.notificationsEnabled)
        NotificationService.shared.rescheduleAllHabits(habits: habits, enabled: settings.notificationsEnabled)
    }
    
    func saveOnboardingStatus() {
        userDefaults.set(onboardingCompleted, forKey: Keys.onboardingCompleted)
    }
    
    
    func addHabit(_ habit: Habit) {
        guard habits.count < 7 else { return } 
        habits.append(habit)
        saveHabits()
        NotificationService.shared.scheduleDailyReminder(for: habit)
    }
    
    func updateHabit(_ habit: Habit) {
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            habits[index] = habit
            saveHabits()
            NotificationService.shared.cancelReminder(for: habit.id)
            NotificationService.shared.scheduleDailyReminder(for: habit)
        }
    }
    
    func deleteHabit(_ habit: Habit) {
        habits.removeAll { $0.id == habit.id }
        saveHabits()
        NotificationService.shared.cancelReminder(for: habit.id)
    }
    
    func toggleHabitCompletion(_ habitId: UUID) {
        if let index = habits.firstIndex(where: { $0.id == habitId }) {
            habits[index].toggleCompletion()
            saveHabits()
        }
    }
    
    
    func updateUserName(_ name: String) {
        user.name = name
        saveUser()
    }
    
    func completeOnboarding() {
        user.onboardingCompleted = true
        onboardingCompleted = true
        saveUser()
        saveOnboardingStatus()
    }
    
    
    func updateNotificationSettings(_ enabled: Bool) {
        settings.notificationsEnabled = enabled
        saveSettings()
    }
    
    
    func getOverallStats() -> (totalHabits: Int, completedToday: Int, weeklyAverage: Double) {
        let totalHabits = habits.count
        let completedToday = habits.filter { $0.isCompletedToday }.count
        let weeklyAverage = habits.isEmpty ? 0.0 : habits.map { $0.weeklyCompletionPercentage }.reduce(0, +) / Double(habits.count)
        
        return (totalHabits, completedToday, weeklyAverage)
    }
    
    
    func resetAllData() {
        habits = []
        user = User()
        settings = AppSettings()
        onboardingCompleted = false
        
        saveHabits()
        saveUser()
        saveSettings()
        saveOnboardingStatus()
        NotificationService.shared.cancelAll()
    }
    
    func resetStats() {
        for i in habits.indices {
            habits[i].completions = []
        }
        saveHabits()
    }
}