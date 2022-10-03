//
//  MockClient.swift
//  
//
//  Created by Ezequiel Becerra on 23/04/2022.
//

import Foundation

public class MockClient: APIClient {
    let bundle: Bundle

    /// Can "force" a response by assigning this property.
    ///
    /// - Note:
    /// If it's nil then it will look for a file and return its content.
    public var forcedResponse: Data?

    public init(bundle: Bundle) {
        self.bundle = bundle
    }

    func request(file: String) throws -> Data {
        let path = bundle.path(forResource: file, ofType: "json")
        let url = URL(fileURLWithPath: path!)
        return try Data(contentsOf: url)
    }

    private static func filename(method: Pluma.Method, path: String) -> String {
        var escapedPath = path.replacingOccurrences(of: "/", with: "_")
        escapedPath = escapedPath.replacingOccurrences(of: ".json", with: "")

        return "\(method.rawValue)_\(escapedPath)"
    }

    func request(
        method: Pluma.Method,
        path: String,
        params: [String : String]?
    ) async throws -> Data {
        if let data = forcedResponse {
            return data
        }

        let filename = MockClient.filename(method: method, path: path)
        return try request(file: filename)
    }
}
