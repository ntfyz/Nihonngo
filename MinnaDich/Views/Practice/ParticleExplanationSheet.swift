import SwiftUI

public struct ParticleExplanationSheet: View {
    @Environment(\.dismiss) private var dismiss
    public let notes: [ParticleNote]
    public let japaneseSentence: String
    
    public init(notes: [ParticleNote], japaneseSentence: String) {
        self.notes = notes
        self.japaneseSentence = japaneseSentence
    }
    
    private func colorForParticle(_ p: String) -> Color {
        switch p {
        case "は": return .orange
        case "が": return .red
        case "を": return .green
        case "に": return .blue
        case "で": return .purple
        case "へ": return .teal
        case "の": return .indigo
        case "も": return .brown
        case "と": return .cyan
        case "から", "まで": return .pink
        case "か", "ね", "よ": return .mint
        default: return .gray
        }
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header câu gốc
                    VStack(alignment: .leading, spacing: 8) {
                        Text("CÂU GỐC")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.secondary)
                        
                        Text(japaneseSentence)
                            .font(.title3)
                            .fontWeight(.medium)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.secondary.opacity(0.08))
                            .cornerRadius(12)
                    }
                    
                    if notes.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "checkmark.seal")
                                .font(.system(size: 40))
                                .foregroundColor(.secondary)
                            Text("Câu này không chứa trợ từ ngữ pháp đặc biệt hoặc là mẫu chào hỏi thông dụng.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 30)
                    } else {
                        VStack(alignment: .leading, spacing: 14) {
                            Text("GIẢI THÍCH TRỢ TỪ CHI TIẾT")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.secondary)
                            
                            ForEach(notes) { note in
                                HStack(alignment: .top, spacing: 14) {
                                    // Badge trợ từ
                                    Text(note.particle)
                                        .font(.title2)
                                        .fontWeight(.heavy)
                                        .foregroundColor(.white)
                                        .frame(width: 44, height: 44)
                                        .background(colorForParticle(note.particle))
                                        .clipShape(Circle())
                                        .shadow(color: colorForParticle(note.particle).opacity(0.3), radius: 4, y: 2)
                                    
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text("Trợ từ 「\(note.particle)」")
                                            .font(.headline)
                                            .foregroundColor(.primary)
                                        
                                        Text(note.explain)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                            .fixedSize(horizontal: false, vertical: true)
                                    }
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(12)
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Phân tích trợ từ")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Đóng") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}
