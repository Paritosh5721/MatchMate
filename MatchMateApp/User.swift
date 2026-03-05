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
        id       = user.id
        name     = user.name
        city     = user.address.city
        company  = user.company.name
        email    = user.email
        self.status = status
    }
}
