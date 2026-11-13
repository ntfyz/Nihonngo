import Foundation

public struct ParticleNote: Codable, Identifiable, Hashable {
    public var id: String { "\(particle)-\(explain.prefix(15))" }
    public let particle: String
    public let explain: String
    
    public init(particle: String, explain: String) {
        self.particle = particle
        self.explain = explain
    }
}
