import Foundation

struct JokeListViewModelState {
    enum DataState: Equatable {
        case data([Joke])
        case empty
        case initiating
    }

    var dataState: DataState = .initiating
    var error: String?
    var isLoading = false
}

@Observable
class JokeListViewModel {
    private let jokeRepository: JokeRepository
    private let navigationState: JokeNavigationState

    var state = JokeListViewModelState()

    init(jokeRepository: JokeRepository, navigationState: JokeNavigationState) {
        self.jokeRepository = jokeRepository
        self.navigationState = navigationState
    }

    func didSelectJoke(joke: Joke) {
        navigationState.routes.append(joke)
    }

    func loadRandomJoke() async {
        do {
            try await jokeRepository.loadRandomJoke()
            await fetchJokes()
        } catch {
            state.error = error.localizedDescription
        }
    }

    func fetchJokes() async {
        state.isLoading = true
        defer {
            state.isLoading = false
        }
        do {
            let jokes = try await jokeRepository.loadJokes(number: 10)
            state.dataState = .data(jokes)
        } catch {
            state.error = error.localizedDescription
        }
    }

    func prepare() async {
        do {
            let jokes = try await jokeRepository.getJokes()
            if !jokes.isEmpty {
                state.dataState = .data(jokes)
            } else {
                state.dataState = .empty
            }
        } catch {
            state.dataState = .empty
        }
    }
}
