import XCTest
@testable import Test

class JokeRepositoryMock: JokeRepository {
    
    var returnValue: [Joke]!
    var error: Error?
    
    var getJokesCalled = false
    var loadJokesCalled = false
    
    func getJokes() async throws -> [Joke] {
        getJokesCalled = true
        return try mockFunc()
    }
    
    func loadRandomJoke() async throws -> Joke {
        try mockFunc().first!
    }
    
    func loadJokes(number: Int) async throws -> [Joke] {
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
