import Foundation

class ImageGridViewModel: ObservableObject {
    @Published var images: [ImageData] = []
    @Published var allImages: [ImageData] = []
    @Published var searchQuery: String = ""
    @Published var favourites: [ImageData] = []

    init() {
        loadFavourites()
        // Mock data for testing
        let mockImage = ImageData(
            id: "1",
            urls: ImageData.ImageURLs(
                thumb: "https://via.placeholder.com/150",
                regular: "https://via.placeholder.com/300"
            ),
            description: "Test Image"
        )
        self.images = [mockImage]
        self.allImages = [mockImage]
    }


    func fetchImages() {
        let urlString = "https://api.unsplash.com/photos?client_id=NIsUoRsP2Re4Z6_Qrf1QV0ItnypAAZJ5Q21OWj8WHPI"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching images: \(error.localizedDescription)")
                return
            }

            if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                print("Invalid response: \(response.statusCode)")
                return
            }

            guard let data = data else {
                print("No data received.")
                return
            }

            do {
                // Debug: Print raw JSON
                print("Raw JSON data: \(String(data: data, encoding: .utf8) ?? "No JSON")")
                
                let decoded = try JSONDecoder().decode([ImageData].self, from: data)
                DispatchQueue.main.async {
                    self.images = decoded
                    self.allImages = decoded
                    print("Images fetched: \(self.images.count)") // Debug count
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
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
