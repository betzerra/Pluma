import Foundation

enum PlumaError: Error {
    case badURL
    case emptyResponse
    case unexpected
}

public class Pluma {
    /// HTTP Methods
    public enum Method: String {
        case DELETE, GET, POST, PUT
    }

    let client: APIClient
    let decoder: JSONDecoder

    public init(baseURL: URL, decoder: JSONDecoder?) {
        self.client = HTTPClient(baseURL: baseURL)
        self.decoder = decoder ?? Self.defaultDecoder()
    }

    init(client: APIClient, decoder: JSONDecoder) {
        self.client = client
        self.decoder = decoder
    }

    public func request<T: Decodable>(
        method: Method,
        path: String,
        params: [String: String]?
    ) async throws -> T {

        let data = try await client.request(method: method, path: path, params: params)
        return try self.decoder.decode(T.self, from: data)
    }

    static func defaultDecoder() -> JSONDecoder {
        let aDecoder = JSONDecoder()
        let dateFormatter = defaultDateFormatter()

        aDecoder.keyDecodingStrategy = .convertFromSnakeCase
        aDecoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)

            dateFormatter.date(from: dateString)
            if let date = dateFormatter.date(from: dateString) {
                return date
            }

            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Cannot decode date string \(dateString)"
            )
        }
        return aDecoder
    }
    

    static func defaultDateFormatter() -> ISO8601DateFormatter {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }
}
