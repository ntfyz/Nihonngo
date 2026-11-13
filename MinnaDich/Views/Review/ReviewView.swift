import SwiftUI

public struct ReviewView: View {
    @StateObject private var viewModel = ReviewViewModel()
    @State private var startPractice: Bool = false
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Thẻ thống kê nhanh
                    statsHeader
                    
                    // Lựa chọn chế độ ôn tập
                    Picker("Chế độ ôn tập", selection: $viewModel.selectedMode) {
                        ForEach(ReviewMode.allCases) { mode in
                            Text(mode.rawValue).tag(mode)
                        }
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: viewModel.selectedMode) { _ in
                        viewModel.refreshExercises()
                    }
                    
                    // Danh sách câu hỏi hoặc Trạng thái trống
                    if viewModel.reviewExercises.isEmpty {
                        emptyStateView
                    } else {
                        reviewListContent
                    }
                }
                .padding()
            }
            .navigationTitle("Ôn tập tổng hợp")
            .toolbar {
                if !viewModel.reviewExercises.isEmpty {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            withAnimation {
                                viewModel.shuffleCurrentList()
                            }
                        } label: {
                            Image(systemName: "shuffle")
                        }
                    }
                }
            }
            .navigationDestination(isPresented: $startPractice) {
                PracticeView(
                    title: "Ôn tập (\(viewModel.selectedMode.rawValue))",
                    exercises: viewModel.reviewExercises
                )
            }
        }
    }
    
    private var statsHeader: some View {
        HStack(spacing: 12) {
            // Thẻ câu sai
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                    Text("Câu sai")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                }
                Text("\(viewModel.wrongCount)")
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(.primary)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.red.opacity(0.08))
            .cornerRadius(14)
            
            // Thẻ Bookmark
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text("Đã đánh dấu")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                }
                Text("\(viewModel.bookmarkCount)")
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(.primary)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.yellow.opacity(0.12))
            .cornerRadius(14)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "sparkles")
                .font(.system(size: 54))
                .foregroundColor(.orange)
                .padding(.top, 40)
            
            Text("Không có câu nào cần ôn tập!")
                .font(.title3)
                .fontWeight(.bold)
            
            Text("Các câu bạn làm sai hoặc đánh dấu sao (★) trong quá trình luyện tập sẽ xuất hiện tại đây để ôn tập ngẫu nhiên.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
    
    private var reviewListContent: some View {
        VStack(spacing: 16) {
            // Nút Bắt đầu ôn tập lớn
            Button {
                startPractice = true
            } label: {
                HStack {
                    Image(systemName: "play.fill")
                    Text("Bắt đầu ôn tập ngay (\(viewModel.reviewExercises.count) câu)")
                        .fontWeight(.bold)
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
            }
            .buttonStyle(.borderedProminent)
            .cornerRadius(14)
            
            // Danh sách xem trước các câu
            VStack(alignment: .leading, spacing: 12) {
                Text("DANH SÁCH CÂU SẼ ÔN TẬP")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                
                ForEach(viewModel.reviewExercises.prefix(8)) { ex in
                    HStack(spacing: 12) {
                        Text(ex.id)
                            .font(.caption2)
                            .fontWeight(.bold)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(Color.secondary.opacity(0.12))
                            .cornerRadius(6)
                        
                        Text(ex.vi)
                            .font(.subheadline)
                            .lineLimit(1)
                            .foregroundColor(.primary)
                        
                        Spacer()
                    }
                    .padding(.vertical, 4)
                }
                
                if viewModel.reviewExercises.count > 8 {
                    Text("và \(viewModel.reviewExercises.count - 8) câu khác...")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(14)
        }
    }
}
