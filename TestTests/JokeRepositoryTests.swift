import XCTest
import SwiftData
@testable import Test

final class JokeRepositoryTests: XCTestCase {
    
    private var repository: JokeRepository!
    private var jokeAPIService: JokeAPIServiceMock!
    private var jokeStorage: JokeStorage!
    private var container: ModelContainer!
    
    override func setUp() async throws {
        container = try! ModelContainer(
            for: JokeDAO.self,
            configurations: .init(isStoredInMemoryOnly: true)
        )
        
        jokeAPIService = JokeAPIServiceMock()
        jokeStorage = JokeStorageImplentation(modelContainer: container)
        
        repository = JokeRepositoryImplementation(
            jokeAPIService: jokeAPIService,
            jokeStorage: jokeStorage
        )
    }
    
    func testPreSavedJokes() async throws {
        for _ in 0..<5 {
            await container.mainContext.insert(JokeDAO.random())
        }
        
        let result = try await repository.getJokes()
        XCTAssertEqual(result.count, 5)
    }
    
    func testLoadingNewJokes() async throws {
        for _ in 0..<5 {
            await container.mainContext.insert(JokeDAO.random())
        }
        jokeAPIService.returnValue = [JokeDTO](repeating: .random(), count: 10)
        let result = try await repository.loadJokes(number: 10)
        XCTAssertEqual(result.count, 15)
    }
    
    func testLoadingDuplicate() async throws {
        var dto = [JokeDTO]()
        for id in 0..<5 {
            await container.mainContext.insert(JokeDAO.random(id: id))
            dto.append(.random(id: id))
        }
        let daad = [JokeDTO](repeating: .random(), count: 5)
        dto.append(contentsOf: daad)
        jokeAPIService.returnValue = dto
        let result = try await repository.loadJokes(number: 10)
        XCTAssertEqual(result.count, 10)
    }
}

private extension JokeDAO {
    static func random(id: Int? = nil) -> JokeDAO {
        .init(type: "", setup: "", punchline: "", id: id ?? .random(in: 0...100))
    }
}

private extension JokeDTO {
    static func random(id: Int? = nil) -> JokeDTO {
        .init(type: "", setup: "", punchline: "", id: id ?? .random(in: 100...200))
    }
}
