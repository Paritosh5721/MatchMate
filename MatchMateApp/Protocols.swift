import Foundation
import Combine
import UIKit

protocol NetworkServiceProtocol {
    func fetchUsers() -> AnyPublisher<[User], Error>
}

protocol ImageCacheProtocol: ObservableObject {
    var image: UIImage? { get }
    func fetch(url: String)
    func cancel()
}

protocol NetworkMonitorProtocol: ObservableObject {
    var isOnline: Bool { get }
}
