import SwiftUI

struct Achievement: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let icon: String
    let requirement: AchievementRequirement
    var isUnlocked: Bool
    var unlockedDate: Date?
    let rarity: AchievementRarity
    
    init(title: String, description: String, icon: String, requirement: AchievementRequirement, rarity: AchievementRarity = .common) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.icon = icon
        self.requirement = requirement
        self.isUnlocked = false
        self.unlockedDate = nil
        self.rarity = rarity
    }
    
    mutating func unlock() {
        guard !isUnlocked else { return }
        isUnlocked = true
        unlockedDate = Date()
    }
}

enum AchievementRequirement: Codable {
    case firstHabit
    case streak(days: Int)
    case totalCompletions(count: Int)
    case allHabitsOneDay
    case weekPerfect
    case monthPerfect
    case experiencePoints(points: Int)
    case level(level: Int)
    case habitsCount(count: Int)
    case categoryMaster(category: HabitCategory)
    
    var description: String {
        switch self {
        case .firstHabit:
            return "Create your first habit"
        case .streak(let days):
            return "Maintain a \(days)-day streak"
        case .totalCompletions(let count):
            return "Complete \(count) habits total"
        case .allHabitsOneDay:
            return "Complete all habits in one day"
        case .weekPerfect:
            return "Complete all habits for 7 days straight"
        case .monthPerfect:
            return "Complete all habits for 30 days straight"
        case .experiencePoints(let points):
            return "Earn \(points) experience points"
        case .level(let level):
            return "Reach level \(level)"
        case .habitsCount(let count):
            return "Track \(count) different habits"
        case .categoryMaster(let category):
            return "Master the \(category.rawValue) category"
        }
    }
}

enum AchievementRarity: String, Codable, CaseIterable {
    case common = "Common"
    case rare = "Rare"
    case epic = "Epic"
    case legendary = "Legendary"
    
    var color: Color {
        switch self {
        case .common:
            return Color.gray
        case .rare:
            return Color.blue
        case .epic:
            return Color.purple
        case .legendary:
            return FireColors.accentGold
        }
    }
    
    var gradient: LinearGradient {
        switch self {
        case .common:
            return LinearGradient(colors: [Color.gray, Color.gray.opacity(0.7)], startPoint: .top, endPoint: .bottom)
        case .rare:
            return LinearGradient(colors: [Color.blue, Color.blue.opacity(0.7)], startPoint: .top, endPoint: .bottom)
        case .epic:
            return LinearGradient(colors: [Color.purple, Color.purple.opacity(0.7)], startPoint: .top, endPoint: .bottom)
        case .legendary:
            return FireColors.buttonGradient
        }
    }
}


extension Achievement {
    static var defaultAchievements: [Achievement] {
        return [
            
            Achievement(
                title: "First Step",
                description: "Create your first habit and begin your journey",
                icon: "foot.circle.fill",
                requirement: .firstHabit,
                rarity: .common
            ),
            Achievement(
                title: "Getting Started",
                description: "Complete any habit 5 times",
                icon: "star.fill",
                requirement: .totalCompletions(count: 5),
                rarity: .common
            ),
            Achievement(
                title: "Habit Collector",
                description: "Track 3 different habits",
                icon: "square.grid.3x3.fill",
                requirement: .habitsCount(count: 3),
                rarity: .common
            ),
            
            
            Achievement(
                title: "Week Warrior",
                description: "Maintain a 7-day streak on any habit",
                icon: "calendar.circle.fill",
                requirement: .streak(days: 7),
                rarity: .rare
            ),
            Achievement(
                title: "Month Master",
                description: "Maintain a 30-day streak on any habit",
                icon: "calendar.badge.clock",
                requirement: .streak(days: 30),
                rarity: .epic
            ),
            Achievement(
                title: "Consistency King",
                description: "Maintain a 100-day streak on any habit",
                icon: "crown.fill",
                requirement: .streak(days: 100),
                rarity: .legendary
            ),
            
            
            Achievement(
                title: "Perfect Day",
                description: "Complete all your habits in one day",
                icon: "checkmark.circle.fill",
                requirement: .allHabitsOneDay,
                rarity: .rare
            ),
            Achievement(
                title: "Perfect Week",
                description: "Complete all habits every day for a week",
                icon: "checkmark.seal.fill",
                requirement: .weekPerfect,
                rarity: .epic
            ),
            
            
            Achievement(
                title: "Experience Seeker",
                description: "Earn 1000 experience points",
                icon: "bolt.circle.fill",
                requirement: .experiencePoints(points: 1000),
                rarity: .rare
            ),
            Achievement(
                title: "Level Up Master",
                description: "Reach level 10",
                icon: "arrow.up.circle.fill",
                requirement: .level(level: 10),
                rarity: .epic
            ),
            
            
            Achievement(
                title: "Health Guardian",
                description: "Complete 50 health-related habits",
                icon: "heart.circle.fill",
                requirement: .categoryMaster(category: .health),
                rarity: .rare
            ),
            Achievement(
                title: "Fitness Fanatic",
                description: "Complete 50 fitness-related habits",
                icon: "figure.run.circle.fill",
                requirement: .categoryMaster(category: .fitness),
                rarity: .rare
            ),
            Achievement(
                title: "Knowledge Seeker",
                description: "Complete 50 learning-related habits",
                icon: "book.circle.fill",
                requirement: .categoryMaster(category: .learning),
                rarity: .rare
            ),
            Achievement(
                title: "Mindful Soul",
                description: "Complete 50 mindfulness-related habits",
                icon: "leaf.circle.fill",
                requirement: .categoryMaster(category: .mindfulness),
                rarity: .rare
            )
        ]
    }
}


class AchievementManager: ObservableObject {
    @Published var achievements: [Achievement] = []
    private let storageKey = "achievements_state"
    
    init() {
        if !loadFromStorage() {
            loadAchievements()
        }
    }
    
    private func loadAchievements() {
        achievements = Achievement.defaultAchievements
        saveToStorage()
    }
    
    func checkAchievements(for habits: [Habit], user: User) {
        for i in achievements.indices {
            if !achievements[i].isUnlocked && checkRequirement(achievements[i].requirement, habits: habits, user: user) {
                achievements[i].unlock()
                saveToStorage()
            }
        }
    }
    
    private func checkRequirement(_ requirement: AchievementRequirement, habits: [Habit], user: User) -> Bool {
        switch requirement {
        case .firstHabit:
            return !habits.isEmpty
        case .streak(let days):
            return habits.contains { $0.currentStreak >= days }
        case .totalCompletions(let count):
            let totalCompletions = habits.reduce(0) { $0 + $1.completions.count }
            return totalCompletions >= count
        case .allHabitsOneDay:
            return !habits.isEmpty && habits.allSatisfy { $0.isCompletedToday }
        case .weekPerfect:
            
            return checkPerfectPeriod(habits: habits, days: 7)
        case .monthPerfect:
            return checkPerfectPeriod(habits: habits, days: 30)
        case .experiencePoints(let points):
            let totalExp = habits.reduce(0) { $0 + $1.totalExperience }
            return totalExp >= points
        case .level(let level):
            let maxLevel = habits.map { $0.level }.max() ?? 0
            return maxLevel >= level
        case .habitsCount(let count):
            return habits.count >= count
        case .categoryMaster(let category):
            let categoryCompletions = habits
                .filter { $0.category == category }
                .reduce(0) { $0 + $1.completions.count }
            return categoryCompletions >= 50
        }
    }
    
    private func checkPerfectPeriod(habits: [Habit], days: Int) -> Bool {
        guard !habits.isEmpty else { return false }
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        for dayOffset in 0..<days {
            let checkDate = calendar.date(byAdding: .day, value: -dayOffset, to: today) ?? today
            
            for habit in habits {
                let hasCompletion = habit.completions.contains { completion in
                    calendar.isDate(completion, inSameDayAs: checkDate)
                }
                if !hasCompletion {
                    return false
                }
            }
        }
        
        return true
    }
    
    var unlockedAchievements: [Achievement] {
        return achievements.filter { $0.isUnlocked }
    }
    
    var recentAchievements: [Achievement] {
        return unlockedAchievements
            .sorted { $0.unlockedDate ?? Date.distantPast > $1.unlockedDate ?? Date.distantPast }
            .prefix(3)
            .map { $0 }
    }
    
    
    private func saveToStorage() {
        if let data = try? JSONEncoder().encode(achievements) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }
    
    private func loadFromStorage() -> Bool {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([Achievement].self, from: data) {
            achievements = decoded
            return true
        }
        return false
    }
}