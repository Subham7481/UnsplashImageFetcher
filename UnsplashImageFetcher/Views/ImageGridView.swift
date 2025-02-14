import SwiftUI

struct ImageGridView: View {
    @StateObject private var viewModel = ImageGridViewModel()

    var body: some View {
        NavigationView {
            VStack {
                TextField("Search...", text: $viewModel.searchQuery)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .onChange(of: viewModel.searchQuery) { newQuery in
                        viewModel.searchImages(query: newQuery)
                    }

                if viewModel.images.isEmpty {
                    Text("No images found")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 10) {
                            ForEach(viewModel.images) { image in
                                ImageGridItem(image: image, viewModel: viewModel)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .onAppear {
                viewModel.fetchImages()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: FavouritesView()) {
                        Text("Favourites")
                            .font(.system(size: 14, weight: .bold))
                    }
                }
            }
            .navigationTitle("Image Grid")
        }
    }
}

struct ImageGridItem: View {
    let image: ImageData
    @ObservedObject var viewModel: ImageGridViewModel

    var body: some View {
        VStack {
            NavigationLink(destination: ImageDetailView(image: image)) {
                AsyncImage(url: URL(string: image.urls.thumb)) { image in
                    image.resizable().aspectRatio(contentMode: .fill)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }

            Button(action: {
                viewModel.addToFavourites(image)
            }, label: {
                Text("Add to Favourite")
                    .font(.system(size: 16))
                    .foregroundColor(.blue)
            })
        }
    }
}

#Preview {
    ImageGridView()
}
