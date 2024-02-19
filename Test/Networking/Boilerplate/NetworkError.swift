import Foundation

enum NetworkError: Error {
    case createRequest
    case response

    case resourceNotFound
    case internalError
    case dataNotReady

    case timedOut
    case noConnectionToHost
    case noInternetConnection

    case unknown
}
