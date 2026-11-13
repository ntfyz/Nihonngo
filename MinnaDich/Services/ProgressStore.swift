import Foundation
import Combine

public final class ProgressStore: ObservableObject {
    public static let shared = ProgressStore()
    
    private let storageKey = "minna_user_progress_v1"
    private let defaults: UserDefaults
    
    @Published public private(set) var progressMap: [String: ExerciseProgress] = [:]
    
    public init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        load()
    }
    
    private func load() {
        guard let data = defaults.data(forKey: storageKey) else {
            self.progressMap = [:]
            return
        }
        
        do {
            let decoded = try JSONDecoder().decode([String: ExerciseProgress].self, data: data)
            self.progressMap = decoded
        } catch {
            print("⚠️ [ProgressStore] Lỗi load tiến độ: \(error)")
            self.progressMap = [:]
        }
    }
    
    private func save() {
        do {
            let data = try JSONEncoder().encode(progressMap)
            defaults.set(data, forKey: storageKey)
        } catch {
            print("❌ [ProgressStore] Lỗi lưu tiến độ: \(error)")
        }
    }
    
    // MARK: - Query
    
    public func progress(for id: String) -> ExerciseProgress? {
        progressMap[id]
    }
    
    public func isAnswered(_ id: String) -> Bool {
        progressMap[id]?.isAnswered ?? false
    }
    
    public func isCorrect(_ id: String) -> Bool {
        progressMap[id]?.isCorrect ?? false
    }
    
    public func isBookmarked(_ id: String) -> Bool {
        progressMap[id]?.isBookmarked ?? false
    }
    
    public func wrongExerciseIds() -> Set<String> {
        let wrong = progressMap.filter { $0.value.isAnswered && !$0.value.isCorrect }
        return Set(wrong.keys)
    }
    
    public func bookmarkedExerciseIds() -> Set<String> {
        let bookmarked = progressMap.filter { $0.value.isBookmarked }
        return Set(bookmarked.keys)
    }
    
    // MARK: - Actions
    
    public func recordResult(exerciseId: String, isCorrect: Bool) {
        var item = progressMap[exerciseId] ?? ExerciseProgress(exerciseId: exerciseId)
        item.isAnswered = true
        item.isCorrect = isCorrect
        item.lastAttemptAt = Date()
        item.attemptsCount += 1
        progressMap[exerciseId] = item
        save()
    }
    
    public func toggleBookmark(exerciseId: String) {
        var item = progressMap[exerciseId] ?? ExerciseProgress(exerciseId: exerciseId)
        item.isBookmarked.toggle()
        progressMap[exerciseId] = item
        save()
    }
    
    public func resetAllProgress() {
        progressMap.removeAll()
        defaults.removeObject(forKey: storageKey)
    }
    
    // MARK: - Lesson Stats
    
    public func lessonProgress(for lesson: Lesson) -> (completed: Int, correct: Int, total: Int, ratio: Double) {
        let total = lesson.exercises.count
        guard total > 0 else {
            return (0, 0, 0, 0.0)
        }
        
        var completed = 0
        var correct = 0
        
        for ex in lesson.exercises {
            if let p = progressMap[ex.id], p.isAnswered {
                completed += 1
                if p.isCorrect {
                    correct += 1
                }
            }
        }
        
        let ratio = Double(completed) / Double(total)
        return (completed, correct, total, ratio)
    }
}
