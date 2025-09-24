import SwiftUI

struct HabitDetailView: View {
    let habit: Habit
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.presentationMode) var presentationMode
    @State private var showingDeleteAlert = false
    
    var currentHabit: Habit {
        dataManager.habits.first { $0.id == habit.id } ?? habit
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: FireSpacing.xl) {
                        
                        VStack(spacing: FireSpacing.md) {
                            
                            HStack(spacing: FireSpacing.md) {
                                Image(systemName: currentHabit.icon)
                                    .font(.system(size: 50, weight: .bold))
                                    .foregroundColor(FireColors.accentGold)
                                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(currentHabit.title)
                                        .fireDisplayStyle()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Text("Created \(formatDate(currentHabit.createdAt))")
                                        .fireCaptionStyle()
                                }
                                
                                Spacer()
                            }
                            
                            
                            HStack(spacing: FireSpacing.lg) {
                                StatCard(title: "Streak", value: "\(currentHabit.currentStreak)", subtitle: "days")
                                StatCard(title: "This Week", value: "\(currentHabit.weeklyCompletions)", subtitle: "of 7")
                                StatCard(title: "This Month", value: "\(currentHabit.monthlyCompletions)", subtitle: "times")
                            }
                        }
                        
                        
                        VStack(spacing: FireSpacing.md) {
                            Text("This Week")
                                .fireHeadingStyle()
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            WeeklyProgressView(habit: currentHabit)
                        }

                        
                        VStack(spacing: FireSpacing.md) {
                            Text("Details")
                                .fireHeadingStyle()
                                .frame(maxWidth: .infinity, alignment: .leading)

                            LazyVGrid(columns: [
                                GridItem(.flexible(minimum: 0, maximum: .infinity)),
                                GridItem(.flexible(minimum: 0, maximum: .infinity))
                            ], spacing: FireSpacing.sm) {
                                
                                HStack(spacing: FireSpacing.xs) {
                                    Image(systemName: currentHabit.difficulty.icon)
                                        .font(.caption)
                                        .foregroundColor(currentHabit.difficulty.color)
                                    Text(currentHabit.difficulty.rawValue)
                                        .fireCaptionStyle()
                                }

                                
                                HStack(spacing: FireSpacing.xs) {
                                    Image(systemName: "clock.fill")
                                        .font(.caption)
                                        .foregroundColor(FireColors.accentGold)
                                    Text(currentHabit.frequency.rawValue)
                                        .fireCaptionStyle()
                                }

                                
                                HStack(spacing: FireSpacing.xs) {
                                    Image(systemName: "bell.fill")
                                        .font(.caption)
                                        .foregroundColor(currentHabit.reminderTime != nil ? FireColors.accentGold : FireColors.secondaryText)
                                    Text(currentHabit.reminderTime != nil ? formatTime(currentHabit.reminderTime!) : "No reminder")
                                        .fireCaptionStyle()
                                }

                                
                                HStack(spacing: FireSpacing.xs) {
                                    Circle()
                                        .fill(currentHabit.habitColor)
                                        .frame(width: 12, height: 12)
                                        .overlay(Circle().stroke(Color.white.opacity(0.2), lineWidth: 1))
                                    Text("Color")
                                        .fireCaptionStyle()
                                }
                            }
                        }
                        
                        
                        VStack(spacing: FireSpacing.md) {
                            Text("7-Day Progress")
                                .fireHeadingStyle()
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            WeeklyChartView(habit: currentHabit)
                        }
                        
                        
                        HStack(spacing: FireSpacing.md) {
                            
                            FireButton(
                                currentHabit.isCompletedToday ? "MARK INCOMPLETE" : "MARK COMPLETE",
                                style: currentHabit.isCompletedToday ? .secondary : .primary,
                                icon: currentHabit.isCompletedToday ? "flame.fill" : "flame",
                                minHeight: FireSpacing.minTouchTarget * 0.7
                            ) {
                                dataManager.toggleHabitCompletion(currentHabit.id)
                            }
                            .frame(maxWidth: .infinity)
                            
                            
                            FireButton("DELETE HABIT", style: .secondary, icon: "trash.fill", minHeight: FireSpacing.minTouchTarget * 0.7) {
                                showingDeleteAlert = true
                            }
                            .frame(maxWidth: .infinity)
                            .foregroundColor(FireColors.error)
                        }
                    }
                    .fireScreenPadding()
                }
                .background(BackgroundImageView("ModalBackground"))
                
                
                VStack {
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 30))
                                .foregroundColor(FireColors.secondaryText)
                                .background(
                                    Circle()
                                        .fill(FireColors.primaryDark.opacity(0.8))
                                )
                        }
                    }
                    
                    Spacer()
                }
                .fireScreenPadding()
            }
            .navigationBarHidden(true)
        }
        .background(BackgroundImageView("ModalBackground"))
        .alert("Delete Habit", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                dataManager.deleteHabit(currentHabit)
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this habit? This action cannot be undone.")
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String
    
    var body: some View {
        FireCard {
            VStack(spacing: 4) {
                Text(title)
                    .fireCaptionStyle()
                
                Text(value)
                    .font(FireFonts.display(28))
                    .foregroundColor(FireColors.accentGold)
                
                Text(subtitle)
                    .fireCaptionStyle()
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct WeeklyProgressView: View {
    let habit: Habit
    
    private let weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    var body: some View {
        FireCard {
            VStack(spacing: FireSpacing.md) {
                HStack {
                    ForEach(0..<7, id: \.self) { index in
                        VStack(spacing: 8) {
                            Text(weekdays[index])
                                .fireCaptionStyle()
                            
                            Circle()
                                .fill(habit.last7DaysStatus[index] ? FireColors.accentGold : FireColors.secondaryText.opacity(0.3))
                                .frame(width: 24, height: 24)
                                .overlay(
                                    Circle()
                                        .stroke(
                                            habit.last7DaysStatus[index] ? FireColors.accentGold : FireColors.secondaryText.opacity(0.5),
                                            lineWidth: habit.last7DaysStatus[index] ? 2 : 1
                                        )
                                )
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                
                Text("\(habit.weeklyCompletions) of 7 days completed")
                    .fireCaptionStyle()
            }
        }
    }
}

struct WeeklyChartView: View {
    let habit: Habit
    
    var body: some View {
        FireCard {
            VStack(spacing: FireSpacing.md) {
                HStack(alignment: .bottom, spacing: 4) {
                    ForEach(0..<7, id: \.self) { index in
                        VStack(spacing: 4) {
                            Group {
                                if habit.last7DaysStatus[index] {
                                    RoundedRectangle(cornerRadius: 2)
                                        .fill(FireColors.buttonGradient)
                                } else {
                                    RoundedRectangle(cornerRadius: 2)
                                        .fill(FireColors.secondaryText.opacity(0.3))
                                }
                            }
                                .frame(width: 20, height: habit.last7DaysStatus[index] ? 40 : 8)
                            
                            Text("\(index + 1)")
                                .font(.caption2)
                                .foregroundColor(FireColors.secondaryText)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .frame(height: 60)
                
                Text("Last 7 days progress")
                    .fireCaptionStyle()
            }
        }
    }
}

struct HabitDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let habit = Habit.sampleHabits[0]
        
        HabitDetailView(habit: habit)
            .environmentObject(DataManager.shared)
    }
}