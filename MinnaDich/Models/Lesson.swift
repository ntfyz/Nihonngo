import Foundation

public struct Lesson: Codable, Identifiable, Hashable {
    public var id: Int { lesson }
    public let lesson: Int
    public let title: String
    public let grammarPoints: [String]
    public let exercises: [Exercise]
    
    public init(lesson: Int, title: String, grammarPoints: [String], exercises: [Exercise]) {
        self.lesson = lesson
        self.title = title
        self.grammarPoints = grammarPoints
        self.exercises = exercises
    }
}

public struct LessonsContainer: Codable {
    public let lessons: [Lesson]
    
    public init(lessons: [Lesson]) {
        self.lessons = lessons
    }
}
