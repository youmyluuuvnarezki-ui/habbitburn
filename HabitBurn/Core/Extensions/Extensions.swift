import SwiftUI


extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 3:
            (r, g, b) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (1, 1, 1)
        }
        self.init(
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255
        )
    }
}


extension Date {
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: self) ?? self
    }
    
    func isSameDay(as date: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: date)
    }
    
    func daysFromNow(_ days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: days, to: self) ?? self
    }
}


extension UIImpactFeedbackGenerator {
    static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }
}

extension UINotificationFeedbackGenerator {
    static func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
}


extension View {
    func onTapHaptic(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .light, perform action: @escaping () -> Void) -> some View {
        onTapGesture {
            UIImpactFeedbackGenerator.impact(style)
            action()
        }
    }
    
    func hapticFeedback(_ type: UINotificationFeedbackGenerator.FeedbackType) -> some View {
        onAppear {
            UINotificationFeedbackGenerator.notification(type)
        }
    }
}


extension Array where Element == Habit {
    var completedToday: [Habit] {
        filter { $0.isCompletedToday }
    }
    
    var notCompletedToday: [Habit] {
        filter { !$0.isCompletedToday }
    }
    
    var averageWeeklyCompletion: Double {
        guard !isEmpty else { return 0.0 }
        let total = map { $0.weeklyCompletionPercentage }.reduce(0, +)
        return total / Double(count)
    }
}