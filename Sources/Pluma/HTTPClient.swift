//
//  HTTPClient.swift
//  
//
//  Created by Ezequiel Becerra on 23/04/2022.
//

import Foundation

class HTTPClient {
    let baseURL: URL

    init(baseURL: URL) {
        self.baseURL = baseURL
    }
}

extension HTTPClient: APIClient {
    func request(
        method: Pluma.Method,
        path: String,
        params: [String : String]?
    ) async throws -> Data {
        guard let url = HTTPClient.URL(url: baseURL, path: path, params: params) else {
            throw PlumaError.badURL
        }

        return try await URLSession.shared.data(from: url).0
    }

    /// Static function for url construction
    /// - Parameters:
    ///   - url: URL value for base url
    ///   - path: string value for url path
    ///   - params: optional array of key/values of string type
    /// - Returns: a parsed URL with the above params
    static func URL(url: URL, path: String, params: [String: String]?) -> URL? {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)

        let composedPath = url.appendingPathComponent(path).path
        components?.path = composedPath

        if let p = params {
            components?.percentEncodedQueryItems = p.map { URLQueryItem(name: $0, value: $1) }
        }

        return components?.url
    }
}
