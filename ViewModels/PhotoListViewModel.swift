import Foundation

@MainActor
final class PhotoListViewModel: ObservableObject {
    @Published private(set) var allPhotos: [Photo] = []
    @Published private(set) var visiblePhotos: [Photo] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let apiClient: APIClient
    private let pageSize: Int = 10
    private var currentCount: Int = 0

    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }

    func loadInitial() {
        // Avoid reloading if we already have data
        guard allPhotos.isEmpty else { return }

        isLoading = true
        errorMessage = nil

        Task {
            do {
                let photos = try await apiClient.fetchPhotos()
                self.allPhotos = photos
                self.currentCount = min(pageSize, photos.count)
                self.visiblePhotos = Array(photos.prefix(self.currentCount))
            } catch {
                self.errorMessage = "Failed to load photos: \(error.localizedDescription)"
            }
            self.isLoading = false
        }
    }

    func loadMoreIfNeeded(currentItem: Photo?) {
        guard let currentItem = currentItem else { return }
        // If the list is empty, there is nothing to paginate and
        // calling `index(_:offsetBy:)` with a negative offset from
        // `endIndex` would crash, so early–return.
        guard !visiblePhotos.isEmpty else { return }

        guard let index = visiblePhotos.firstIndex(where: { $0.id == currentItem.id }) else { return }

        let thresholdIndex = visiblePhotos.index(visiblePhotos.endIndex, offsetBy: -1)
        if index == thresholdIndex {
            loadMore()
        }
    }

    private func loadMore() {
        guard currentCount < allPhotos.count else { return }
        let nextCount = min(currentCount + pageSize, allPhotos.count)
        visiblePhotos = Array(allPhotos.prefix(nextCount))
        currentCount = nextCount
    }
}
