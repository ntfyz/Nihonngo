import SwiftUI
import Combine

public enum AppThemePreference: String, CaseIterable, Identifiable {
    case system = "system"
    case light = "light"
    case dark = "dark"
    
    public var id: String { rawValue }
    
    public var displayName: String {
        switch self {
        case .system: return "Hệ thống"
        case .light: return "Sáng (Light)"
        case .dark: return "Tối (Dark)"
        }
    }
    
    public var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}

public enum FontSizeOption: Double, CaseIterable, Identifiable {
    case small = 0.9
    case standard = 1.0
    case large = 1.15
    case extraLarge = 1.3
    
    public var id: Double { rawValue }
    
    public var displayName: String {
        switch self {
        case .small: return "Nhỏ"
        case .standard: return "Tiêu chuẩn"
        case .large: return "Lớn"
        case .extraLarge: return "Rất lớn"
        }
    }
}

public final class SettingsViewModel: ObservableObject {
    public static let shared = SettingsViewModel()
    
    @AppStorage("setting_show_romaji") public var showRomaji: Bool = true
    @AppStorage("setting_app_theme") public var themePreference: AppThemePreference = .system
    @AppStorage("setting_font_size") public var fontSizeScale: Double = 1.0
    
    @Published public var showResetConfirmAlert: Bool = false
    @Published public var resetSuccessToast: Bool = false
    
    public var appVersionString: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "Phiên bản \(version) (Build \(build))"
    }
    
    public func resetAllProgress() {
        ProgressStore.shared.resetAllProgress()
        resetSuccessToast = true
    }
}
