import Foundation
import Combine

final class APIClient {
    static let shared = APIClient()
    
    private let baseURL = URL(string: "https://jsonplaceholder.typicode.com")!
    private let urlSession: URLSession
    
    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        self.urlSession = URLSession(configuration: config)
    }

    // MARK: - Posts - Async/Await

    func fetchPosts() async throws -> [Post] {
        let url = baseURL.appendingPathComponent("posts")
        let (data, response) = try await urlSession.data(from: url)
        
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode([Post].self, from: data)
    }
    
    // MARK: - Posts - Combine Publisher
    
    func fetchPostsPublisher() -> AnyPublisher<[Post], Error> {
        let url = baseURL.appendingPathComponent("posts")
        
        return urlSession.dataTaskPublisher(for: url)
            .tryMap { output -> Data in
                guard let http = output.response as? HTTPURLResponse,
                      (200..<300).contains(http.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .decode(type: [Post].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    // MARK: - Photos (with images)

    func fetchPhotos() async throws -> [Photo] {
        let url = baseURL.appendingPathComponent("photos")
        let (data, response) = try await urlSession.data(from: url)

        guard let http = response as? HTTPURLResponse,
              (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode([Photo].self, from: data)
    }
}
