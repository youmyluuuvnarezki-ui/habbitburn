import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var currentPage = 0
    @State private var userName = ""
    
    private let pages = 4
    
    var body: some View {
        VStack(spacing: 0) {
            
            TabView(selection: $currentPage) {
                WelcomePageView()
                    .tag(0)
                
                AddHabitPageView()
                    .tag(1)
                
                StayMotivatedPageView()
                    .tag(2)
                
                EnterNamePageView(userName: $userName)
                    .tag(3)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut, value: currentPage)
            
            
            HStack(spacing: 8) {
                ForEach(0..<pages, id: \.self) { index in
                    Circle()
                        .fill(index == currentPage ? FireColors.accentGold : FireColors.secondaryText)
                        .frame(width: 8, height: 8)
                        .scaleEffect(index == currentPage ? 1.2 : 1.0)
                        .animation(.easeInOut(duration: 0.3), value: currentPage)
                }
            }
            .padding(.top, FireSpacing.lg)
            
            
            HStack(spacing: FireSpacing.md) {
                if currentPage > 0 && currentPage < pages - 1 {
                    FireButton("SKIP", style: .secondary, minHeight: FireSpacing.minTouchTarget * 0.7) {
                        skipOnboarding()
                    }
                }
                
                Spacer()
                
                if currentPage < pages - 1 {
                    FireButton("NEXT", style: .primary, icon: "arrow.right", minHeight: FireSpacing.minTouchTarget * 0.7) {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            currentPage += 1
                        }
                    }
                } else {
                    FireButton("CONTINUE", style: .primary, icon: "flame.fill", minHeight: FireSpacing.minTouchTarget * 0.7) {
                        completeOnboarding()
                    }
                    .disabled(userName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .fireScreenPadding()
        }
        .background(
            Image("OnboardingBackground")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea(.all)
        )
    }
    
    private func skipOnboarding() {
        withAnimation(.easeInOut(duration: 0.8)) {
            currentPage = pages - 1
        }
    }
    
    private func completeOnboarding() {
        let trimmedName = userName.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedName.isEmpty {
            dataManager.updateUserName(trimmedName)
        }
        
        withAnimation(.easeInOut(duration: 0.8)) {
            dataManager.completeOnboarding()
        }
    }
}



struct WelcomePageView: View {
    var body: some View {
        VStack(spacing: FireSpacing.xl) {
            Spacer()
            
            VStack(spacing: FireSpacing.lg) {
                
                Image(systemName: "flame.fill")
                    .font(.system(size: 80, weight: .bold))
                    .foregroundColor(FireColors.primaryLight)
                    .fireGlow(intensity: 1.5)
                    .pulseAnimation()
                
                VStack(spacing: FireSpacing.md) {
                    Text("Welcome to HabitBurn")
                        .fireDisplayStyle()
                        .multilineTextAlignment(.center)
                        .slideUpEnter()
                    
                    Text("Track your habits with fire power")
                        .fireBodyStyle()
                        .multilineTextAlignment(.center)
                        .slideUpEnter(delay: 0.3)
                }
            }
            
            Spacer()
        }
        .fireScreenPadding()
    }
}

struct AddHabitPageView: View {
    var body: some View {
        VStack(spacing: FireSpacing.xl) {
            Spacer()
            
            VStack(spacing: FireSpacing.lg) {
                
                FireCard(glowEffect: true) {
                    HStack(spacing: FireSpacing.md) {
                        Image(systemName: "book.fill")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(FireColors.accentGold)
                            .flameIcon()
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Read Books")
                                .fireHeadingStyle()
                            Text("Daily reading habit")
                                .fireCaptionStyle()
                        }
                        
                        Spacer()
                        
                        Image(systemName: "flame.fill")
                            .font(.system(size: 24))
                            .foregroundColor(FireColors.primaryLight)
                            .pulseAnimation()
                    }
                }
                .slideUpEnter()
                
                VStack(spacing: FireSpacing.md) {
                    Text("Add Your First Habit")
                        .fireDisplayStyle()
                        .multilineTextAlignment(.center)
                        .slideUpEnter(delay: 0.3)
                    
                    Text("Create up to 7 habits and track your progress with our fiery interface")
                        .fireBodyStyle()
                        .multilineTextAlignment(.center)
                        .slideUpEnter(delay: 0.5)
                }
            }
            
            Spacer()
        }
        .fireScreenPadding()
    }
}

struct StayMotivatedPageView: View {
    var body: some View {
        VStack(spacing: FireSpacing.xl) {
            Spacer()
            
            VStack(spacing: FireSpacing.lg) {
                
                VStack(spacing: FireSpacing.md) {
                    HStack {
                        ForEach(0..<7, id: \.self) { index in
                            Circle()
                                .fill(index < 5 ? FireColors.accentGold : FireColors.secondaryText.opacity(0.3))
                                .frame(width: 20, height: 20)
                                .overlay(
                                    Circle()
                                        .stroke(FireColors.accentGold, lineWidth: index < 5 ? 2 : 1)
                                )
                                .fireGlow(intensity: index < 5 ? 0.5 : 0)
                        }
                    }
                    .slideUpEnter()
                    
                    Text("5/7 days this week")
                        .fireCaptionStyle()
                        .slideUpEnter(delay: 0.2)
                }
                
                VStack(spacing: FireSpacing.md) {
                    Text("Stay Motivated")
                        .fireDisplayStyle()
                        .multilineTextAlignment(.center)
                        .slideUpEnter(delay: 0.4)
                    
                    Text("Track your progress with beautiful charts and maintain your streak")
                        .fireBodyStyle()
                        .multilineTextAlignment(.center)
                        .slideUpEnter(delay: 0.6)
                }
            }
            
            Spacer()
        }
        .fireScreenPadding()
    }
}

struct EnterNamePageView: View {
    @Binding var userName: String
    @FocusState private var isNameFieldFocused: Bool
    
    var body: some View {
        VStack(spacing: FireSpacing.xl) {
            Spacer()
            
            VStack(spacing: FireSpacing.lg) {
                
                Image(systemName: "person.fill.badge.plus")
                    .font(.system(size: 60, weight: .bold))
                    .foregroundColor(FireColors.accentGold)
                    .fireGlow()
                    .slideUpEnter()
                
                VStack(spacing: FireSpacing.md) {
                    Text("What's your name?")
                        .fireDisplayStyle()
                        .multilineTextAlignment(.center)
                        .slideUpEnter(delay: 0.2)
                    
                    Text("We'd love to personalize your experience")
                        .fireBodyStyle()
                        .multilineTextAlignment(.center)
                        .slideUpEnter(delay: 0.4)
                }
                
                FireTextField("Your Name", text: $userName, placeholder: "Enter your name")
                    .focused($isNameFieldFocused)
                    .slideUpEnter(delay: 0.6)
            }
            
            Spacer()
        }
        .fireScreenPadding()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                isNameFieldFocused = true
            }
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .environmentObject(DataManager.shared)
    }
}