import XCTest
@testable import Test

class JokeStorageMock: JokeStorage {
    
    var jokes = [JokeDAO]()
    
    func save(model: JokeDAO) throws {
        jokes.append(model)
    }
    
    func save(models: [JokeDAO]) throws {
        jokes.append(contentsOf: models)
    }
    
    func findById(id: Int) throws -> JokeDAO? {
        jokes.first(where: { $0.id == id })
    }
    
    func findAll() throws -> [JokeDAO] {
        jokes
    }
}
