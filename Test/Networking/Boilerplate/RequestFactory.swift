import Foundation

protocol RequestFactory {
    func makeURLRequest(for request: HTTPRequest) throws -> URLRequest
}

final class HTTPRequestFactory: RequestFactory {

    init() { }

    func makeURLRequest(for request: HTTPRequest) throws -> URLRequest {
        guard let url = makeURL(for: request) else {
            throw NetworkError.createRequest
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue

        if let headers = request.headers {
            headers.forEach { urlRequest.setValue($0.value, forHTTPHeaderField: $0.key) }
        }

        if let bodyParams = request.bodyParams {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: bodyParams)
        } else if let bodyData = request.bodyData {
            urlRequest.httpBody = bodyData
        }

        return urlRequest
    }

    private func makeURL(for request: HTTPRequest) -> URL? {
        guard var url = URL(string: request.host) else {
            return nil
        }

        url.appendPathComponent(request.path)

        if let queryParams = request.queryParams {
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
            urlComponents?.queryItems = queryParams.map { URLQueryItem(name: "\($0)", value: "\($1)") }
            if let newUrl = urlComponents?.url {
                url = newUrl
            }
        }

        return url
    }
}
