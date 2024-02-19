import XCTest
import SwiftData
@testable import Test

final class JokeRepositoryTests: XCTestCase {
    
    private var repository: JokeRepository!
    private var jokeAPIService: JokeAPIServiceMock!
    private var jokeStorage: JokeStorageMock!
    
    override func setUp() async throws {
        jokeAPIService = JokeAPIServiceMock()
        jokeStorage = JokeStorageMock()
        
        repository = JokeRepositoryImplementation(
            jokeAPIService: jokeAPIService,
            jokeStorage: jokeStorage
        )
    }
    
    func testPreSavedJokes() async throws {
        jokeStorage.jokes = (0..<5).map(JokeDAO.random)

        let result = try await repository.getJokes()
        XCTAssertEqual(result.count, 5)
    }
    
    func testLoadingNewJokes() async throws {
        jokeStorage.jokes = (0..<5).map(JokeDAO.random)
        jokeAPIService.returnValue = (5..<15).map(JokeDTO.random)
        
        let result = try await repository.loadNewJokes()
        XCTAssertEqual(result.count, 15)
    }
    
    func testRandomJoke() async throws {
        let storageJokes = (0..<5).map(JokeDAO.random)
        let apiJokes = (5..<15).map(JokeDTO.random)
        
        jokeStorage.jokes = storageJokes
        jokeAPIService.returnValue = apiJokes
        
        let randomJoke = try await repository.loadRandomJoke()
        XCTAssertTrue(apiJokes.contains(where: { $0.id == randomJoke.id }))
        XCTAssertFalse(storageJokes.contains(where: { $0.id == randomJoke.id }))
    }
    
    func testRandomJokeWithoutInternetConnection() async throws {
        let storageJokes = (0..<5).map(JokeDAO.random)
        
        jokeStorage.jokes = storageJokes
        jokeAPIService.error = NetworkError.noInternetConnection
        
        let randomJoke = try await repository.loadRandomJoke()
        XCTAssertTrue(storageJokes.contains(where: { $0.id == randomJoke.id }))
    }
    
    func testRandomJokeWithoutInternetConnectionAndNoStoredJoke() async {
        do {
            jokeStorage.jokes = []
            jokeAPIService.error = NetworkError.noInternetConnection
            
            _ = try await repository.loadRandomJoke()
            XCTFail("If API called failed and no items are saved should throw error")
        } catch {
            XCTAssertEqual(error as? JokeRepositoryError, JokeRepositoryError.empty)
        }
    }
}

private extension JokeDAO {
    static func random(int: Int) -> JokeDAO {
        .init(type: "", setup: "", punchline: "", id: int)
    }
}

private extension JokeDTO {
    static func random(int: Int) -> JokeDTO {
        .init(type: "", setup: "", punchline: "", id: int)
    }
}
