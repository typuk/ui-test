import Foundation

enum RandomJokeRequest: HTTPRequest {
    case random
    case tenRandom
    case byIdentifier(String)
    case byType(String)

    var host: String {
        "https://official-joke-api.appspot.com/"
    }

    var path: String {
        switch self {
        case .random:
            return "jokes/random"
        case .byIdentifier(let identifier):
            return "jokes\(identifier)"
        case .byType(let type):
            return "jokes/\(type)/random"
        case .tenRandom:
            return "random_ten"
        }
    }

    var method: HTTPMethod {
        .get
    }
}
