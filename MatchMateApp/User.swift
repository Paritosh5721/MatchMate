import Foundation

struct User: Codable, Identifiable {
    let id: Int
    let name: String
    let email: String
    let phone: String
    let address: Address
    let company: Company

    struct Address: Codable {
        let city: String
    }

    struct Company: Codable {
        let name: String
    }
}

enum MatchStatus: String {
    case pending, accepted, declined
}

struct MatchProfile: Identifiable {
    let id: Int
    let name: String
    let city: String
    let company: String
    let email: String
    var status: MatchStatus

    var photoURL: String {
        "https://randomuser.me/api/portraits/\(id % 2 == 0 ? "women" : "men")/\(id).jpg"
    }

    init(user: User, status: MatchStatus = .pending) {
        self.id      = user.id
        self.name    = user.name
        self.city    = user.address.city
        self.company = user.company.name
        self.email   = user.email
        self.status  = status
    }

    // init from Core Data entity
    init(entity: UserEntity) {
        self.id      = Int(entity.id)
        self.name    = entity.name ?? ""
        self.city    = entity.city ?? ""
        self.company = entity.company ?? ""
        self.email   = entity.email ?? ""
        self.status  = MatchStatus(rawValue: entity.status ?? "") ?? .pending
    }
}
