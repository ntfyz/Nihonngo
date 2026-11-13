import SwiftUI

@main
struct MinnaDichApp: App {
    @ObservedObject private var settings = SettingsViewModel.shared
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .preferredColorScheme(settings.themePreference.colorScheme)
        }
    }
}
