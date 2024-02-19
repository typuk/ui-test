import Foundation

protocol DataSender {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

class URLDataSender: DataSender {
    private let urlSession: URLSession

    init() {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 60.0
        sessionConfig.timeoutIntervalForResource = 60.0

        urlSession = URLSession(configuration: sessionConfig)
    }

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        try await urlSession.data(for: request)
    }
}
