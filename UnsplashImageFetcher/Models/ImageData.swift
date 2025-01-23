import Foundation
struct ImageData: Codable, Identifiable {
    let id: String
    let urls: ImageURLs
    let description: String?
    
    struct ImageURLs: Codable {
        let thumb: String
        let regular: String
    }
}
