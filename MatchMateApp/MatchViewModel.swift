import Foundation
import Combine

final class MatchViewModel: ObservableObject {
    @Published var profiles: [MatchProfile] = []
    @Published var isLoading = false
    @Published var error: String?

    private let network: NetworkServiceProtocol
    private let storage: StorageServiceProtocol
    let monitor: NetworkMonitor

    private var bag = Set<AnyCancellable>()
    private var fetchBag = Set<AnyCancellable>()

    init(
        network: NetworkServiceProtocol = NetworkService.shared,
        storage: StorageServiceProtocol = StorageService.shared,
        monitor: NetworkMonitor = .shared
    ) {
        self.network = network
        self.storage = storage
        self.monitor = monitor

        // Auto-reload when connection is restored
        monitor.$isOnline
            .removeDuplicates()
            .filter { $0 }
            .dropFirst()           // skip the initial emit on launch (onAppear handles that)
            .sink { [weak self] _ in self?.fetchFromAPI() }
            .store(in: &bag)
    }

    func load() {
        if monitor.isOnline {
            fetchFromAPI()
        } else {
            // Offline — show cached data
            let cached = storage.loadAll()
            profiles = cached
            if cached.isEmpty {
                error = "No internet and no cached data available."
            }
        }
    }

    func accept(_ id: Int) { setStatus(.accepted, for: id) }
    func decline(_ id: Int) { setStatus(.declined, for: id) }

    private func fetchFromAPI() {
        fetchBag.removeAll()
        isLoading = true
        error = nil

        network.fetchUsers()
            .sink(
                receiveCompletion: { [weak self] result in
                    guard let self else { return }
                    isLoading = false
                    if case .failure(let e) = result {
                        self.error = e.localizedDescription
                        // Fall back to cache on network failure
                        let cached = storage.loadAll()
                        if !cached.isEmpty { profiles = cached }
                    }
                },
                receiveValue: { [weak self] users in
                    guard let self else { return }
                    // Merge: keep existing accept/decline decisions
                    let existingStatus = Dictionary(
                        uniqueKeysWithValues: storage.loadAll().map { ($0.id, $0.status) }
                    )
                    let merged = users.map {
                        MatchProfile(user: $0, status: existingStatus[$0.id] ?? .pending)
                    }
                    profiles = merged
                    storage.save(merged)
                }
            )
            .store(in: &fetchBag)
    }

    private func setStatus(_ status: MatchStatus, for id: Int) {
        // Update Core Data
        storage.updateStatus(status, forId: id)
        // Update in-memory array so UI reacts immediately
        profiles = profiles.map { p in
            guard p.id == id else { return p }
            var copy = p
            copy.status = status
            return copy
        }
    }
}
