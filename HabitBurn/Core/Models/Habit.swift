import Foundation
import SwiftUI

struct Habit: Identifiable, Codable, Hashable {
    let id: UUID
    var title: String
    var icon: String
    var category: HabitCategory
    var difficulty: HabitDifficulty
    var frequency: HabitFrequency
    var reminderTime: Date?
    var notes: String
    var color: String 
    var createdAt: Date
    var completions: [Date]
    var goals: [HabitGoal]
    var totalExperience: Int
    
    init(title: String, 
         icon: String = "flame.fill", 
         category: HabitCategory = .personal, 
         difficulty: HabitDifficulty = .medium, 
         frequency: HabitFrequency = .daily) {
        self.id = UUID()
        self.title = title
        self.icon = icon
        self.category = category
        self.difficulty = difficulty
        self.frequency = frequency
        self.reminderTime = nil
        self.notes = ""
        self.color = "#DAA520" 
        self.createdAt = Date()
        self.completions = []
        self.goals = []
        self.totalExperience = 0
    }
    
    
    
    
    var isCompletedToday: Bool {
        let today = Calendar.current.startOfDay(for: Date())
        return completions.contains { completion in
            Calendar.current.isDate(completion, inSameDayAs: today)
        }
    }
    
    
    var weeklyCompletions: Int {
        let calendar = Calendar.current
        let now = Date()
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: now)?.start ?? now
        
        return completions.filter { completion in
            completion >= startOfWeek && completion <= now
        }.count
    }
    
    
    var monthlyCompletions: Int {
        let calendar = Calendar.current
        let now = Date()
        let startOfMonth = calendar.dateInterval(of: .month, for: now)?.start ?? now
        
        return completions.filter { completion in
            completion >= startOfMonth && completion <= now
        }.count
    }
    
    
    var weeklyCompletionPercentage: Double {
        let calendar = Calendar.current
        let now = Date()
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: now)?.start ?? now
        let daysInWeek = calendar.dateComponents([.day], from: startOfWeek, to: now).day ?? 0
        let actualDays = min(daysInWeek + 1, 7) 
        
        guard actualDays > 0 else { return 0.0 }
        
        return Double(weeklyCompletions) / Double(actualDays)
    }
    
    
    var currentStreak: Int {
        let calendar = Calendar.current
        let sortedCompletions = completions
            .map { calendar.startOfDay(for: $0) }
            .sorted(by: >)
        
        guard !sortedCompletions.isEmpty else { return 0 }
        
        var streak = 0
        var currentDate = calendar.startOfDay(for: Date())
        
        for completion in sortedCompletions {
            if calendar.isDate(completion, inSameDayAs: currentDate) {
                streak += 1
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
            } else if completion < currentDate {
                
                break
            }
        }
        
        return streak
    }
    
    
    var last7DaysStatus: [Bool] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        var status: [Bool] = []
        
        for i in 0..<7 {
            let date = calendar.date(byAdding: .day, value: -i, to: today) ?? today
            let isCompleted = completions.contains { completion in
                calendar.isDate(completion, inSameDayAs: date)
            }
            status.append(isCompleted)
        }
        
        return status.reversed() 
    }
    
    
    
    
    mutating func markCompleted() {
        guard !isCompletedToday else { return }
        completions.append(Date())
    }
    
    
    mutating func unmarkCompleted() {
        let today = Calendar.current.startOfDay(for: Date())
        completions.removeAll { completion in
            Calendar.current.isDate(completion, inSameDayAs: today)
        }
    }
    
    
    mutating func toggleCompletion() {
        if isCompletedToday {
            unmarkCompleted()
        } else {
            markCompleted()
            
            totalExperience += difficulty.experiencePoints
        }
    }
    
    
    
    
    var level: Int {
        return max(1, totalExperience / 100)
    }
    
    
    var experienceToNextLevel: Int {
        let nextLevelExp = level * 100
        return nextLevelExp - totalExperience
    }
    
    
    var levelProgress: Double {
        let currentLevelExp = (level - 1) * 100
        let nextLevelExp = level * 100
        let currentProgress = totalExperience - currentLevelExp
        let levelRange = nextLevelExp - currentLevelExp
        return Double(currentProgress) / Double(levelRange)
    }
    
    
    var shouldCompleteToday: Bool {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: Date())
        
        switch frequency {
        case .daily:
            return true
        case .weekdays:
            return weekday >= 2 && weekday <= 6 
        case .weekends:
            return weekday == 1 || weekday == 7 
        case .weekly:
            return true 
        }
    }
    
    
    var habitColor: Color {
        return Color(hex: color) ?? category.color
    }
    
    
    var activeGoals: [HabitGoal] {
        return goals.filter { !$0.isCompleted }
    }
    
    
    mutating func checkGoalCompletion() {
        for i in goals.indices {
            if !goals[i].isCompleted && currentStreak >= goals[i].targetStreak {
                goals[i].isCompleted = true
                goals[i].completedDate = Date()
            }
        }
    }
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Habit, rhs: Habit) -> Bool {
        return lhs.id == rhs.id
    }
}


extension Habit {
    static var sampleHabits: [Habit] {
        return [
            Habit(title: "Read Books", icon: "book.fill", category: .learning, difficulty: .easy, frequency: .daily),
            Habit(title: "Drink Water", icon: "drop.fill", category: .health, difficulty: .easy, frequency: .daily),
            Habit(title: "Exercise", icon: "figure.run", category: .fitness, difficulty: .medium, frequency: .daily),
            Habit(title: "Meditate", icon: "leaf.fill", category: .mindfulness, difficulty: .medium, frequency: .daily),
            Habit(title: "Write Journal", icon: "pencil", category: .personal, difficulty: .easy, frequency: .daily)
        ]
    }
}