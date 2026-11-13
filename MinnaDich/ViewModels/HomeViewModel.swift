import Foundation
import Combine

public final class HomeViewModel: ObservableObject {
    @Published public private(set) var lessons: [Lesson] = []
    @Published public var searchText: String = ""
    
    private let loader: LessonLoader
    private let progressStore: ProgressStore
    private var cancellables = Set<AnyCancellable>()
    
    public init(loader: LessonLoader = .shared, progressStore: ProgressStore = .shared) {
        self.loader = loader
        self.progressStore = progressStore
        
        // Listen to progress changes to trigger UI updates
        progressStore.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
            
        loadLessons()
    }
    
    public func loadLessons() {
        self.lessons = loader.loadLessons()
    }
    
    public var filteredLessons: [Lesson] {
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return lessons
        }
        let lower = searchText.lowercased()
        return lessons.filter {
            $0.title.lowercased().contains(lower) ||
            "Bài \($0.lesson)".lowercased().contains(lower) ||
            $0.grammarPoints.contains(where: { $0.lowercased().contains(lower) })
        }
    }
    
    // Overall Stats
    public var totalExercisesCount: Int {
        lessons.reduce(0) { $0 + $1.exercises.count }
    }
    
    public var totalCompletedCount: Int {
        var count = 0
        for lesson in lessons {
            for ex in lesson.exercises {
                if progressStore.isAnswered(ex.id) {
                    count += 1
                }
            }
        }
        return count
    }
    
    public var totalCorrectCount: Int {
        var count = 0
        for lesson in lessons {
            for ex in lesson.exercises {
                if progressStore.isCorrect(ex.id) {
                    count += 1
                }
            }
        }
        return count
    }
    
    public var overallRatio: Double {
        guard totalExercisesCount > 0 else { return 0 }
        return Double(totalCompletedCount) / Double(totalExercisesCount)
    }
    
    public func progress(for lesson: Lesson) -> (completed: Int, correct: Int, total: Int, ratio: Double) {
        progressStore.lessonProgress(for: lesson)
    }
}
