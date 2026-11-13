import Foundation
import Combine

public enum AnswerStatus: Equatable {
    case unsubmitted
    case correct
    case incorrect
    case revealed
    
    public var title: String {
        switch self {
        case .unsubmitted: return ""
        case .correct: return "Chính xác! Tuyệt vời 🎉"
        case .incorrect: return "Chưa chính xác! Thử lại hoặc xem đáp án nhé."
        case .revealed: return "Đáp án chuẩn"
        }
    }
}

public final class PracticeViewModel: ObservableObject {
    public let title: String
    public let exercises: [Exercise]
    public let grammarPoints: [String]
    
    @Published public var currentIndex: Int = 0
    @Published public var userInput: String = ""
    @Published public var answerStatus: AnswerStatus = .unsubmitted
    @Published public var showParticleSheet: Bool = false
    @Published public var showGrammarSheet: Bool = false
    
    private let progressStore: ProgressStore
    private var cancellables = Set<AnyCancellable>()
    
    public init(
        title: String,
        exercises: [Exercise],
        grammarPoints: [String] = [],
        initialIndex: Int = 0,
        progressStore: ProgressStore = .shared
    ) {
        self.title = title
        self.exercises = exercises
        self.grammarPoints = grammarPoints
        self.progressStore = progressStore
        self.currentIndex = min(max(initialIndex, 0), max(0, exercises.count - 1))
        
        progressStore.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
    
    public var currentExercise: Exercise? {
        guard currentIndex >= 0 && currentIndex < exercises.count else { return nil }
        return exercises[currentIndex]
    }
    
    public var hasNext: Bool {
        currentIndex < exercises.count - 1
    }
    
    public var hasPrevious: Bool {
        currentIndex > 0
    }
    
    public var isCurrentBookmarked: Bool {
        guard let id = currentExercise?.id else { return false }
        return progressStore.isBookmarked(id)
    }
    
    public var currentProgressStatus: ExerciseProgress? {
        guard let id = currentExercise?.id else { return nil }
        return progressStore.progress(for: id)
    }
    
    // MARK: - Actions
    
    public func checkAnswer() {
        guard let ex = currentExercise else { return }
        let trimmed = userInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        let isCorrect = JapaneseNormalizer.checkAnswer(userInput: trimmed, exercise: ex)
        if isCorrect {
            answerStatus = .correct
            progressStore.recordResult(exerciseId: ex.id, isCorrect: true)
        } else {
            answerStatus = .incorrect
            progressStore.recordResult(exerciseId: ex.id, isCorrect: false)
        }
    }
    
    public func revealAnswer() {
        guard let ex = currentExercise else { return }
        answerStatus = .revealed
        // Nếu người dùng chọn xem đáp án mà chưa từng làm đúng, ghi nhận đã thử
        if !progressStore.isCorrect(ex.id) {
            progressStore.recordResult(exerciseId: ex.id, isCorrect: false)
        }
    }
    
    public func toggleBookmark() {
        guard let id = currentExercise?.id else { return }
        progressStore.toggleBookmark(exerciseId: id)
    }
    
    public func nextExercise() {
        if hasNext {
            currentIndex += 1
            resetStateForNewExercise()
        }
    }
    
    public func previousExercise() {
        if hasPrevious {
            currentIndex -= 1
            resetStateForNewExercise()
        }
    }
    
    public func jumpTo(index: Int) {
        guard index >= 0 && index < exercises.count else { return }
        currentIndex = index
        resetStateForNewExercise()
    }
    
    private func resetStateForNewExercise() {
        userInput = ""
        answerStatus = .unsubmitted
    }
}
