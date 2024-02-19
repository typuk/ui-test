import Foundation
import SwiftData

protocol JokeStorage: Actor {
    func save(model: JokeDAO) throws
    func save(models: [JokeDAO]) throws
    func findById(id: Int) throws -> JokeDAO?
    func findAll() throws -> [JokeDAO]
}

@ModelActor
actor JokeStorageImplentation: JokeStorage {

    func save(models: [JokeDAO]) throws {
        models.forEach { modelContext.insert($0) }
    }

    func save(model: JokeDAO) throws {
        modelContext.insert(model)
    }

    func findById(id: Int) throws -> JokeDAO? {
        let descriptor = FetchDescriptor<JokeDAO>(
            predicate: #Predicate {
            $0.id == id
        })

        return try modelContext.fetch(descriptor).first
    }

    func findAll() throws -> [JokeDAO] {
        let descriptor = FetchDescriptor<JokeDAO>(sortBy: [SortDescriptor(\.id)])
        return try modelContext.fetch(descriptor)
    }
}
