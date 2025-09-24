import SwiftUI

struct AddHabitView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var habitName = ""
    @State private var selectedIcon = "flame.fill"
    @FocusState private var isNameFieldFocused: Bool
    
    private let availableIcons = [
        "flame.fill", "book.fill", "drop.fill", "figure.run", "leaf.fill",
        "pencil", "music.note", "moon.fill", "sun.max.fill", "heart.fill",
        "star.fill", "apple.logo", "cup.and.saucer.fill", "camera.fill", "gamecontroller.fill"
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: FireSpacing.lg) {
                    
                    VStack(spacing: FireSpacing.sm) {
                        Text("Add New Habit")
                            .fireDisplayStyle()
                            .slideUpEnter()
                        
                        Text("Create a new habit to track")
                            .fireBodyStyle()
                            .slideUpEnter(delay: 0.2)
                    }
                    .padding(.top, FireSpacing.lg)
                    
                    
                    VStack(spacing: FireSpacing.xl) {
                        
                        VStack(spacing: FireSpacing.sm) {
                            Text("Habit Name")
                                .fireHeadingStyle()
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            FireTextField("", text: $habitName, placeholder: "Enter habit name")
                                .focused($isNameFieldFocused)
                        }
                        .slideUpEnter(delay: 0.4)
                        
                        
                        VStack(spacing: FireSpacing.md) {
                            Text("Choose Icon")
                                .fireHeadingStyle()
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: FireSpacing.sm), count: 5), spacing: FireSpacing.sm) {
                                ForEach(availableIcons, id: \.self) { icon in
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
                        .slideUpEnter(delay: 0.6)
                        
                        Spacer()
                        
                        
                        if !habitName.isEmpty {
                            VStack(spacing: FireSpacing.sm) {
                                Text("Preview")
                                    .fireHeadingStyle()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                FireCard {
                                    HStack(spacing: FireSpacing.md) {
                                        Image(systemName: selectedIcon)
                                            .font(.system(size: 28, weight: .bold))
                                            .foregroundColor(FireColors.accentGold)
                                            .frame(width: 40, height: 40)
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(habitName)
                                                .fireHeadingStyle()
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            
                                            Text("New habit")
                                                .fireCaptionStyle()
                                        }
                                        
                                        Spacer()
                                        
                                        Image(systemName: "flame")
                                            .font(.system(size: 24))
                                            .foregroundColor(FireColors.primaryLight)
                                    }
                                }
                                .pulseAnimation(duration: 2.0)
                            }
                            .slideUpEnter(delay: 0.8)
                        }
                    }
                    .fireScreenPadding()
                    
                    Spacer()
                    
                    
                    HStack(spacing: FireSpacing.md) {
                        FireButton("CANCEL", style: .secondary) {
                            presentationMode.wrappedValue.dismiss()
                        }
                        
                        FireButton("SAVE HABIT", style: .primary, icon: "plus.circle.fill") {
                            saveHabit()
                        }
                        .disabled(habitName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                    .fireScreenPadding()
                }
                .background(BackgroundImageView("ModalBackground"))
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isNameFieldFocused = true
            }
        }
    }
    
    private func saveHabit() {
        let trimmedName = habitName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }
        
        let newHabit = Habit(title: trimmedName, icon: selectedIcon)
        dataManager.addHabit(newHabit)
        
        presentationMode.wrappedValue.dismiss()
    }
}

struct IconSelectionButton: View {
    let icon: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(isSelected ? FireColors.primaryText : FireColors.secondaryText)
                .frame(width: 50, height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isSelected ? FireColors.accentGold.opacity(0.2) : FireColors.primaryDark.opacity(0.3))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    isSelected ? FireColors.accentGold : FireColors.secondaryText.opacity(0.3),
                                    lineWidth: isSelected ? 2 : 1
                                )
                        )
                )
                .fireGlow(intensity: isSelected ? 0.3 : 0)
                .scaleEffect(isSelected ? 1.05 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct AddHabitView_Previews: PreviewProvider {
    static var previews: some View {
        AddHabitView()
            .environmentObject(DataManager.shared)
    }
}