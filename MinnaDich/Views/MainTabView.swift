import SwiftUI

public struct MainTabView: View {
    @State private var selectedTab: Int = 0
    
    public init() {}
    
    public var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Bài học", systemImage: "book.fill")
                }
                .tag(0)
            
            ReviewView()
                .tabItem {
                    Label("Ôn tập", systemImage: "arrow.triangle.2.circlepath")
                }
                .tag(1)
            
            SettingsView()
                .tabItem {
                    Label("Cài đặt", systemImage: "gearshape.fill")
                }
                .tag(2)
        }
    }
}
