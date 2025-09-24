import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showingResetAlert = false
    @State private var showingNameEditor = false
    @State private var tempUserName = ""
    @State private var showingHelp = false
    @State private var showingAbout = false
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: FireSpacing.xl) {
                        
                        VStack(spacing: FireSpacing.sm) {
                            Text("Settings")
                                .fireDisplayStyle()
                                .slideUpEnter()
                            
                            Text("Customize your experience")
                                .fireBodyStyle()
                                .slideUpEnter(delay: 0.2)
                        }
                        .padding(.top, FireSpacing.lg)
                        
                        VStack(spacing: FireSpacing.lg) {
                            
                            VStack(spacing: FireSpacing.md) {
                                Text("Profile")
                                    .fireHeadingStyle()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                FireCard {
                                    HStack(spacing: FireSpacing.md) {
                                        
                                        Image(systemName: "person.crop.circle.fill")
                                            .font(.system(size: 50))
                                            .foregroundColor(FireColors.accentGold)
                                            .fireGlow(intensity: 0.5)
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(dataManager.user.name.isEmpty ? "Anonymous" : dataManager.user.name)
                                                .fireHeadingStyle()
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            
                                            Text("Member since \(formatDate(dataManager.user.createdAt))")
                                                .fireCaptionStyle()
                                        }
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            tempUserName = dataManager.user.name
                                            showingNameEditor = true
                                        }) {
                                            Image(systemName: "pencil")
                                                .font(.system(size: 16, weight: .bold))
                                                .foregroundColor(FireColors.accentGold)
                                                .frame(width: 30, height: 30)
                                        }
                                    }
                                }
                            }
                            .slideUpEnter(delay: 0.4)
                            
                            
                            VStack(spacing: FireSpacing.md) {
                                Text("App Settings")
                                    .fireHeadingStyle()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                VStack(spacing: FireSpacing.sm) {
                                    SettingsToggleRow(
                                        title: "Notifications",
                                        subtitle: "Daily habit reminders",
                                        isOn: Binding(
                                            get: { dataManager.settings.notificationsEnabled },
                                            set: { dataManager.updateNotificationSettings($0) }
                                        )
                                    )
                                }
                            }
                            .slideUpEnter(delay: 0.6)
                            
                            
                            VStack(spacing: FireSpacing.md) {
                                Text("Statistics")
                                    .fireHeadingStyle()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                let stats = dataManager.getOverallStats()
                                
                                VStack(spacing: FireSpacing.sm) {
                                    SettingsInfoRow(
                                        title: "Total Habits",
                                        value: "\(stats.totalHabits)"
                                    )
                                    
                                    SettingsInfoRow(
                                        title: "Completed Today",
                                        value: "\(stats.completedToday)"
                                    )
                                    
                                    SettingsInfoRow(
                                        title: "Weekly Average",
                                        value: String(format: "%.0f%%", stats.weeklyAverage * 100)
                                    )
                                }
                            }
                            .slideUpEnter(delay: 0.8)
                            
                            
                            VStack(spacing: FireSpacing.md) {
                                Text("Help & Info")
                                    .fireHeadingStyle()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                VStack(spacing: FireSpacing.sm) {
                                    SettingsActionRow(
                                        title: "How to use HabitBurn",
                                        icon: "questionmark.circle.fill"
                                    ) {
                                        showingHelp = true
                                    }
                                    
                                    SettingsActionRow(
                                        title: "About",
                                        icon: "info.circle.fill"
                                    ) {
                                        showingAbout = true
                                    }
                                }
                            }
                            .slideUpEnter(delay: 1.0)
                            
                            
                            VStack(spacing: FireSpacing.md) {
                                Text("Danger Zone")
                                    .fireHeadingStyle()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                FireButton("RESET ALL DATA", style: .secondary, icon: "trash.fill", minHeight: FireSpacing.minTouchTarget * 0.7) {
                                    showingResetAlert = true
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(FireColors.error)
                            }
                            .slideUpEnter(delay: 1.2)
                        }
                    }
                    .fireScreenPadding()
                }
                .background(BackgroundImageView("MainBackground"))
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingNameEditor) {
            NameEditorView(userName: $tempUserName) {
                dataManager.updateUserName(tempUserName)
            }
        }
        .sheet(isPresented: $showingHelp) {
            HelpView()
        }
        .sheet(isPresented: $showingAbout) {
            AboutView()
        }
        .alert("Reset All Data", isPresented: $showingResetAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Reset Everything", role: .destructive) {
                dataManager.resetAllData()
            }
        } message: {
            Text("Are you sure you want to reset all data? This will delete all habits, statistics, and settings. This action cannot be undone.")
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct SettingsToggleRow: View {
    let title: String
    let subtitle: String
    @Binding var isOn: Bool
    
    var body: some View {
        FireCard {
            HStack(spacing: FireSpacing.md) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .fireHeadingStyle()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(subtitle)
                        .fireCaptionStyle()
                }
                
                Spacer()
                
                Toggle("", isOn: $isOn)
                    .toggleStyle(FireToggleStyle())
            }
        }
    }
}

struct SettingsInfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        FireCard {
            HStack {
                Text(title)
                    .fireBodyStyle()
                
                Spacer()
                
                Text(value)
                    .fireHeadingStyle()
                    .foregroundColor(FireColors.accentGold)
            }
        }
    }
}

struct SettingsActionRow: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            FireCard {
                HStack(spacing: FireSpacing.md) {
                    Image(systemName: icon)
                        .font(.system(size: 20))
                        .foregroundColor(FireColors.accentGold)
                        .frame(width: 24, height: 24)
                    
                    Text(title)
                        .fireBodyStyle()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14))
                        .foregroundColor(FireColors.secondaryText)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct FireToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            
            ZStack {
                if configuration.isOn {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(FireColors.buttonGradient)
                } else {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(FireColors.secondaryText.opacity(0.2))
                }
            }
                .frame(width: 60, height: 32)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            configuration.isOn ? FireColors.accentGold : FireColors.secondaryText.opacity(0.3),
                            lineWidth: configuration.isOn ? 2 : 1
                        )
                )
                .overlay(
                    Circle()
                        .fill(FireColors.primaryText)
                        .frame(width: 24, height: 24)
                        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                        .offset(x: configuration.isOn ? 14 : -14)
                        .animation(.easeInOut(duration: 0.2), value: configuration.isOn)
                )
                .onTapGesture {
                    configuration.isOn.toggle()
                }
                .fireGlow(intensity: configuration.isOn ? 0.3 : 0)
        }
    }
}

struct NameEditorView: View {
    @Binding var userName: String
    let onSave: () -> Void
    @Environment(\.presentationMode) var presentationMode
    @FocusState private var isFieldFocused: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                FireColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: FireSpacing.xl) {
                    Text("Edit Name")
                        .fireDisplayStyle()
                    
                    FireTextField("Your Name", text: $userName, placeholder: "Enter your name")
                        .focused($isFieldFocused)
                    
                    Spacer()
                    
                    HStack(spacing: FireSpacing.md) {
                        FireButton("CANCEL", style: .secondary) {
                            presentationMode.wrappedValue.dismiss()
                        }
                        
                        FireButton("SAVE", style: .primary) {
                            onSave()
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
                .fireScreenPadding()
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            isFieldFocused = true
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        let dataManager = DataManager.shared
        dataManager.habits = Habit.sampleHabits
        
        return SettingsView()
            .environmentObject(dataManager)
    }
}