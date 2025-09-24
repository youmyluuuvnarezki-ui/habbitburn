import SwiftUI

struct HelpView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: FireSpacing.lg) {
                Text("How to use HabitBurn")
                    .fireDisplayStyle()
                
                VStack(alignment: .leading, spacing: FireSpacing.md) {
                    Text("1. Complete Onboarding")
                        .fireHeadingStyle()
                    Text("Enter your name to personalize the app and finish the onboarding.")
                        .fireBodyStyle()
                    
                    Text("2. Create Habits")
                        .fireHeadingStyle()
                    Text("Tap the + button to add up to 7 habits. Choose icon, category, difficulty, frequency, and optional reminder.")
                        .fireBodyStyle()
                    
                    Text("3. Track Daily")
                        .fireHeadingStyle()
                    Text("Tap the flame icon to mark habits complete. Maintain streaks and earn experience.")
                        .fireBodyStyle()
                    
                    Text("4. Explore Stats & Achievements")
                        .fireHeadingStyle()
                    Text("View your weekly progress, streaks, and unlock achievements as you improve.")
                        .fireBodyStyle()
                }
                
                Spacer()
                
                FireButton("CLOSE", style: .secondary, minHeight: FireSpacing.minTouchTarget * 0.7) {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .fireScreenPadding()
            .background(BackgroundImageView("ModalBackground"))
            .navigationBarHidden(true)
        }
    }
}

struct AboutView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: FireSpacing.lg) {
                Text("About HabitBurn")
                    .fireDisplayStyle()
                
                VStack(alignment: .leading, spacing: FireSpacing.md) {
                    Text("Version")
                        .fireHeadingStyle()
                    Text("1.0.0")
                        .fireBodyStyle()
                    
                    Text("Design System")
                        .fireHeadingStyle()
                    Text("Fire-themed UI with gradients, animations, and accessible sizes.")
                        .fireBodyStyle()
                    
                    Text("Privacy")
                        .fireHeadingStyle()
                    Text("All data is stored locally on your device.")
                        .fireBodyStyle()
                }
                
                Spacer()
                
                FireButton("CLOSE", style: .secondary, minHeight: FireSpacing.minTouchTarget * 0.7) {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .fireScreenPadding()
            .background(BackgroundImageView("ModalBackground"))
            .navigationBarHidden(true)
        }
    }
}


