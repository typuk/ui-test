import Foundation

protocol JokeRepository {
    func getJokes() async throws -> [Joke]

    @discardableResult
    func loadRandomJoke() async throws -> Joke
    @discardableResult
    func loadJokes(number: Int) async throws -> [Joke]
}

class JokeRepositoryImplementation: JokeRepository {
    let jokeAPIService: JokeAPIService
    let jokeStorage: JokeStorage

    init(jokeAPIService: JokeAPIService, jokeStorage: JokeStorage) {
        self.jokeAPIService = jokeAPIService
        self.jokeStorage = jokeStorage
    }

    func getJokes() async throws -> [Joke] {
        try await jokeStorage.findAll().map(JokeMapper.mapDAO)
    }

    @discardableResult
    func loadRandomJoke() async throws -> Joke {
        let randomJoke = try await jokeAPIService.getRandomJoke()
        let joke = JokeMapper.mapDTO(randomJoke)
        try await jokeStorage.save(model: joke)
        return JokeMapper.mapDAO(joke)
    }

    @discardableResult
    func loadJokes(number: Int) async throws -> [Joke] {
        let jokes = try await jokeAPIService.getTenJokes().map(JokeMapper.mapDTO)
        try await jokeStorage.save(models: jokes)
        return try await jokeStorage.findAll().map(JokeMapper.mapDAO)
    }
}
