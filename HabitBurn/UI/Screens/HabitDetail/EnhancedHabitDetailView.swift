import SwiftUI

struct EnhancedHabitDetailView: View {
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
                                    .foregroundColor(currentHabit.category.color)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(currentHabit.title)
                                        .fireDisplayStyle()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    HStack {
                                        Text(currentHabit.category.rawValue)
                                            .font(.system(size: 12, weight: .semibold))
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .fill(currentHabit.category.gradient)
                                            )
                                            .foregroundColor(FireColors.primaryText)
                                        
                                        Text("Level \(currentHabit.level)")
                                            .font(.system(size: 12, weight: .bold))
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
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
                                    
                                    Text("Created \(formatDate(currentHabit.createdAt))")
                                        .fireCaptionStyle()
                                }
                                
                                Spacer()
                            }
                            
                            
                            VStack(spacing: FireSpacing.sm) {
                                HStack {
                                    Text("Experience Progress")
                                        .fireHeadingStyle()
                                    
                                    Spacer()
                                    
                                    Text("\(currentHabit.totalExperience) XP")
                                        .fireHeadingStyle()
                                        .foregroundColor(FireColors.accentGold)
                                }
                                
                                ProgressView(value: currentHabit.levelProgress)
                                    .progressViewStyle(FireProgressViewStyle())
                                
                                HStack {
                                    Text("Level \(currentHabit.level)")
                                        .fireCaptionStyle()
                                    
                                    Spacer()
                                    
                                    Text("\(currentHabit.experienceToNextLevel) XP to next level")
                                        .fireCaptionStyle()
                                }
                            }
                            
                            
                            HStack(spacing: FireSpacing.lg) {
                                StatCard(title: "Streak", value: "\(currentHabit.currentStreak)", subtitle: "days")
                                StatCard(title: "This Week", value: "\(currentHabit.weeklyCompletions)", subtitle: "of 7")
                                StatCard(title: "Total XP", value: "\(currentHabit.totalExperience)", subtitle: "points")
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
                        
                        
                        if !currentHabit.goals.isEmpty {
                            VStack(spacing: FireSpacing.md) {
                                Text("Goals")
                                    .fireHeadingStyle()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                ForEach(currentHabit.goals, id: \.id) { goal in
                                    GoalProgressCard(goal: goal, currentStreak: currentHabit.currentStreak)
                                }
                            }
                        }
                        
                        
                        if !currentHabit.notes.isEmpty {
                            VStack(spacing: FireSpacing.md) {
                                Text("Notes")
                                    .fireHeadingStyle()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                FireCard {
                                    Text(currentHabit.notes)
                                        .fireBodyStyle()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
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

struct GoalProgressCard: View {
    let goal: HabitGoal
    let currentStreak: Int
    
    var progress: Double {
        return min(Double(currentStreak) / Double(goal.targetStreak), 1.0)
    }
    
    var body: some View {
        FireCard {
            VStack(spacing: FireSpacing.sm) {
                HStack {
                    Text(goal.title)
                        .fireHeadingStyle()
                    
                    Spacer()
                    
                    if goal.isCompleted {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(FireColors.success)
                            Text("Completed!")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(FireColors.success)
                        }
                    } else {
                        Text("\(currentStreak)/\(goal.targetStreak) days")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(FireColors.accentGold)
                    }
                }
                
                ProgressView(value: progress)
                    .progressViewStyle(FireProgressViewStyle())
                
                if !goal.isCompleted {
                    let remaining = goal.targetStreak - currentStreak
                    if remaining > 0 {
                        Text("\(remaining) more days to reach this goal")
                            .fireCaptionStyle()
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
        }
    }
}

struct EnhancedHabitDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let habit = Habit.sampleHabits[0]
        
        EnhancedHabitDetailView(habit: habit)
            .environmentObject(DataManager.shared)
    }
}