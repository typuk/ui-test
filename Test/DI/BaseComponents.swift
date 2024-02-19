import Foundation
import SwiftData

class BaseComponents {

    static let shared = BaseComponents()

    private lazy var networkDispatcher: NetworkDispatcher = {
        let sender = URLDataSender()
        let responseParser = ResponseParserImplementation()
        let requestFactory = HTTPRequestFactory()
        return NetworkDispatcherImplementation(dependencies: (sender, responseParser, requestFactory))
    }()

    private lazy var jokeStorage = JokeStorageImplentation(modelContainer: sharedModelContainer)
    private lazy var jokeAPIService = JokeAPIServiceImplementation(dispatcher: networkDispatcher)

    lazy var jokeRepository = JokeRepositoryImplementation(jokeAPIService: jokeAPIService, jokeStorage: jokeStorage)

    let sharedModelContainer: ModelContainer = {
        let schema = Schema([
            JokeDAO.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var navigationState = JokeNavigationState()
}
