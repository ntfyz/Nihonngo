import SwiftUI

public struct AnswerComparisonView: View {
    public let status: AnswerStatus
    public let exercise: Exercise
    public let showRomaji: Bool
    public let onOpenParticleSheet: () -> Void
    public let onRetry: () -> Void
    public let onReveal: () -> Void
    
    public init(
        status: AnswerStatus,
        exercise: Exercise,
        showRomaji: Bool,
        onOpenParticleSheet: @escaping () -> Void,
        onRetry: @escaping () -> Void,
        onReveal: @escaping () -> Void
    ) {
        self.status = status
        self.exercise = exercise
        self.showRomaji = showRomaji
        self.onOpenParticleSheet = onOpenParticleSheet
        self.onRetry = onRetry
        self.onReveal = onReveal
    }
    
    private var statusColor: Color {
        switch status {
        case .correct: return .green
        case .incorrect: return .red
        case .revealed: return .blue
        case .unsubmitted: return .clear
        }
    }
    
    private var statusIcon: String {
        switch status {
        case .correct: return "checkmark.circle.fill"
        case .incorrect: return "xmark.circle.fill"
        case .revealed: return "lightbulb.fill"
        case .unsubmitted: return ""
        }
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Header Trạng thái
            HStack(spacing: 8) {
                Image(systemName: statusIcon)
                    .font(.title3)
                    .foregroundColor(statusColor)
                
                Text(status.title)
                    .font(.headline)
                    .foregroundColor(statusColor)
                
                Spacer()
                
                if status == .incorrect {
                    Button("Xem đáp án", action: onReveal)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                }
            }
            
            // Chi tiết đáp án (Hiện khi Đúng hoặc khi Đã xem đáp án)
            if status == .correct || status == .revealed {
                VStack(alignment: .leading, spacing: 8) {
                    Text("ĐÁP ÁN CHUẨN")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                    
                    Text(exercise.answer)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    if showRomaji && !exercise.romaji.isEmpty {
                        Text(exercise.romaji)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .italic()
                    }
                    
                    // Các phương án thay thế
                    if let alts = exercise.alternatives, !alts.isEmpty {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Cách viết khác chấp nhận:")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            ForEach(alts, id: \.self) { alt in
                                Text("• \(alt)")
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.top, 4)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                
                // Nút mở giải thích trợ từ
                Button(action: onOpenParticleSheet) {
                    HStack {
                        Image(systemName: "sparkles")
                            .foregroundColor(.orange)
                        Text("Xem giải thích trợ từ chi tiết")
                            .fontWeight(.medium)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color.orange.opacity(0.1))
                    .foregroundColor(.primary)
                    .cornerRadius(12)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .stroke(statusColor.opacity(0.4), lineWidth: 1.5)
                .background(statusColor.opacity(0.04))
        )
        .cornerRadius(16)
    }
}
