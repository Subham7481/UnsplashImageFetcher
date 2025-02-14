import Foundation

struct ImageData: Identifiable, Codable, Equatable {
    let id: String
    let urls: ImageURLs
    let description: String?

    struct ImageURLs: Codable, Equatable {
        let thumb: String
        let regular: String
    }

    // Conformance to Equatable (if not auto-synthesized)
    static func == (lhs: ImageData, rhs: ImageData) -> Bool {
        return lhs.id == rhs.id
    }
}
