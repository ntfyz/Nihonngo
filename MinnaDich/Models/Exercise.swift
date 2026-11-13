import Foundation

public struct Exercise: Codable, Identifiable, Hashable {
    public let id: String
    public let vi: String
    public let answer: String
    public let romaji: String
    public let alternatives: [String]?
    public let particleNotes: [ParticleNote]?
    
    public init(
        id: String,
        vi: String,
        answer: String,
        romaji: String,
        alternatives: [String]? = nil,
        particleNotes: [ParticleNote]? = nil
    ) {
        self.id = id
        self.vi = vi
        self.answer = answer
        self.romaji = romaji
        self.alternatives = alternatives
        self.particleNotes = particleNotes
    }
}
