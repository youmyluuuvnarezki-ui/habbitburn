import SwiftUI

struct AchievementsView: View {
    @ObservedObject var achievementManager: AchievementManager
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 30))
                                .foregroundColor(FireColors.secondaryText)
                        }
                        
                        Spacer()
                        
                        Text("Achievements")
                            .fireDisplayStyle()
                        
                        Spacer()
                        
                        
                        Color.clear
                            .frame(width: 30, height: 30)
                    }
                    .fireScreenPadding()
                    
                    ScrollView {
                        LazyVStack(spacing: FireSpacing.md) {
                            ForEach(achievementManager.achievements) { achievement in
                                AchievementCard(achievement: achievement)
                            }
                        }
                        .fireScreenPadding()
                    }
                }
                .background(BackgroundImageView("MainBackground"))
            }
            .navigationBarHidden(true)
        }
        .background(BackgroundImageView("MainBackground"))
    }
}

struct AchievementCard: View {
    let achievement: Achievement
    
    var body: some View {
        FireCard {
            HStack(spacing: FireSpacing.md) {
                
                Image(systemName: achievement.icon)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(achievement.isUnlocked ? achievement.rarity.color : FireColors.secondaryText)
                    .frame(width: 40, height: 40)
                
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(achievement.title)
                            .fireHeadingStyle()
                            .foregroundColor(achievement.isUnlocked ? FireColors.primaryText : FireColors.secondaryText)
                        
                        Spacer()
                        
                        
                        Text(achievement.rarity.rawValue)
                            .font(.system(size: 10, weight: .bold))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(achievement.rarity.color.opacity(0.2))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(achievement.rarity.color, lineWidth: 1)
                                    )
                            )
                            .foregroundColor(achievement.rarity.color)
                    }
                    
                    Text(achievement.description)
                        .fireCaptionStyle()
                        .foregroundColor(achievement.isUnlocked ? FireColors.secondaryText : FireColors.secondaryText.opacity(0.5))
                    
                    if achievement.isUnlocked, let date = achievement.unlockedDate {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.caption)
                                .foregroundColor(FireColors.success)
                            
                            Text("Unlocked \(formatDate(date))")
                                .font(.system(size: 10))
                                .foregroundColor(FireColors.success)
                        }
                    } else {
                        HStack {
                            Image(systemName: "lock.fill")
                                .font(.caption)
                                .foregroundColor(FireColors.secondaryText.opacity(0.5))
                            
                            Text(achievement.requirement.description)
                                .font(.system(size: 10))
                                .foregroundColor(FireColors.secondaryText.opacity(0.5))
                        }
                    }
                }
            }
        }
        .opacity(achievement.isUnlocked ? 1.0 : 0.6)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}

struct AchievementsView_Previews: PreviewProvider {
    static var previews: some View {
        AchievementsView(achievementManager: AchievementManager())
    }
}