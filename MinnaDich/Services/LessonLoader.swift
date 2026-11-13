import Foundation

public final class LessonLoader {
    public static let shared = LessonLoader()
    
    private init() {}
    
    /// Đọc danh sách bài học từ file JSON trong Bundle
    public func loadLessons(from filename: String = "lessons") -> [Lesson] {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            print("⚠️ [LessonLoader] Không tìm thấy file \(filename).json trong Bundle.")
            return []
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let container = try decoder.decode(LessonsContainer.self, data: data)
            return container.lessons.sorted(by: { $0.lesson < $1.lesson })
        } catch {
            print("❌ [LessonLoader] Lỗi decode file \(filename).json: \(error)")
            return []
        }
    }
}
