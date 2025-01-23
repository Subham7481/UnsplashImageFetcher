import SwiftUI

struct ImageDetailView: View {
    let image: ImageData

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: image.urls.regular)) { image in
                image.resizable().aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Text(image.description ?? "No Description")
                .font(.headline)
                .padding()
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
