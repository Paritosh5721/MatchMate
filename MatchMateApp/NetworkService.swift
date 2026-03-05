import Foundation
import Combine

final class NetworkService: NetworkServiceProtocol {
    static let shared = NetworkService()

    func fetchUsers() -> AnyPublisher<[User], Error> {
        var request = URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/users")!)
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData

        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: [User].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
