import Network
import Combine

final class NetworkMonitor: NetworkMonitorProtocol, ObservableObject {
    static let shared = NetworkMonitor()
    @Published private(set) var isOnline = true

    private let monitor = NWPathMonitor()

    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isOnline = path.status == .satisfied
            }
        }
        monitor.start(queue: .global(qos: .background))
    }
}
