import SwiftUI

public struct PracticeView: View {
    @StateObject private var viewModel: PracticeViewModel
    @ObservedObject private var settings = SettingsViewModel.shared
    @FocusState private var isInputFocused: Bool
    @Environment(\.dismiss) private var dismiss
    
    public init(
        title: String,
        exercises: [Exercise],
        grammarPoints: [String] = [],
        initialIndex: Int = 0
    ) {
        _viewModel = StateObject(
            wrappedValue: PracticeViewModel(
                title: title,
                exercises: exercises,
                grammarPoints: grammarPoints,
                initialIndex: initialIndex
            )
        )
    }
    
    public var body: some View {
        Group {
            if viewModel.exercises.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "tray.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.secondary)
                    Text("Bài này chưa có câu hỏi nào.")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text("Các câu hỏi sẽ sớm được cập nhật.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    if !viewModel.grammarPoints.isEmpty {
                        Button("Xem ngữ pháp bài học") {
                            viewModel.showGrammarSheet = true
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.top, 10)
                    }
                }
                .padding()
            } else if let exercise = viewModel.currentExercise {
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 20) {
                            // Header thanh tiến độ trong bài
                            headerProgressSection
                            
                            // Thẻ câu hỏi tiếng Việt
                            questionCard(exercise)
                            
                            // Ô nhập tiếng Nhật
                            inputSection
                            
                            // Nút hành động Kiểm tra / Xem đáp án
                            actionButtonsSection
                            
                            // Kết quả & Đối chiếu
                            if viewModel.answerStatus != .unsubmitted {
                                AnswerComparisonView(
                                    status: viewModel.answerStatus,
                                    exercise: exercise,
                                    showRomaji: settings.showRomaji,
                                    onOpenParticleSheet: {
                                        viewModel.showParticleSheet = true
                                    },
                                    onRetry: {
                                        viewModel.userInput = ""
                                        viewModel.answerStatus = .unsubmitted
                                        isInputFocused = true
                                    },
                                    onReveal: {
                                        viewModel.revealAnswer()
                                    }
                                )
                                .id("ResultView")
                                .transition(.opacity.combined(with: .move(edge: .bottom)))
                            }
                            
                            Spacer(minLength: 30)
                        }
                        .padding()
                    }
                    .onChange(of: viewModel.answerStatus) { _ in
                        if viewModel.answerStatus != .unsubmitted {
                            withAnimation {
                                proxy.scrollTo("ResultView", anchor: .bottom)
                            }
                        }
                    }
                }
                .safeAreaInset(edge: .bottom) {
                    bottomNavigationBar
                }
            }
        }
        .navigationTitle(viewModel.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                if !viewModel.grammarPoints.isEmpty {
                    Button {
                        viewModel.showGrammarSheet = true
                    } label: {
                        Image(systemName: "list.clipboard")
                    }
                }
                
                if viewModel.currentExercise != nil {
                    Button {
                        viewModel.toggleBookmark()
                    } label: {
                        Image(systemName: viewModel.isCurrentBookmarked ? "star.fill" : "star")
                            .foregroundColor(viewModel.isCurrentBookmarked ? .yellow : .primary)
                    }
                }
            }
        }
        .sheet(isPresented: $viewModel.showParticleSheet) {
            if let exercise = viewModel.currentExercise {
                ParticleExplanationSheet(
                    notes: exercise.particleNotes ?? [],
                    japaneseSentence: exercise.answer
                )
            }
        }
        .sheet(isPresented: $viewModel.showGrammarSheet) {
            GrammarPointsSheet(
                lessonTitle: viewModel.title,
                grammarPoints: viewModel.grammarPoints
            )
        }
    }
    
    // MARK: - Subviews
    
    private var headerProgressSection: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Câu \(viewModel.currentIndex + 1) / \(viewModel.exercises.count)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if let status = viewModel.currentProgressStatus, status.isAnswered {
                    HStack(spacing: 4) {
                        Image(systemName: status.isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                        Text(status.isCorrect ? "Đã làm đúng" : "Đã làm sai")
                    }
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(status.isCorrect ? .green : .red)
                }
            }
            
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.secondary.opacity(0.15))
                        .frame(height: 5)
                    
                    let progress = Double(viewModel.currentIndex + 1) / Double(max(1, viewModel.exercises.count))
                    Capsule()
                        .fill(Color.accentColor)
                        .frame(width: max(0, min(geo.size.width * CGFloat(progress), geo.size.width)), height: 5)
                        .animation(.easeInOut(duration: 0.2), value: viewModel.currentIndex)
                }
            }
            .frame(height: 5)
        }
    }
    
    private func questionCard(_ exercise: Exercise) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("DỊCH SANG TIẾNG NHẬT")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.accentColor)
                Spacer()
                Text(exercise.id)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Text(exercise.vi)
                .font(.system(size: 20 * settings.fontSizeScale, weight: .bold))
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }
    
    private var inputSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("CÂU TRẢ LỜI CỦA BẠN")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                Spacer()
                if !viewModel.userInput.isEmpty {
                    Button("Xóa") {
                        viewModel.userInput = ""
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
            }
            
            TextField("Nhập tiếng Nhật (Kanji, Hiragana)...", text: $viewModel.userInput, axis: .vertical)
                .lineLimit(2...4)
                .font(.system(size: 18 * settings.fontSizeScale))
                .padding()
                .background(Color(.tertiarySystemBackground))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isInputFocused ? Color.accentColor : Color.secondary.opacity(0.2), lineWidth: 1.5)
                )
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .focused($isInputFocused)
                .submitLabel(.done)
                .onSubmit {
                    if !viewModel.userInput.isEmpty {
                        viewModel.checkAnswer()
                    }
                }
        }
    }
    
    private var actionButtonsSection: some View {
        HStack(spacing: 12) {
            // Nút Kiểm tra
            Button {
                isInputFocused = false
                viewModel.checkAnswer()
            } label: {
                HStack {
                    Image(systemName: "checkmark")
                    Text("Kiểm tra")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.userInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            
            // Nút Xem đáp án
            Button {
                isInputFocused = false
                viewModel.revealAnswer()
            } label: {
                HStack {
                    Image(systemName: "eye")
                    Text("Xem đáp án")
                        .fontWeight(.medium)
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
            }
            .buttonStyle(.bordered)
        }
    }
    
    private var bottomNavigationBar: some View {
        HStack {
            Button {
                withAnimation {
                    viewModel.previousExercise()
                }
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "chevron.left")
                    Text("Câu trước")
                }
                .font(.subheadline)
                .fontWeight(.medium)
            }
            .disabled(!viewModel.hasPrevious)
            
            Spacer()
            
            Button {
                withAnimation {
                    viewModel.nextExercise()
                }
            } label: {
                HStack(spacing: 4) {
                    Text("Câu tiếp")
                    Image(systemName: "chevron.right")
                }
                .font(.subheadline)
                .fontWeight(.bold)
            }
            .disabled(!viewModel.hasNext)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial)
    }
}
