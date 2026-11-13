import SwiftUI

public struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            List {
                // Header Thống kê tổng quan
                Section {
                    overallStatsCard
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                }
                
                // Danh sách bài 1 - 25
                Section(header: Text("GIÁO TRÌNH MINNA NO NIHONGO (BÀI 1 - 25)")) {
                    ForEach(viewModel.filteredLessons) { lesson in
                        NavigationLink {
                            PracticeView(
                                title: "Bài \(lesson.lesson): \(lesson.title)",
                                exercises: lesson.exercises,
                                grammarPoints: lesson.grammarPoints
                            )
                        } label: {
                            LessonRowView(
                                lesson: lesson,
                                progress: viewModel.progress(for: lesson)
                            )
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Minna Dịch")
            .searchable(text: $viewModel.searchText, prompt: "Tìm bài học hoặc ngữ pháp...")
            .refreshable {
                viewModel.loadLessons()
            }
        }
    }
    
    private var overallStatsCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("TIẾN ĐỘ HỌC TẬP")
                        .font(.caption)
                        .fontWeight(.heavy)
                        .foregroundColor(.white.opacity(0.85))
                    
                    Text("\(viewModel.totalCompletedCount) / \(viewModel.totalExercisesCount) câu đã luyện")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                Spacer()
                
                // Vòng tròn phần trăm
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.25), lineWidth: 5)
                        .frame(width: 52, height: 52)
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(viewModel.overallRatio))
                        .stroke(Color.white, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .frame(width: 52, height: 52)
                        .animation(.easeInOut, value: viewModel.overallRatio)
                    
                    Text("\(Int(viewModel.overallRatio * 100))%")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            }
            
            // Chi tiết số câu đúng
            HStack(spacing: 16) {
                HStack(spacing: 6) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green.opacity(0.9))
                    Text("\(viewModel.totalCorrectCount) câu đúng")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.95))
                }
                
                HStack(spacing: 6) {
                    Image(systemName: "books.vertical.fill")
                        .foregroundColor(.yellow.opacity(0.9))
                    Text("25 bài học")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.95))
                }
            }
        }
        .padding(18)
        .background(
            LinearGradient(
                colors: [Color.indigo, Color.blue],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(18)
        .shadow(color: Color.blue.opacity(0.3), radius: 8, y: 4)
        .padding(.horizontal)
        .padding(.top, 8)
    }
}
