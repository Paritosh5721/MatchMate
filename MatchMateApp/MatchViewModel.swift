import Foundation
import Combine

final class MatchViewModel: ObservableObject {
    @Published var profiles: [MatchProfile] = []
    @Published var isLoading = false
    @Published var error: String?

    private let network: NetworkServiceProtocol
    let monitor: NetworkMonitor

    private var bag = Set<AnyCancellable>()
    private var fetchBag = Set<AnyCancellable>()

    init(
        network: NetworkServiceProtocol = NetworkService.shared,
        monitor: NetworkMonitor = .shared
    ) {
        self.network = network
        self.monitor = monitor

        monitor.$isOnline
            .removeDuplicates()
            .filter { $0 }
            .sink { [weak self] _ in self?.load() }
            .store(in: &bag)
    }

    func load() {
        guard monitor.isOnline else { return }
        fetchFromAPI()
    }

    func accept(_ id: Int) { setStatus(.accepted, for: id) }
    func decline(_ id: Int) { setStatus(.declined, for: id) }

    private func fetchFromAPI() {
        // Cancel any in-flight request by clearing fetchBag
        fetchBag.removeAll()
        isLoading = true
        error = nil

        network.fetchUsers()
            .sink(
                receiveCompletion: { [weak self] result in
                    self?.isLoading = false
                    if case .failure(let e) = result {
                        self?.error = e.localizedDescription
                    }
                },
                receiveValue: { [weak self] users in
                    guard let self else { return }
                    let existing = Dictionary(uniqueKeysWithValues: profiles.map { ($0.id, $0.status) })
                    profiles = users.map { MatchProfile(user: $0, status: existing[$0.id] ?? .pending) }
                }
            )
            .store(in: &fetchBag)
    }

    private func setStatus(_ status: MatchStatus, for id: Int) {
        profiles = profiles.map { profile in
            guard profile.id == id else { return profile }
            var updated = profile
            updated.status = status
            return updated
        }
    }
}
