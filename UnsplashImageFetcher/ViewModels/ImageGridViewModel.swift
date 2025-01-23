import Foundation
class ImageGridViewModel: ObservableObject{
    @Published var images: [ImageData] = []
    @Published var allImages: [ImageData] = []
    @Published var searchQuery: String = ""
    @Published var favourites: [ImageData] = []
    init(){
        loadFavourites()
    }
    func fetchImages() {
        let url = URL(string: "https://api.unsplash.com/photos?client_id=NIsUoRsP2Re4Z6_Qrf1QV0ItnypAAZJ5Q21OWj8WHPI")!
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            if let decoded = try? JSONDecoder().decode([ImageData].self, from: data) {
                DispatchQueue.main.async {
                    self.images = decoded
                    self.allImages = decoded
                }
            }
        }.resume()
    }

    func searchImages(query: String) {
        guard !query.isEmpty else {
            images = allImages
            return
        }

        images = allImages.filter { image in
            image.description?.lowercased().contains(query.lowercased()) ?? false
        }
    }

    func loadFavourites() {
        if let data = UserDefaults.standard.data(forKey: "favorites") {
            if let decodedFavourites = try? JSONDecoder().decode([ImageData].self, from: data) {
                favourites = decodedFavourites
            }
        }
    }

    func addToFavourites(_ image: ImageData) {
        if !favourites.contains(where: { $0.id == image.id }) {
            favourites.append(image)
            saveFavourites()
        }
    }

    func saveFavourites() {
        if let encodedData = try? JSONEncoder().encode(favourites) {
            UserDefaults.standard.set(encodedData, forKey: "favorites")
        }
    }
}
