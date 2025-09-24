import SwiftUI

struct StatsView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showingResetAlert = false
    
    var overallStats: (totalHabits: Int, completedToday: Int, weeklyAverage: Double) {
        dataManager.getOverallStats()
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: FireSpacing.xl) {
                        
                        VStack(spacing: FireSpacing.sm) {
                            Text("Your Progress")
                                .fireDisplayStyle()
                            
                            Text("Track your habit journey")
                                .fireBodyStyle()
                        }
                        .padding(.top, FireSpacing.lg)
                        
                        if dataManager.habits.isEmpty {
                            EmptyStatsView()
                        } else {
                            VStack(spacing: FireSpacing.xl) {
                                
                                VStack(spacing: FireSpacing.md) {
                                    Text("Today's Overview")
                                        .fireHeadingStyle()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    HStack(spacing: FireSpacing.md) {
                                        StaticOverallStatCard(
                                            title: "Habits",
                                            value: "\(overallStats.totalHabits)",
                                            subtitle: "total"
                                        )
                                        
                                        StaticOverallStatCard(
                                            title: "Completed",
                                            value: "\(overallStats.completedToday)",
                                            subtitle: "today"
                                        )
                                        
                                        StaticOverallStatCard(
                                            title: "Weekly Avg",
                                            value: String(format: "%.0f%%", overallStats.weeklyAverage * 100),
                                            subtitle: "rate"
                                        )
                                    }
                                }
                                
                                
                                VStack(spacing: FireSpacing.md) {
                                    Text("Today's Progress")
                                        .fireHeadingStyle()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    StaticCircularProgressView(
                                        progress: dataManager.habits.isEmpty ? 0.0 : Double(overallStats.completedToday) / Double(overallStats.totalHabits),
                                        total: overallStats.totalHabits,
                                        completed: overallStats.completedToday
                                    )
                                }
                                
                                
                                VStack(spacing: FireSpacing.md) {
                                    Text("Habit Performance")
                                        .fireHeadingStyle()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    VStack(spacing: FireSpacing.sm) {
                                        ForEach(dataManager.habits) { habit in
                                            StaticHabitStatsRow(habit: habit)
                                        }
                                    }
                                }
                                
                                
                                VStack(spacing: FireSpacing.md) {
                                    Text("Danger Zone")
                                        .fireHeadingStyle()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    FireButton("RESET STATS", style: .secondary, icon: "arrow.clockwise") {
                                        showingResetAlert = true
                                    }
                                    .foregroundColor(FireColors.warning)
                                }
                            }
                        }
                    }
                    .fireScreenPadding()
                }
                .background(BackgroundImageView("MainBackground"))
            }
            .navigationBarHidden(true)
        }
        .alert("Reset Statistics", isPresented: $showingResetAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                dataManager.resetStats()
            }
        } message: {
            Text("Are you sure you want to reset all habit statistics? This will clear all completion data but keep your habits.")
        }
    }
}

struct EmptyStatsView: View {
    var body: some View {
        VStack(spacing: FireSpacing.xl) {
            Spacer()
            
            VStack(spacing: FireSpacing.lg) {
                Image(systemName: "chart.bar")
                    .font(.system(size: 60, weight: .light))
                    .foregroundColor(FireColors.secondaryText)
                
                VStack(spacing: FireSpacing.sm) {
                    Text("No Statistics Yet")
                        .fireHeadingStyle()
                    
                    Text("Create some habits and start tracking to see your progress here")
                        .fireBodyStyle()
                        .multilineTextAlignment(.center)
                }
            }
            
            Spacer()
        }
        .fireScreenPadding()
    }
}

struct StaticOverallStatCard: View {
    let title: String
    let value: String
    let subtitle: String
    
    var body: some View {
        FireCard {
            VStack(spacing: 4) {
                Text(title)
                    .fireCaptionStyle()
                
                Text(value)
                    .font(FireFonts.display(24))
                    .foregroundColor(FireColors.accentGold)
                
                Text(subtitle)
                    .fireCaptionStyle()
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct StaticCircularProgressView: View {
    let progress: Double
    let total: Int
    let completed: Int
    
    var body: some View {
        FireCard {
            VStack(spacing: FireSpacing.md) {
                ZStack {
                    
                    Circle()
                        .stroke(FireColors.secondaryText.opacity(0.2), lineWidth: 8)
                        .frame(width: 120, height: 120)
                    
                    
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(
                            AngularGradient(
                                gradient: Gradient(colors: [FireColors.primaryLight, FireColors.accentGold]),
                                center: .center,
                                startAngle: .degrees(-90),
                                endAngle: .degrees(270)
                            ),
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(-90))
                    
                    
                    VStack(spacing: 2) {
                        Text("\(completed)")
                            .font(FireFonts.display(36))
                            .foregroundColor(FireColors.accentGold)
                        
                        Text("of \(total)")
                            .fireCaptionStyle()
                    }
                }
                
                Text(String(format: "%.0f%% Complete", progress * 100))
                    .fireBodyStyle()
            }
        }
    }
}

struct StaticHabitStatsRow: View {
    let habit: Habit
    
    var body: some View {
        FireCard {
            HStack(spacing: FireSpacing.md) {
                
                Image(systemName: habit.icon)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(FireColors.accentGold)
                    .frame(width: 30, height: 30)
                
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(habit.title)
                        .fireHeadingStyle()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack(spacing: FireSpacing.sm) {
                        Text("\(habit.currentStreak) day streak")
                            .fireCaptionStyle()
                        
                        Spacer()
                        
                        Text("\(habit.weeklyCompletions)/7 this week")
                            .fireCaptionStyle()
                    }
                }
                
                
                VStack(spacing: 4) {
                    Text(String(format: "%.0f%%", habit.weeklyCompletionPercentage * 100))
                        .fireCaptionStyle()
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(FireColors.secondaryText.opacity(0.2))
                        .frame(width: 60, height: 8)
                        .overlay(
                            Group {
                                if habit.weeklyCompletionPercentage > 0 {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(FireColors.buttonGradient)
                                        .frame(width: 60 * habit.weeklyCompletionPercentage, height: 8)
                                } else {
                                    EmptyView()
                                }
                            },
                            alignment: .leading
                        )
                }
            }
        }
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        let dataManager = DataManager.shared
        dataManager.habits = Habit.sampleHabits
        
        return StatsView()
            .environmentObject(dataManager)
    }
}