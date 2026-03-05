import CoreData

final class StorageService: StorageServiceProtocol {
    static let shared = StorageService()
    private let db = CoreDataStack.shared

    // Save API users — preserves existing status if user already exists
    func save(_ profiles: [MatchProfile]) {
        profiles.forEach { profile in
            let entity = findEntity(id: profile.id) ?? UserEntity(context: db.ctx)
            entity.id      = Int64(profile.id)
            entity.name    = profile.name
            entity.city    = profile.city
            entity.company = profile.company
            entity.email   = profile.email
            // only set status if this is a new record
            if entity.status == nil || entity.status == "" {
                entity.status = MatchStatus.pending.rawValue
            }
        }
        db.save()
    }

    func loadAll() -> [MatchProfile] {
        let req = NSFetchRequest<UserEntity>(entityName: "UserEntity")
        req.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        let entities = (try? db.ctx.fetch(req)) ?? []
        return entities.map { MatchProfile(entity: $0) }
    }

    func updateStatus(_ status: MatchStatus, forId id: Int) {
        guard let entity = findEntity(id: id) else { return }
        entity.status = status.rawValue
        db.save()
    }

    private func findEntity(id: Int) -> UserEntity? {
        let req = NSFetchRequest<UserEntity>(entityName: "UserEntity")
        req.predicate = NSPredicate(format: "id == %d", id)
        req.fetchLimit = 1
        return try? db.ctx.fetch(req).first
    }
}
