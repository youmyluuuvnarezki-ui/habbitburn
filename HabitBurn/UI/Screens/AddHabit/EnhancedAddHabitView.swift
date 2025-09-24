import SwiftUI

struct EnhancedAddHabitView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var habitName = ""
    @State private var selectedIcon = "flame.fill"
    @State private var selectedCategory: HabitCategory = .personal
    @State private var selectedDifficulty: HabitDifficulty = .medium
    @State private var selectedFrequency: HabitFrequency = .daily
    @State private var reminderEnabled = false
    @State private var reminderTime = Date()
    @State private var notes = ""
    @State private var selectedGoals: [HabitGoal] = []
    
    @FocusState private var isNameFieldFocused: Bool
    
    private let availableIcons = [
        "flame.fill", "book.fill", "drop.fill", "figure.run", "leaf.fill",
        "pencil", "music.note", "moon.fill", "sun.max.fill", "heart.fill",
        "star.fill", "apple.logo", "cup.and.saucer.fill", "camera.fill", "gamecontroller.fill",
        "dumbbell.fill", "brain.head.profile", "paintbrush.fill", "person.2.fill", "briefcase.fill"
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: FireSpacing.lg) {
                        
                        VStack(spacing: FireSpacing.sm) {
                            Text("Create New Habit")
                                .fireDisplayStyle()
                            
                            Text("Build your perfect habit with detailed customization")
                                .fireBodyStyle()
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, FireSpacing.lg)
                        
                        VStack(spacing: FireSpacing.xl) {
                            
                            VStack(spacing: FireSpacing.md) {
                                SectionHeader(title: "Basic Information", icon: "info.circle.fill")
                                
                                VStack(spacing: FireSpacing.md) {
                                    FireTextField("Habit Name", text: $habitName, placeholder: "Enter habit name")
                                        .focused($isNameFieldFocused)
                                    
                                    IconSelectionSection(selectedIcon: $selectedIcon, icons: availableIcons)
                                }
                            }
                            
                            
                            VStack(spacing: FireSpacing.md) {
                                SectionHeader(title: "Category & Difficulty", icon: "tag.circle.fill")
                                
                                VStack(spacing: FireSpacing.md) {
                                    CategorySelectionView(selectedCategory: $selectedCategory)
                                    DifficultySelectionView(selectedDifficulty: $selectedDifficulty)
                                    FrequencySelectionView(selectedFrequency: $selectedFrequency)
                                }
                            }
                            
                            
                            VStack(spacing: FireSpacing.md) {
                                SectionHeader(title: "Goals & Motivation", icon: "target")
                                
                                GoalSelectionView(selectedGoals: $selectedGoals)
                            }
                            
                            
                            VStack(spacing: FireSpacing.md) {
                                SectionHeader(title: "Reminders", icon: "bell.circle.fill")
                                
                                ReminderSettingsView(reminderEnabled: $reminderEnabled, reminderTime: $reminderTime)
                            }
                            
                            
                            VStack(spacing: FireSpacing.md) {
                                SectionHeader(title: "Notes", icon: "note.text")
                                
                                FireTextField("Notes (optional)", text: $notes, placeholder: "Add any notes or motivation...")
                            }
                            
                            
                            if !habitName.isEmpty {
                                VStack(spacing: FireSpacing.sm) {
                                    SectionHeader(title: "Preview", icon: "eye.circle.fill")
                                    
                                    HabitPreviewCard(
                                        name: habitName,
                                        icon: selectedIcon,
                                        category: selectedCategory,
                                        difficulty: selectedDifficulty,
                                        frequency: selectedFrequency,
                                        reminderEnabled: reminderEnabled,
                                        reminderTime: reminderEnabled ? reminderTime : nil,
                                        goals: selectedGoals,
                                        notes: notes
                                    )
                                }
                            }
                        }
                        
                        Spacer()
                    }
                    .fireScreenPadding()
                    .padding(.bottom, 120)
                }
                .background(BackgroundImageView("ModalBackground"))
                
                VStack {
                    Spacer()
                    
                    HStack(spacing: FireSpacing.md) {
                        FireButton("CANCEL", style: .secondary, minHeight: FireSpacing.minTouchTarget * 0.7) {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .frame(maxWidth: .infinity)
                        
                        FireButton("CREATE HABIT", style: .primary, icon: "plus.circle.fill", minHeight: FireSpacing.minTouchTarget * 0.7) {
                            createHabit()
                        }
                        .frame(maxWidth: .infinity)
                        .disabled(habitName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                    .fireScreenPadding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(FireColors.primaryDark.opacity(0.9))
                            .blur(radius: 10)
                    )
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isNameFieldFocused = true
            }
        }
    }
    
    private func createHabit() {
        let trimmedName = habitName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }
        
        var newHabit = Habit(
            title: trimmedName,
            icon: selectedIcon,
            category: selectedCategory,
            difficulty: selectedDifficulty,
            frequency: selectedFrequency
        )
        
        newHabit.reminderTime = reminderEnabled ? reminderTime : nil
        newHabit.notes = notes
        newHabit.goals = selectedGoals
        
        dataManager.addHabit(newHabit)
        presentationMode.wrappedValue.dismiss()
    }
}

struct SectionHeader: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack(spacing: FireSpacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(FireColors.accentGold)
            
            Text(title)
                .fireHeadingStyle()
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct IconSelectionSection: View {
    @Binding var selectedIcon: String
    let icons: [String]
    
    var body: some View {
        VStack(spacing: FireSpacing.sm) {
            HStack {
                Text("Choose Icon")
                    .fireBodyStyle()
                
                Spacer()
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: FireSpacing.sm), count: 5), spacing: FireSpacing.sm) {
                ForEach(icons, id: \.self) { icon in
                    IconSelectionButton(
                        icon: icon,
                        isSelected: selectedIcon == icon,
                        onTap: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedIcon = icon
                            }
                        }
                    )
                }
            }
        }
    }
}

struct CategorySelectionView: View {
    @Binding var selectedCategory: HabitCategory
    
    var body: some View {
        VStack(spacing: FireSpacing.sm) {
            HStack {
                Text("Category")
                    .fireBodyStyle()
                
                Spacer()
            }
            
            LazyVGrid(columns: [
                GridItem(.flexible(minimum: 0, maximum: .infinity), spacing: FireSpacing.sm),
                GridItem(.flexible(minimum: 0, maximum: .infinity), spacing: FireSpacing.sm)
            ], spacing: FireSpacing.sm) {
                ForEach(HabitCategory.allCases, id: \.self) { category in
                    CategoryButton(
                        category: category,
                        isSelected: selectedCategory == category,
                        onTap: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedCategory = category
                            }
                        }
                    )
                }
            }
        }
    }
}

struct CategoryButton: View {
    let category: HabitCategory
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: FireSpacing.xs) {
                Image(systemName: category.icon)
                    .font(.system(size: 14, weight: .bold))
                
                Text(category.rawValue)
                    .font(FireFonts.caption(10))
                    .font(.system(size: 10, weight: .semibold))
            }
            .foregroundColor(isSelected ? FireColors.primaryText : FireColors.secondaryText)
            .padding(.horizontal, FireSpacing.lg)
            .padding(.vertical, FireSpacing.xs)
            .frame(maxWidth: .infinity, alignment: .center)
            .background(
                Group {
                    if isSelected {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(category.gradient)
                    } else {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(FireColors.primaryDark.opacity(0.3))
                    }
                }
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(
                                isSelected ? category.color : FireColors.secondaryText.opacity(0.3),
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

struct DifficultySelectionView: View {
    @Binding var selectedDifficulty: HabitDifficulty
    
    var body: some View {
        VStack(spacing: FireSpacing.sm) {
            HStack {
                Text("Difficulty Level")
                    .fireBodyStyle()
                
                Spacer()
                
                Text("+\(selectedDifficulty.experiencePoints) XP")
                    .fireCaptionStyle()
                    .foregroundColor(FireColors.accentGold)
            }
            
            HStack(spacing: FireSpacing.sm) {
                ForEach(HabitDifficulty.allCases, id: \.self) { difficulty in
                    DifficultyButton(
                        difficulty: difficulty,
                        isSelected: selectedDifficulty == difficulty,
                        onTap: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedDifficulty = difficulty
                            }
                        }
                    )
                }
            }
        }
    }
}

struct DifficultyButton: View {
    let difficulty: HabitDifficulty
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                Image(systemName: difficulty.icon)
                    .font(.system(size: 18, weight: .bold))
                
                Text(difficulty.rawValue)
                    .font(.system(size: 10, weight: .semibold))
                
                Text(difficulty.description)
                    .font(FireFonts.caption(8))
                    .multilineTextAlignment(.center)
            }
            .foregroundColor(isSelected ? FireColors.primaryText : FireColors.secondaryText)
            .frame(maxWidth: .infinity)
            .padding(.vertical, FireSpacing.sm)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? difficulty.color.opacity(0.2) : FireColors.primaryDark.opacity(0.3))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(
                                isSelected ? difficulty.color : FireColors.secondaryText.opacity(0.3),
                                lineWidth: isSelected ? 2 : 1
                            )
                    )
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct FrequencySelectionView: View {
    @Binding var selectedFrequency: HabitFrequency
    
    var body: some View {
        VStack(spacing: FireSpacing.sm) {
            HStack {
                Text("Frequency")
                    .fireBodyStyle()
                
                Spacer()
            }
            
            VStack(spacing: FireSpacing.xs) {
                ForEach(HabitFrequency.allCases, id: \.self) { frequency in
                    FrequencyButton(
                        frequency: frequency,
                        isSelected: selectedFrequency == frequency,
                        onTap: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedFrequency = frequency
                            }
                        }
                    )
                }
            }
        }
    }
}

struct FrequencyButton: View {
    let frequency: HabitFrequency
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: FireSpacing.sm) {
                Text(frequency.rawValue)
                    .font(.system(size: 16, weight: isSelected ? .bold : .regular))
                    .foregroundColor(FireColors.primaryText)
                
                Spacer()
                
                Text(frequency.description)
                    .fireCaptionStyle()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(FireColors.accentGold)
                }
            }
            .padding(.horizontal, FireSpacing.sm)
            .padding(.vertical, FireSpacing.xs)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? FireColors.accentGold.opacity(0.1) : Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(
                                isSelected ? FireColors.accentGold : FireColors.secondaryText.opacity(0.3),
                                lineWidth: isSelected ? 1 : 0.5
                            )
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct GoalSelectionView: View {
    @Binding var selectedGoals: [HabitGoal]
    
    private let predefinedGoals = [
        HabitGoal(title: "7-day streak", targetStreak: 7),
        HabitGoal(title: "30-day streak", targetStreak: 30),
        HabitGoal(title: "100-day streak", targetStreak: 100)
    ]
    
    var body: some View {
        VStack(spacing: FireSpacing.sm) {
            HStack {
                Text("Set Goals")
                    .fireBodyStyle()
                
                Spacer()
                
                Text("Optional")
                    .fireCaptionStyle()
                    .foregroundColor(FireColors.secondaryText)
            }
            
            VStack(spacing: FireSpacing.xs) {
                ForEach(predefinedGoals, id: \.id) { goal in
                    GoalToggleButton(
                        goal: goal,
                        isSelected: selectedGoals.contains { $0.targetStreak == goal.targetStreak },
                        onToggle: { toggleGoal(goal) }
                    )
                }
            }
        }
    }
    
    private func toggleGoal(_ goal: HabitGoal) {
        if let index = selectedGoals.firstIndex(where: { $0.targetStreak == goal.targetStreak }) {
            selectedGoals.remove(at: index)
        } else {
            selectedGoals.append(goal)
        }
    }
}

struct GoalToggleButton: View {
    let goal: HabitGoal
    let isSelected: Bool
    let onToggle: () -> Void
    
    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: FireSpacing.sm) {
                Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                    .foregroundColor(isSelected ? FireColors.accentGold : FireColors.secondaryText)
                
                Text(goal.title)
                    .fireBodyStyle()
                
                Spacer()
                
                Text("\(goal.targetStreak) days")
                    .fireCaptionStyle()
            }
            .padding(.horizontal, FireSpacing.sm)
            .padding(.vertical, FireSpacing.xs)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(isSelected ? FireColors.accentGold.opacity(0.1) : Color.clear)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ReminderSettingsView: View {
    @Binding var reminderEnabled: Bool
    @Binding var reminderTime: Date
    
    var body: some View {
        VStack(spacing: FireSpacing.sm) {
            HStack {
                Text("Daily Reminder")
                    .fireBodyStyle()
                
                Spacer()
                
                Toggle("", isOn: $reminderEnabled)
                    .toggleStyle(FireToggleStyle())
            }
            
            if reminderEnabled {
                DatePicker("Reminder Time", selection: $reminderTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.wheel)
                    .frame(height: 120)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(FireColors.primaryDark.opacity(0.3))
                    )
            }
        }
    }
}

struct HabitPreviewCard: View {
    let name: String
    let icon: String
    let category: HabitCategory
    let difficulty: HabitDifficulty
    let frequency: HabitFrequency
    let reminderEnabled: Bool
    let reminderTime: Date?
    let goals: [HabitGoal]
    let notes: String
    
    var body: some View {
        FireCard {
            VStack(alignment: .leading, spacing: FireSpacing.md) {
                
                HStack(spacing: FireSpacing.md) {
                    Image(systemName: icon)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(category.color)
                        .frame(width: 40, height: 40)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(name)
                            .fireHeadingStyle()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack(spacing: FireSpacing.sm) {
                            Text(category.rawValue)
                                .font(FireFonts.caption(10))
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(category.color.opacity(0.2))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 4)
                                                .stroke(category.color, lineWidth: 1)
                                        )
                                )
                                .foregroundColor(category.color)
                            
                            HStack(spacing: 2) {
                                Image(systemName: difficulty.icon)
                                    .font(.caption2)
                                Text(difficulty.rawValue)
                                    .font(FireFonts.caption(10))
                            }
                            .foregroundColor(difficulty.color)
                            
                            Spacer()
                            
                            Text(frequency.rawValue)
                                .fireCaptionStyle()
                        }
                    }
                }
                
                
                LazyVGrid(columns: [
                    GridItem(.flexible(minimum: 0, maximum: .infinity)),
                    GridItem(.flexible(minimum: 0, maximum: .infinity))
                ], spacing: FireSpacing.sm) {
                    
                    HStack(spacing: FireSpacing.xs) {
                        Image(systemName: "bell.fill")
                            .font(.caption)
                            .foregroundColor(reminderEnabled ? FireColors.accentGold : FireColors.secondaryText)
                        Text(reminderEnabled ? (formattedTime(reminderTime)) : "No reminder")
                            .fireCaptionStyle()
                    }
                    
                    
                    HStack(spacing: FireSpacing.xs) {
                        Image(systemName: "target")
                            .font(.caption)
                            .foregroundColor(FireColors.accentGold)
                        Text(goals.isEmpty ? "No goals" : "Goals: \(goals.map{ "\($0.targetStreak)d" }.joined(separator: ", "))")
                            .fireCaptionStyle()
                    }
                }
                
                
                if !notes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Notes")
                            .fireCaptionStyle()
                        Text(notes)
                            .fireBodyStyle()
                    }
                }
            }
        }
    }
    
    private func formattedTime(_ date: Date?) -> String {
        guard let date = date else { return "" }
        let f = DateFormatter()
        f.timeStyle = .short
        return f.string(from: date)
    }
}

struct EnhancedAddHabitView_Previews: PreviewProvider {
    static var previews: some View {
        EnhancedAddHabitView()
            .environmentObject(DataManager.shared)
    }
}