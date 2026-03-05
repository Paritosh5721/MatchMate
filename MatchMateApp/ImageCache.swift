import UIKit
import Combine

final class ImageCache: ImageCacheProtocol, ObservableObject {
    @Published private(set) var image: UIImage?

    private static let cache = NSCache<NSString, UIImage>()
    private var task: AnyCancellable?

    func fetch(url: String) {
        if let hit = Self.cache.object(forKey: url as NSString) {
            image = hit; return
        }
        guard let u = URL(string: url) else { return }
        task = URLSession.shared.dataTaskPublisher(for: u)
            .compactMap { UIImage(data: $0.data) }
            .replaceError(with: UIImage())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] img in
                Self.cache.setObject(img, forKey: url as NSString)
                self?.image = img
            }
    }

    func cancel() { task?.cancel() }
}
