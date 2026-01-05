import Foundation
import Combine

@MainActor
final class PostListViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    private let apiClient: APIClient
    
    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }
    
    // MARK: - Async/Await style
    
    func loadPostsAsync() {
        Task {
            await loadPostsWithAsyncAwait()
        }
    }
    
    private func loadPostsWithAsyncAwait() async {
        isLoading = true
        errorMessage = nil
        do {
            let result = try await apiClient.fetchPosts()
            posts = result
        } catch {
            errorMessage = "Failed to load posts: \(error.localizedDescription)"
        }
        isLoading = false
    }
    
    // MARK: - Combine style
    
    func loadPostsWithCombine() {
        isLoading = true
        errorMessage = nil
        
        apiClient.fetchPostsPublisher()
            .sink { [weak self] completion in
                guard let self else { return }
                self.isLoading = false
                if case let .failure(error) = completion {
                    self.errorMessage = "Failed to load posts: \(error.localizedDescription)"
                }
            } receiveValue: { [weak self] posts in
                self?.posts = posts
            }
            .store(in: &cancellables)
    }
}
