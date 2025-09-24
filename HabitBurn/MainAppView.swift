import SwiftUI

struct MainAppView: View {
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        Group {
            if dataManager.onboardingCompleted {
                MainTabView()
            } else {
                OnboardingView()
            }
        }
        .background(BackgroundImageView("MainBackground"))
    }
}

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            EnhancedHomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            StatsView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Stats")
                }
                .tag(1)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
                .tag(2)
        }
        .accentColor(FireColors.accentGold)
        .background(BackgroundImageView("MainBackground"))
    }
}

struct MainAppView_Previews: PreviewProvider {
    static var previews: some View {
        MainAppView()
            .environmentObject(DataManager.shared)
    }
}