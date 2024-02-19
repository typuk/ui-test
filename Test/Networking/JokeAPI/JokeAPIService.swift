import Foundation
import SwiftData

protocol JokeAPIService {
    func getRandomJoke() async throws -> JokeDTO
    func getTenJokes() async throws -> [JokeDTO]
}

final class JokeAPIServiceImplementation: JokeAPIService {

    private let dispatcher: NetworkDispatcher

    init(dispatcher: NetworkDispatcher) {
        self.dispatcher = dispatcher
    }

    func getRandomJoke() async throws -> JokeDTO {
        try await dispatcher.fetch(with: RandomJokeRequest.random)
    }

    func getTenJokes() async throws -> [JokeDTO] {
        try await dispatcher.fetch(with: RandomJokeRequest.tenRandom)
    }
}
