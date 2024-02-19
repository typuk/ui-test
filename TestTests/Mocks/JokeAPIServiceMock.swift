import XCTest
@testable import Test

class JokeAPIServiceMock: JokeAPIService {

    var returnValue: [JokeDTO]!
    var error: Error?
    
    var getRandomJokeCalled = false
    var getTenJokesCalled = false
    
    func getRandomJoke() async throws -> JokeDTO {
        getTenJokesCalled = true
        return try mockFunc().first!
    }
    
    func getTenJokes() async throws -> [JokeDTO] {
        getTenJokesCalled = true
        return try mockFunc()
    }
    private func mockFunc() throws -> [JokeDTO] {
        if let error {
            throw error
        }
        
        return returnValue
    }
}
