import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case patch = "PATCH"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum HTTPHeaderKey: String {
    case accept = "Accept"
    case contentType = "Content-Type"
    case acceptLanguage = "Accept-Language"
    case bearerToken = "Authorization"
    case clientToken = "X-CLIENT-TOKEN"
    case deviceId = "Device-Id"
    case userAgent = "User-Agent"
}

enum HTTPHeaderValue: String {
    case appJson = "application/json"
    case appXWwwFormUrlEncoded = "application/x-www-form-urlencoded"
}

protocol HTTPRequest {
    var host: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var bodyParams: [String: Any]? { get }
    var bodyData: Data? { get }
    var queryParams: [String: Any]? { get }
    var headers: [String: String]? { get }
}

extension HTTPRequest {
    public var host: String? { return nil }
    public var method: HTTPMethod { .post }
    public var bodyParams: [String: Any]? { nil }
    public var bodyData: Data? { return nil }
    public var queryParams: [String: Any]? { nil }
    public var headers: [String: String]? { nil }
}
