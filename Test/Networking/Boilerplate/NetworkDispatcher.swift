import Foundation

protocol NetworkDispatcher {
    func send(_ request: HTTPRequest) async throws
    func fetch<Model: Decodable>(with request: HTTPRequest) async throws -> Model
}

final class NetworkDispatcherImplementation: NetworkDispatcher {

    typealias Dependencies = (
        sender: DataSender,
        responseParser: ResponseParser,
        requestFactory: RequestFactory
    )

    private let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func send(_ request: HTTPRequest) async throws {
        try await performNetworkRequest(request)
    }

    func fetch<Model: Decodable>(with request: HTTPRequest) async throws -> Model {
        let data = try await performNetworkRequest(request)
        return try dependencies.responseParser.parseDataToModel(data: data)
    }
}

private extension NetworkDispatcherImplementation {

    @discardableResult func performNetworkRequest(_ httpRequest: HTTPRequest) async throws -> Data {
        do {
            let request = try dependencies.requestFactory.makeURLRequest(for: httpRequest)
            
            let (data, response) = try await dependencies.sender.data(for: request)
            let httpResponse = response as! HTTPURLResponse // swiftlint:disable:this force_cast
            
            switch httpResponse.statusCode {
            case 200..<300:
                return data
            case 404:
                throw NetworkError.resourceNotFound
            case 500:
                throw NetworkError.internalError
            default:
                throw NetworkError.unknown
            }
        } catch {
            throw NetworkError(with: error)
        }
    }
}
