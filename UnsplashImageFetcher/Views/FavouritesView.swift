import SwiftUI

struct FavouritesView: View {
    @StateObject private var viewModel = FavouritesViewModel()

    var body: some View {
        VStack {
            if viewModel.favourites.isEmpty {
                Text("No Favorites Added Yet!")
                    .font(.headline)
                    .padding()
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 10) {
                        ForEach(viewModel.favourites) { image in
                            VStack {
                                AsyncImage(url: URL(string: image.urls.thumb)) { image in
                                    image.resizable().aspectRatio(contentMode: .fill)
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 100, height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 10))

                                Text(image.description ?? "No Description")
                                    .font(.caption)
                                    .multilineTextAlignment(.center)
                                    .padding(.top, 5)

                                Button(action: {
                                    viewModel.removeFromFavourites(image)
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                                .buttonStyle(BorderlessButtonStyle())
                                .padding(.top, 5)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Favourites")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    FavouritesView()
}
