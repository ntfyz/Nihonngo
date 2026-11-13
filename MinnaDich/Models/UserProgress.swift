import Foundation

public struct ExerciseProgress: Codable, Hashable {
    public let exerciseId: String
    public var isAnswered: Bool
    public var isCorrect: Bool
    public var isBookmarked: Bool
    public var lastAttemptAt: Date?
    public var attemptsCount: Int
    
    public init(
        exerciseId: String,
        isAnswered: Bool = false,
        isCorrect: Bool = false,
        isBookmarked: Bool = false,
        lastAttemptAt: Date? = nil,
        attemptsCount: Int = 0
    ) {
        self.exerciseId = exerciseId
        self.isAnswered = isAnswered
        self.isCorrect = isCorrect
        self.isBookmarked = isBookmarked
        self.lastAttemptAt = lastAttemptAt
        self.attemptsCount = attemptsCount
    }
}
