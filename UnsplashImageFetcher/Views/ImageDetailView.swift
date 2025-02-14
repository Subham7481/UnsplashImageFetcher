import SwiftUI

struct ImageDetailView: View {
    let image: ImageData

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: image.urls.regular)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .failure:
                    VStack {
                        Image(systemName: "exclamationmark.triangle")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.red)
                        Text("Failed to load image.")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                @unknown default:
                    EmptyView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Text(image.description ?? "No Description")
                .font(.headline)
                .padding()
                .multilineTextAlignment(.center)
        }
        .navigationTitle("Image Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let mockImageData = ImageData(
        id: "1",
        urls: ImageData.ImageURLs(
            thumb: "https://via.placeholder.com/150",
            regular: "https://via.placeholder.com/300"
        ),
        description: "A beautiful placeholder image."
    )
    
    ImageDetailView(image: mockImageData)
}

