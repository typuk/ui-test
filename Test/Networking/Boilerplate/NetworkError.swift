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
    
    init(with error: Error) {
        switch (error as NSError).code {
        case NSURLErrorCannotConnectToHost:
            self = .noConnectionToHost
        case NSURLErrorNetworkConnectionLost, NSURLErrorNotConnectedToInternet:
            self = .noInternetConnection
        case NSURLErrorTimedOut:
            self = .timedOut
        default:
            self = .unknown
        }
    }
}
