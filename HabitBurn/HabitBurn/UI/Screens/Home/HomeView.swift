import SwiftUI

struct HomeView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showingAddHabit = false
    @State private var selectedHabit: Habit?
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 0) {
                    
                    VStack(spacing: FireSpacing.sm) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                if !dataManager.user.name.isEmpty {
                                    Text("Hello, \(dataManager.user.name)!")
                                        .fireHeadingStyle()
                                } else {
                                    Text("Hello!")
                                        .fireHeadingStyle()
                                }
                                
                                Text("Let's build some habits")
                                    .fireCaptionStyle()
                            }
                            
                            Spacer()
                            
                            
                            HStack(spacing: 4) {
                                Image(systemName: "flame.fill")
                                    .foregroundColor(FireColors.accentGold)
                                    .font(.caption)
                                
                                Text("\(dataManager.habits.filter { $0.isCompletedToday }.count)/\(dataManager.habits.count)")
                                    .fireCaptionStyle()
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(FireColors.primaryDark.opacity(0.5))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(FireColors.accentGold.opacity(0.3), lineWidth: 1)
                                    )
                            )
                        }
                        
                        
                        if !dataManager.habits.isEmpty {
                            HStack(spacing: 4) {
                                ForEach(dataManager.habits.indices, id: \.self) { index in
                                    let habit = dataManager.habits[index]
                                    Circle()
                                        .fill(habit.isCompletedToday ? FireColors.accentGold : FireColors.secondaryText.opacity(0.3))
                                        .frame(width: 12, height: 12)
                                        .fireGlow(intensity: habit.isCompletedToday ? 0.5 : 0)
                                }
                            }
                        }
                    }
                    .fireScreenPadding()
                    
                    
                    if dataManager.habits.isEmpty {
                        EmptyStateView()
                    } else {
                        HabitListView(selectedHabit: $selectedHabit)
                    }
                }
                
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        
                        FireButton("+", style: .round, icon: "plus") {
                            showingAddHabit = true
                        }
                        .frame(width: FireSpacing.fabSize, height: FireSpacing.fabSize)
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
            AddHabitView()
        }
        .sheet(item: $selectedHabit) { habit in
            HabitDetailView(habit: habit)
        }
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: FireSpacing.xl) {
            Spacer()
            
            VStack(spacing: FireSpacing.lg) {
                Image(systemName: "flame")
                    .font(.system(size: 60, weight: .light))
                    .foregroundColor(FireColors.secondaryText)
                
                VStack(spacing: FireSpacing.sm) {
                    Text("No Habits Yet")
                        .fireHeadingStyle()
                    
                    Text("Tap the + button to create your first habit and start your journey")
                        .fireBodyStyle()
                        .multilineTextAlignment(.center)
                }
            }
            
            Spacer()
        }
        .fireScreenPadding()
    }
}

struct HabitListView: View {
    @EnvironmentObject var dataManager: DataManager
    @Binding var selectedHabit: Habit?
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: FireSpacing.md) {
                ForEach(dataManager.habits) { habit in
                    HabitCardView(habit: habit) {
                        selectedHabit = habit
                    }
                }
            }
            .fireScreenPadding()
            .padding(.bottom, 80) 
        }
    }
}

struct HabitCardView: View {
    let habit: Habit
    let onTap: () -> Void
    
    @EnvironmentObject var dataManager: DataManager
    @State private var showFireAnimation = false
    
    var body: some View {
        Button(action: onTap) {
            FireCard(glowEffect: habit.isCompletedToday) {
                HStack(spacing: FireSpacing.md) {
                    
                    Image(systemName: habit.icon)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(FireColors.accentGold)
                        .frame(width: 40, height: 40)
                    
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(habit.title)
                            .fireHeadingStyle()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack(spacing: FireSpacing.sm) {
                            
                            HStack(spacing: 2) {
                                Image(systemName: "flame.fill")
                                    .font(.caption2)
                                    .foregroundColor(FireColors.primaryLight)
                                
                                Text("\(habit.currentStreak) day streak")
                                    .fireCaptionStyle()
                            }
                            
                            Spacer()
                            
                            
                            Text("\(habit.weeklyCompletions)/7 this week")
                                .fireCaptionStyle()
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
                            .fireGlow(intensity: habit.isCompletedToday ? 1.0 : 0)
                            .scaleEffect(showFireAnimation ? 1.3 : 1.0)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let dataManager = DataManager.shared
        dataManager.habits = Habit.sampleHabits
        
        return HomeView()
            .environmentObject(dataManager)
    }
}