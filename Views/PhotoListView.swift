import SwiftUI

struct PhotoListView: View {
    @StateObject private var viewModel = PhotoListViewModel()

    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading photos...")
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    List(viewModel.visiblePhotos) { photo in
                        HStack(spacing: 12) {
                            AsyncImage(url: URL(string: photo.thumbnailUrl)) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                        .frame(width: 60, height: 60)
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 60, height: 60)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                case .failure:
                                    Image(systemName: "photo")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 60, height: 60)
                                        .foregroundColor(.gray)
                                @unknown default:
                                    EmptyView()
                                }
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                Text(photo.title)
                                    .font(.subheadline)
                                    .lineLimit(2)
                                Text("ID: \(photo.id)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                        .onAppear {
                            viewModel.loadMoreIfNeeded(currentItem: photo)
                        }
                    }
                }
            }
            .navigationTitle("Photos (lazy)")
        }
        .onAppear {
            viewModel.loadInitial()
        }
    }
}

struct PhotoListView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoListView()
    }
}
