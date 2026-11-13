import Foundation

public enum JapaneseNormalizer {
    /// Chuẩn hóa chuỗi tiếng Nhật để so sánh:
    /// - Chuyển sang dạng Unicode chuẩn (NFC)
    /// - Loại bỏ mọi khoảng trắng (cả half-width ' ' lẫn full-width '　' \u{3000})
    /// - Loại bỏ dấu câu tiếng Nhật và phương Tây: 。、. , ! ！ ? ？ ~ 〜 -
    /// - Đưa chữ cái Latinh về lowercase (nếu có lẫn romaji/chữ cái)
    public static func normalize(_ text: String) -> String {
        var result = text.precomposedStringWithCanonicalMapping
        
        // Ký tự cần loại bỏ: dấu cách, tab, xuống dòng, dấu chấm, dấu phẩy, dấu hỏi, than
        let charactersToRemove: Set<Character> = [
            " ", "　", "\t", "\n", "\r",
            "。", ".", "、", ",", "！", "!", "？", "?",
            "〜", "~", "-", "ー", "「", "」", "（", "）", "(", ")"
        ]
        
        result.removeAll(where: { charactersToRemove.contains($0) })
        return result.lowercased()
    }
    
    /// So sánh câu người dùng nhập với đáp án chính và các đáp án thay thế
    public static func checkAnswer(userInput: String, exercise: Exercise) -> Bool {
        let normalizedUser = normalize(userInput)
        guard !normalizedUser.isEmpty else { return false }
        
        // 1. So sánh với đáp án chính
        let normalizedAnswer = normalize(exercise.answer)
        if normalizedUser == normalizedAnswer {
            return true
        }
        
        // 2. So sánh với các đáp án thay thế (alternatives)
        if let alternatives = exercise.alternatives {
            for alt in alternatives {
                if normalizedUser == normalize(alt) {
                    return true
                }
            }
        }
        
        return false
    }
}
