import Foundation

enum JokeRepositoryError: Error {
    case empty
}

protocol JokeRepository {
    func getJokes() async throws -> [Joke]

    func loadRandomJoke() async throws -> Joke
    func loadNewJokes() async throws -> [Joke]
}

class JokeRepositoryImplementation: JokeRepository {
    let jokeAPIService: JokeAPIService
    let jokeStorage: JokeStorage

    init(jokeAPIService: JokeAPIService, jokeStorage: JokeStorage) {
        self.jokeAPIService = jokeAPIService
        self.jokeStorage = jokeStorage
    }

    /**
     Asynchronously retrieves all jokes from persistent storage and maps them to `Joke` model objects.

     - Returns: An array of `Joke` objects representing all jokes retrieved from persistent storage.
     - Throws: An error if any operation encounters an error, such as a storage error.
     */
    func getJokes() async throws -> [Joke] {
        try await jokeStorage.findAll().map(JokeMapper.mapDAO)
    }

    /**
     Asynchronously loads a random joke from the joke API service. If the device has no internet connection, it retrieves a random joke from persistent storage.

     - Returns: A `Joke` object representing the loaded random joke.
     - Throws:
        - `NetworkError.noInternetConnection`: If the device has no internet connection and there are no jokes saved in persistent storage.
        - Any other error encountered during the operation.
     */
    func loadRandomJoke() async throws -> Joke {
        do {
            let randomJoke = try await jokeAPIService.getRandomJoke()
            let joke = JokeMapper.mapDTO(randomJoke)
            
            try await jokeStorage.save(model: joke)
            return JokeMapper.mapDAO(joke)
        } catch NetworkError.noInternetConnection {
            let allJokes = try await jokeStorage.findAll().map(JokeMapper.mapDAO)
            if let randomJoke = allJokes.randomElement() {
                return randomJoke
            } else {
                throw JokeRepositoryError.empty
            }
        } catch {
            throw error
        }
    }

    /**
     Asynchronously loads ten new jokes from the joke API service, saves them to persistent storage, and returns all jokes that have been saved.

     - Returns: An array of `Joke` objects representing all jokes that have been saved, including the newly loaded ones.
     - Throws: An error if any operation encounters an error, such as network error, API failure, or storage error.
     */
    func loadNewJokes() async throws -> [Joke] {
        let jokes = try await jokeAPIService.getTenJokes().map(JokeMapper.mapDTO)
        try await jokeStorage.save(models: jokes)
        return try await jokeStorage.findAll().map(JokeMapper.mapDAO)
    }
}
