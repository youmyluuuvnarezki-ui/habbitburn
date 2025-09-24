import SwiftUI

struct EnhancedHomeView: View {
    @EnvironmentObject var dataManager: DataManager
    @StateObject private var achievementManager = AchievementManager()
    
    @State private var showingAddHabit = false
    @State private var selectedHabit: Habit?
    @State private var showingAchievements = false
    @State private var selectedFilter: HabitFilter = .all
    
    private let motivationalQuotes = [
        "Small progress is still progress",
        "Every day is a new beginning",
        "You are what you repeatedly do",
        "Success is the sum of small efforts",
        "Don't break the chain",
        "Progress over perfection",
        "One habit at a time"
    ]
    
    var todaysQuote: String {
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        return motivationalQuotes[dayOfYear % motivationalQuotes.count]
    }
    
    var filteredHabits: [Habit] {
        switch selectedFilter {
        case .all:
            return dataManager.habits
        case .completed:
            return dataManager.habits.filter { $0.isCompletedToday }
        case .pending:
            return dataManager.habits.filter { !$0.isCompletedToday && $0.shouldCompleteToday }
        case .category(let category):
            return dataManager.habits.filter { $0.category == category }
        }
    }
    
    var userLevel: Int {
        let totalExp = dataManager.habits.reduce(0) { $0 + $1.totalExperience }
        return max(1, totalExp / 500) 
    }
    
    var userProgress: Double {
        let totalExp = dataManager.habits.reduce(0) { $0 + $1.totalExperience }
        let currentLevelExp = (userLevel - 1) * 500
        let nextLevelExp = userLevel * 500
        let currentProgress = totalExp - currentLevelExp
        let levelRange = nextLevelExp - currentLevelExp
        return Double(currentProgress) / Double(levelRange)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 0) {
                    
                    VStack(spacing: FireSpacing.md) {
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                if !dataManager.user.name.isEmpty {
                                    Text("Hello, \(dataManager.user.name)!")
                                        .fireHeadingStyle()
                                } else {
                                    Text("Hello, Habit Builder!")
                                        .fireHeadingStyle()
                                }
                                
                                HStack(spacing: 4) {
                                    Image(systemName: "star.fill")
                                        .font(.caption)
                                        .foregroundColor(FireColors.accentGold)
                                    
                                    Text("Level \(userLevel)")
                                        .fireCaptionStyle()
                                        .foregroundColor(FireColors.accentGold)
                                }
                            }
                            
                            Spacer()
                            
                            
                            Button(action: {
                                showingAchievements = true
                            }) {
                                HStack(spacing: 4) {
                                    Image(systemName: "trophy.fill")
                                        .foregroundColor(FireColors.accentGold)
                                        .font(.system(size: 18, weight: .bold))
                                    
                                    Text("\(achievementManager.unlockedAchievements.count)")
                                        .font(FireFonts.bodyBold(14))
                                        .foregroundColor(FireColors.accentGold)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(FireColors.primaryDark.opacity(0.5))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(FireColors.accentGold.opacity(0.3), lineWidth: 1)
                                        )
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        
                        
                        VStack(spacing: 4) {
                            HStack {
                                Text("Level Progress")
                                    .fireCaptionStyle()
                                
                                Spacer()
                                
                                let totalExp = dataManager.habits.reduce(0) { $0 + $1.totalExperience }
                                Text("\(totalExp) XP")
                                    .fireCaptionStyle()
                                    .foregroundColor(FireColors.accentGold)
                            }
                            
                            ProgressView(value: userProgress)
                                .progressViewStyle(FireProgressViewStyle())
                        }
                        
                        
                        VStack(spacing: 4) {
                            HStack {
                                Image(systemName: "quote.bubble.fill")
                                    .font(.caption)
                                    .foregroundColor(FireColors.accentGold)
                                
                                Text("Today's Motivation")
                                    .fireCaptionStyle()
                                    .foregroundColor(FireColors.accentGold)
                                
                                Spacer()
                            }
                            
                            Text(todaysQuote)
                                .fireBodyStyle()
                                .font(.system(size: 16, design: .default).italic())
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, FireSpacing.sm)
                        }
                        .padding(FireSpacing.sm)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(FireColors.accentGold.opacity(0.1))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(FireColors.accentGold.opacity(0.3), lineWidth: 1)
                                )
                        )
                        
                        
                        HStack(spacing: FireSpacing.sm) {
                            StatBadge(
                                title: "Today",
                                value: "\(dataManager.habits.filter { $0.isCompletedToday }.count)/\(dataManager.habits.count)",
                                icon: "checkmark.circle.fill",
                                color: FireColors.success
                            )
                            
                            StatBadge(
                                title: "Streak",
                                value: "\(dataManager.habits.map { $0.currentStreak }.max() ?? 0)",
                                icon: "flame.fill",
                                color: FireColors.primaryLight
                            )
                            
                            StatBadge(
                                title: "Total",
                                value: "\(dataManager.habits.reduce(0) { $0 + $1.completions.count })",
                                icon: "star.fill",
                                color: FireColors.accentGold
                            )
                        }
                    }
                    .fireScreenPadding()
                    
                    
                    FilterTabsView(selectedFilter: $selectedFilter, habits: dataManager.habits)
                    
                    
                    if dataManager.habits.isEmpty {
                        EnhancedEmptyStateView()
                    } else {
                        EnhancedHabitListView(
                            habits: filteredHabits,
                            selectedHabit: $selectedHabit
                        )
                    }
                }
                .background(BackgroundImageView("MainBackground"))
                
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        
                        EnhancedFABView {
                            showingAddHabit = true
                        }
                        .disabled(dataManager.habits.count >= 7)
                        .opacity(dataManager.habits.count >= 7 ? 0.5 : 1.0)
                    }
                    .padding(.trailing, FireSpacing.md)
                    .padding(.bottom, FireSpacing.md)
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingAddHabit) {
            EnhancedAddHabitView()
        }
        .sheet(item: $selectedHabit) { habit in
            EnhancedHabitDetailView(habit: habit)
        }
        .sheet(isPresented: $showingAchievements) {
            AchievementsView(achievementManager: achievementManager)
        }
        .onAppear {
            achievementManager.checkAchievements(for: dataManager.habits, user: dataManager.user)
        }
        .onChange(of: dataManager.habits) { _ in
            achievementManager.checkAchievements(for: dataManager.habits, user: dataManager.user)
        }
    }
}

enum HabitFilter: Equatable {
    case all
    case completed
    case pending
    case category(HabitCategory)
    
    var title: String {
        switch self {
        case .all:
            return "All"
        case .completed:
            return "Done"
        case .pending:
            return "Todo"
        case .category(let category):
            return category.rawValue
        }
    }
    
    var icon: String {
        switch self {
        case .all:
            return "square.grid.2x2.fill"
        case .completed:
            return "checkmark.circle.fill"
        case .pending:
            return "clock.fill"
        case .category(let category):
            return category.icon
        }
    }
}

struct StatBadge: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 2) {
            HStack(spacing: 2) {
                Image(systemName: icon)
                    .font(.caption2)
                    .foregroundColor(color)
                
                Text(value)
                    .font(FireFonts.bodyBold(12))
                    .foregroundColor(color)
            }
            
            Text(title)
                .fireCaptionStyle()
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, FireSpacing.xs)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(color.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct FireProgressViewStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(FireColors.secondaryText.opacity(0.2))
                    .frame(height: 8)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(FireColors.buttonGradient)
                    .frame(width: geometry.size.width * CGFloat(configuration.fractionCompleted ?? 0), height: 8)
            }
        }
        .frame(height: 8)
    }
}

struct FilterTabsView: View {
    @Binding var selectedFilter: HabitFilter
    let habits: [Habit]
    
    private var availableFilters: [HabitFilter] {
        var filters: [HabitFilter] = [.all, .completed, .pending]
        
        
        let categoriesWithHabits = Set(habits.map { $0.category })
        for category in HabitCategory.allCases {
            if categoriesWithHabits.contains(category) {
                filters.append(.category(category))
            }
        }
        
        return filters
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: FireSpacing.sm) {
                ForEach(availableFilters, id: \.title) { filter in
                    FilterTab(
                        filter: filter,
                        isSelected: selectedFilter == filter,
                        onTap: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedFilter = filter
                            }
                        }
                    )
                }
            }
            .padding(.horizontal, FireSpacing.md)
        }
    }
}

struct FilterTab: View {
    let filter: HabitFilter
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 6) {
                Image(systemName: filter.icon)
                    .font(.system(size: 12, weight: .bold))
                
                Text(filter.title)
                    .font(FireFonts.caption(12))
                    .fontWeight(.semibold)
            }
            .foregroundColor(isSelected ? FireColors.primaryText : FireColors.secondaryText)
            .padding(.horizontal, FireSpacing.sm)
            .padding(.vertical, FireSpacing.xs)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? FireColors.accentGold.opacity(0.2) : FireColors.primaryDark.opacity(0.3))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                isSelected ? FireColors.accentGold : FireColors.secondaryText.opacity(0.3),
                                lineWidth: isSelected ? 1 : 0.5
                            )
                    )
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct EnhancedEmptyStateView: View {
    var body: some View {
        VStack(spacing: FireSpacing.xl) {
            Spacer()
            
            VStack(spacing: FireSpacing.lg) {
                Image(systemName: "flame")
                    .font(.system(size: 60, weight: .light))
                    .foregroundColor(FireColors.secondaryText)
                
                VStack(spacing: FireSpacing.sm) {
                    Text("Ready to Build Habits?")
                        .fireHeadingStyle()
                    
                    Text("Start your journey by creating your first habit. Tap the + button to begin building positive routines that will transform your life.")
                        .fireBodyStyle()
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, FireSpacing.md)
                }
            }
            
            Spacer()
        }
        .fireScreenPadding()
    }
}

struct EnhancedHabitListView: View {
    let habits: [Habit]
    @Binding var selectedHabit: Habit?
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: FireSpacing.md) {
                ForEach(habits) { habit in
                    EnhancedHabitCardView(habit: habit) {
                        selectedHabit = habit
                    }
                }
            }
            .fireScreenPadding()
            .padding(.bottom, 80) 
        }
    }
}

struct EnhancedHabitCardView: View {
    let habit: Habit
    let onTap: () -> Void
    
    @EnvironmentObject var dataManager: DataManager
    @State private var showFireAnimation = false
    
    var body: some View {
        Button(action: onTap) {
            FireCard {
                VStack(spacing: FireSpacing.sm) {
                    
                    HStack(spacing: FireSpacing.md) {
                        
                        Image(systemName: habit.icon)
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(habit.category.color)
                            .frame(width: 40, height: 40)
                        
                        
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(habit.title)
                                    .fireHeadingStyle()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                
                                Text("L\(habit.level)")
                                    .font(FireFonts.caption(10))
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(FireColors.accentGold.opacity(0.2))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(FireColors.accentGold, lineWidth: 1)
                                            )
                                    )
                                    .foregroundColor(FireColors.accentGold)
                            }
                            
                            HStack(spacing: FireSpacing.sm) {
                                
                                Text(habit.category.rawValue)
                                    .font(FireFonts.caption(9))
                                    .padding(.horizontal, 4)
                                    .padding(.vertical, 1)
                                    .background(
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(habit.category.color.opacity(0.2))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 4)
                                                    .stroke(habit.category.color, lineWidth: 0.5)
                                            )
                                    )
                                    .foregroundColor(habit.category.color)
                                
                                
                                HStack(spacing: 1) {
                                    Image(systemName: habit.difficulty.icon)
                                        .font(.system(size: 8))
                                    Text(habit.difficulty.rawValue)
                                        .font(FireFonts.caption(9))
                                }
                                .foregroundColor(habit.difficulty.color)
                                
                                Spacer()
                                
                                
                                HStack(spacing: 2) {
                                    Image(systemName: "flame.fill")
                                        .font(.system(size: 8))
                                        .foregroundColor(FireColors.primaryLight)
                                    
                                    Text("\(habit.currentStreak) day streak")
                                        .fireCaptionStyle()
                                }
                            }
                        }
                        
                        
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                dataManager.toggleHabitCompletion(habit.id)
                                showFireAnimation = true
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                showFireAnimation = false
                            }
                        }) {
                            Image(systemName: habit.isCompletedToday ? "flame.fill" : "flame")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(habit.isCompletedToday ? FireColors.accentGold : FireColors.primaryLight)
                                .frame(width: 44, height: 44)
                                .background(
                                    Circle()
                                        .fill(FireColors.primaryDark.opacity(0.5))
                                        .overlay(
                                            Circle()
                                                .stroke(
                                                    habit.isCompletedToday ? FireColors.accentGold : FireColors.primaryLight.opacity(0.3),
                                                    lineWidth: habit.isCompletedToday ? 2 : 1
                                                )
                                        )
                                )
                                .scaleEffect(showFireAnimation ? 1.3 : 1.0)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    
                    VStack(spacing: 2) {
                        HStack {
                            Text("XP Progress")
                                .fireCaptionStyle()
                            
                            Spacer()
                            
                            Text("\(habit.totalExperience) XP")
                                .fireCaptionStyle()
                                .foregroundColor(FireColors.accentGold)
                        }
                        
                        ProgressView(value: habit.levelProgress)
                            .progressViewStyle(FireProgressViewStyle())
                    }
                    
                    
                    if !habit.activeGoals.isEmpty {
                        HStack {
                            Image(systemName: "target")
                                .font(.caption2)
                                .foregroundColor(FireColors.accentGold)
                            
                            Text("Goal: \(habit.activeGoals.first?.title ?? "")")
                                .fireCaptionStyle()
                                .foregroundColor(FireColors.accentGold)
                            
                            Spacer()
                        }
                    }
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct EnhancedFABView: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(FireColors.buttonGradient)
                    .frame(width: FireSpacing.fabSize, height: FireSpacing.fabSize)
                    .overlay(
                        Circle()
                            .stroke(FireColors.primaryText, lineWidth: 3)
                    )
                    .shadow(
                        color: FireColors.primaryLight.opacity(0.4),
                        radius: 8,
                        x: 0,
                        y: 4
                    )
                
                Image(systemName: "plus")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(FireColors.primaryText)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct EnhancedHomeView_Previews: PreviewProvider {
    static var previews: some View {
        let dataManager = DataManager.shared
        dataManager.habits = Habit.sampleHabits
        
        return EnhancedHomeView()
            .environmentObject(dataManager)
    }
}