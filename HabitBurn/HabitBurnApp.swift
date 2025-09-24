






import SwiftUI

@main
struct HabitBurnApp: App {
    @StateObject private var dataManager = DataManager.shared
    
    var body: some Scene {
        WindowGroup {
            MainAppView()
                .environmentObject(dataManager)
                .preferredColorScheme(.dark)
        }
    }
}
