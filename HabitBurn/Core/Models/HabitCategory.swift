import SwiftUI

enum HabitCategory: String, CaseIterable, Codable {
    case health = "Health"
    case fitness = "Fitness" 
    case learning = "Learning"
    case productivity = "Productivity"
    case mindfulness = "Mindfulness"
    case creativity = "Creativity"
    case social = "Social"
    case personal = "Personal"
    
    var icon: String {
        switch self {
        case .health:
            return "heart.fill"
        case .fitness:
            return "figure.run"
        case .learning:
            return "book.fill"
        case .productivity:
            return "briefcase.fill"
        case .mindfulness:
            return "leaf.fill"
        case .creativity:
            return "paintbrush.fill"
        case .social:
            return "person.2.fill"
        case .personal:
            return "person.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .health:
            return Color(red: 0.9, green: 0.3, blue: 0.3) 
        case .fitness:
            return Color(red: 1.0, green: 0.5, blue: 0.0) 
        case .learning:
            return Color(red: 0.2, green: 0.6, blue: 1.0) 
        case .productivity:
            return Color(red: 0.5, green: 0.2, blue: 0.8) 
        case .mindfulness:
            return Color(red: 0.2, green: 0.7, blue: 0.3) 
        case .creativity:
            return Color(red: 1.0, green: 0.6, blue: 0.8) 
        case .social:
            return Color(red: 1.0, green: 0.8, blue: 0.0) 
        case .personal:
            return FireColors.accentGold 
        }
    }
    
    var gradient: LinearGradient {
        switch self {
        case .health:
            return LinearGradient(
                colors: [Color(red: 0.9, green: 0.3, blue: 0.3), Color(red: 0.7, green: 0.1, blue: 0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .fitness:
            return LinearGradient(
                colors: [Color(red: 1.0, green: 0.5, blue: 0.0), Color(red: 0.8, green: 0.3, blue: 0.0)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .learning:
            return LinearGradient(
                colors: [Color(red: 0.2, green: 0.6, blue: 1.0), Color(red: 0.1, green: 0.4, blue: 0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .productivity:
            return LinearGradient(
                colors: [Color(red: 0.5, green: 0.2, blue: 0.8), Color(red: 0.3, green: 0.1, blue: 0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .mindfulness:
            return LinearGradient(
                colors: [Color(red: 0.2, green: 0.7, blue: 0.3), Color(red: 0.1, green: 0.5, blue: 0.2)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .creativity:
            return LinearGradient(
                colors: [Color(red: 1.0, green: 0.6, blue: 0.8), Color(red: 0.8, green: 0.4, blue: 0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .social:
            return LinearGradient(
                colors: [Color(red: 1.0, green: 0.8, blue: 0.0), Color(red: 0.8, green: 0.6, blue: 0.0)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .personal:
            return FireColors.buttonGradient
        }
    }
    
    var description: String {
        switch self {
        case .health:
            return "Physical and mental wellbeing"
        case .fitness:
            return "Exercise and physical activity"
        case .learning:
            return "Knowledge and skill development"
        case .productivity:
            return "Work and task management"
        case .mindfulness:
            return "Meditation and awareness"
        case .creativity:
            return "Art and creative expression"
        case .social:
            return "Relationships and community"
        case .personal:
            return "Self-improvement and growth"
        }
    }
}

enum HabitDifficulty: String, CaseIterable, Codable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    
    var icon: String {
        switch self {
        case .easy:
            return "1.circle.fill"
        case .medium:
            return "2.circle.fill"
        case .hard:
            return "3.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .easy:
            return Color.green
        case .medium:
            return Color.orange
        case .hard:
            return Color.red
        }
    }
    
    var experiencePoints: Int {
        switch self {
        case .easy:
            return 10
        case .medium:
            return 20
        case .hard:
            return 30
        }
    }
    
    var description: String {
        switch self {
        case .easy:
            return "Simple daily habits"
        case .medium:
            return "Moderate effort required"
        case .hard:
            return "Challenging and rewarding"
        }
    }
}

enum HabitFrequency: String, CaseIterable, Codable {
    case daily = "Daily"
    case weekdays = "Weekdays"
    case weekends = "Weekends"
    case weekly = "Weekly"
    
    var description: String {
        switch self {
        case .daily:
            return "Every day"
        case .weekdays:
            return "Monday to Friday"
        case .weekends:
            return "Saturday and Sunday"
        case .weekly:
            return "Once per week"
        }
    }
}

struct HabitGoal: Codable, Identifiable {
    let id = UUID()
    var title: String
    var targetStreak: Int
    var isCompleted: Bool = false
    var completedDate: Date?
    
    init(title: String, targetStreak: Int) {
        self.title = title
        self.targetStreak = targetStreak
    }
}