import XCTest
@testable import Test

class JokeRepositoryMock: JokeRepository {
    
    var returnValue: [Joke]!
    var randomJoke: Joke!
    
    var error: Error?
    
    var getJokesCalled = false
    var loadJokesCalled = false
    
    func getJokes() async throws -> [Joke] {
        getJokesCalled = true
        return try mockFunc()
    }
    
    func loadRandomJoke() async throws -> Joke {
        if let error {
            throw error
        }
        
        return randomJoke
    }
    
    func loadNewJokes() async throws -> [Joke] {
        loadJokesCalled = true
        return try mockFunc()
    }
    
    private func mockFunc() throws -> [Joke] {
        if let error {
            throw error
        }
        
        return returnValue
    }
}
