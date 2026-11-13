import SwiftUI

public struct SettingsView: View {
    @ObservedObject private var viewModel = SettingsViewModel.shared
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            Form {
                // Mục Hiển thị
                Section(header: Text("HIỂN THỊ & HỌC TẬP")) {
                    Toggle("Hiện phiên âm Romaji", isOn: $viewModel.showRomaji)
                    
                    Picker("Giao diện", selection: $viewModel.themePreference) {
                        ForEach(AppThemePreference.allCases) { theme in
                            Text(theme.displayName).tag(theme)
                        }
                    }
                    
                    Picker("Cỡ chữ", selection: $viewModel.fontSizeScale) {
                        ForEach(FontSizeOption.allCases) { option in
                            Text(option.displayName).tag(option.rawValue)
                        }
                    }
                }
                
                // Mục Quản lý dữ liệu
                Section(header: Text("DỮ LIỆU & TIẾN ĐỘ")) {
                    Button(role: .destructive) {
                        viewModel.showResetConfirmAlert = true
                    } label: {
                        HStack {
                            Image(systemName: "arrow.counterclockwise")
                            Text("Đặt lại toàn bộ tiến độ")
                        }
                    }
                }
                
                // Mục Thông tin ứng dụng
                Section(header: Text("THÔNG TIN ỨNG DỤNG")) {
                    HStack {
                        Text("Tên ứng dụng")
                        Spacer()
                        Text("Minna Dịch")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Phiên bản")
                        Spacer()
                        Text(viewModel.appVersionString)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Chế độ hoạt động")
                        Spacer()
                        Text("100% Offline")
                            .foregroundColor(.green)
                            .fontWeight(.medium)
                    }
                    
                    HStack {
                        Text("Nội dung")
                        Spacer()
                        Text("Minna no Nihongo 1–25")
                            .foregroundColor(.secondary)
                    }
                }
                
                // Ghi chú bản quyền
                Section(footer: Text("Minna Dịch được thiết kế để hỗ trợ người học tiếng Nhật tự luyện phản xạ dịch Việt → Nhật theo cấu trúc ngữ pháp Minna no Nihongo. Toàn bộ câu bài tập được tự biên soạn độc lập.")) {
                    EmptyView()
                }
            }
            .navigationTitle("Cài đặt")
            .alert("Xác nhận đặt lại?", isPresented: $viewModel.showResetConfirmAlert) {
                Button("Hủy", role: .cancel) {}
                Button("Đặt lại", role: .destructive) {
                    viewModel.resetAllProgress()
                }
            } message: {
                Text("Toàn bộ lịch sử câu đã làm, số câu đúng/sai và các câu đã đánh dấu sao sẽ bị xóa. Bạn có chắc chắn muốn đặt lại không?")
            }
        }
    }
}
