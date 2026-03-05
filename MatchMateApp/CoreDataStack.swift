import CoreData

final class CoreDataStack {
    static let shared = CoreDataStack()

    lazy var container: NSPersistentContainer = {
        let model = NSManagedObjectModel()

        let entity = NSEntityDescription()
        entity.name = "UserEntity"
        entity.managedObjectClassName = NSStringFromClass(UserEntity.self)

        func strAttr(_ name: String) -> NSAttributeDescription {
            let a = NSAttributeDescription()
            a.name = name
            a.attributeType = .stringAttributeType
            a.isOptional = true
            return a
        }

        let idAttr = NSAttributeDescription()
        idAttr.name = "id"
        idAttr.attributeType = .integer64AttributeType
        idAttr.isOptional = false

        entity.properties = [
            idAttr,
            strAttr("name"),
            strAttr("city"),
            strAttr("company"),
            strAttr("email"),
            strAttr("status"),
        ]
        model.entities = [entity]

        let c = NSPersistentContainer(name: "MatchMate", managedObjectModel: model)
        c.loadPersistentStores { _, error in
            if let error { fatalError("CoreData load failed: \(error)") }
        }
        c.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        c.viewContext.automaticallyMergesChangesFromParent = true
        return c
    }()

    var ctx: NSManagedObjectContext { container.viewContext }

    func save() {
        guard ctx.hasChanges else { return }
        try? ctx.save()
    }
}

@objc(UserEntity)
public class UserEntity: NSManagedObject {
    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var city: String?
    @NSManaged public var company: String?
    @NSManaged public var email: String?
    @NSManaged public var status: String?
}
