import SwiftUI

public struct LessonRowView: View {
    public let lesson: Lesson
    public let progress: (completed: Int, correct: Int, total: Int, ratio: Double)
    
    public init(lesson: Lesson, progress: (completed: Int, correct: Int, total: Int, ratio: Double)) {
        self.lesson = lesson
        self.progress = progress
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Tiêu đề & Badge
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("BÀI \(lesson.lesson)")
                        .font(.caption)
                        .fontWeight(.heavy)
                        .foregroundColor(.accentColor)
                    
                    Text(lesson.title.replacingOccurrences(of: "Bài \(lesson.lesson): ", with: ""))
                        .font(.headline)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                if progress.total > 0 {
                    // Badge số câu đã làm
                    HStack(spacing: 3) {
                        Image(systemName: progress.completed == progress.total ? "checkmark.circle.fill" : "pencil.circle")
                            .font(.caption)
                        Text("\(progress.completed)/\(progress.total)")
                            .font(.caption)
                            .fontWeight(.bold)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        progress.completed == progress.total
                            ? Color.green.opacity(0.15)
                            : Color.secondary.opacity(0.12)
                    )
                    .foregroundColor(progress.completed == progress.total ? .green : .secondary)
                    .clipShape(Capsule())
                } else {
                    Text("Sắp có bài tập")
                        .font(.caption2)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 3)
                        .background(Color.orange.opacity(0.12))
                        .foregroundColor(.orange)
                        .clipShape(Capsule())
                }
            }
            
            // Thanh tiến độ
            if progress.total > 0 {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.secondary.opacity(0.15))
                            .frame(height: 6)
                        
                        Capsule()
                            .fill(progress.ratio >= 1.0 ? Color.green : Color.accentColor)
                            .frame(width: max(0, min(geo.size.width * CGFloat(progress.ratio), geo.size.width)), height: 6)
                            .animation(.spring(), value: progress.ratio)
                    }
                }
                .frame(height: 6)
            }
            
            // Ngữ pháp vắn tắt
            if !lesson.grammarPoints.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(lesson.grammarPoints.prefix(3), id: \.self) { point in
                            Text(point)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.secondary.opacity(0.08))
                                .cornerRadius(4)
                        }
                        if lesson.grammarPoints.count > 3 {
                            Text("+\(lesson.grammarPoints.count - 3)")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
        .padding(.vertical, 6)
    }
}
