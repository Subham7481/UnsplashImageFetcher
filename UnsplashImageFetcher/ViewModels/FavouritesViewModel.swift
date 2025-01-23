import Foundation

class FavouritesViewModel: ObservableObject {
    @Published var favourites: [ImageData] = []

    init() {
        loadFavourites()
    }

    private func loadFavourites() {
        if let data = UserDefaults.standard.data(forKey: "favorites") {
            if let decodedFavourites = try? JSONDecoder().decode([ImageData].self, from: data) {
                favourites = decodedFavourites
            }
        }
    }

    private func saveFavorites() {
        if let encodedData = try? JSONEncoder().encode(favourites) {
            UserDefaults.standard.set(encodedData, forKey: "favorites")
        }
    }

    func addToFavourites(_ image: ImageData) {
        if !favourites.contains(where: { $0.id == image.id }) {
            favourites.append(image)
            saveFavorites()
        }
    }
    
    func removeFromFavourites(_ image: ImageData) {
        if let index = favourites.firstIndex(where: { $0.id == image.id }) {
            favourites.remove(at: index)
            saveFavorites()  
        }
    }
}
