import Foundation
import Combine

public enum ReviewMode: String, CaseIterable, Identifiable {
    case all = "Tất cả"
    case wrongOnly = "Câu làm sai"
    case bookmarkedOnly = "Đã đánh dấu ★"
    
    public var id: String { rawValue }
    
    public var iconName: String {
        switch self {
        case .all: return "arrow.triangle.2.circlepath"
        case .wrongOnly: return "xmark.circle"
        case .bookmarkedOnly: return "star.fill"
        }
    }
}

public final class ReviewViewModel: ObservableObject {
    @Published public var selectedMode: ReviewMode = .all
    @Published public var reviewExercises: [Exercise] = []
    
    private let loader: LessonLoader
    private let progressStore: ProgressStore
    private var cancellables = Set<AnyCancellable>()
    
    public init(loader: LessonLoader = .shared, progressStore: ProgressStore = .shared) {
        self.loader = loader
        self.progressStore = progressStore
        
        progressStore.objectWillChange
            .sink { [weak self] _ in
                self?.refreshExercises()
            }
            .store(in: &cancellables)
            
        refreshExercises()
    }
    
    public var allLessons: [Lesson] {
        loader.loadLessons()
    }
    
    public var allExercisesDict: [String: Exercise] {
        var dict: [String: Exercise] = [:]
        for lesson in allLessons {
            for ex in lesson.exercises {
                dict[ex.id] = ex
            }
        }
        return dict
    }
    
    public var wrongCount: Int {
        let wrongIds = progressStore.wrongExerciseIds()
        return wrongIds.filter { allExercisesDict[$0] != nil }.count
    }
    
    public var bookmarkCount: Int {
        let bookmarkIds = progressStore.bookmarkedExerciseIds()
        return bookmarkIds.filter { allExercisesDict[$0] != nil }.count
    }
    
    public func refreshExercises() {
        let dict = allExercisesDict
        let wrongIds = progressStore.wrongExerciseIds()
        let bookmarkIds = progressStore.bookmarkedExerciseIds()
        
        var targetIds: Set<String> = []
        
        switch selectedMode {
        case .all:
            targetIds = wrongIds.union(bookmarkIds)
        case .wrongOnly:
            targetIds = wrongIds
        case .bookmarkedOnly:
            targetIds = bookmarkIds
        }
        
        self.reviewExercises = targetIds.compactMap { dict[$0] }.shuffled()
    }
    
    public func shuffleCurrentList() {
        reviewExercises.shuffle()
    }
}
