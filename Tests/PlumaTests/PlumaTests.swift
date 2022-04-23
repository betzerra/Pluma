import XCTest
@testable import Pluma

final class PlumaTests: XCTestCase {
    func testRequest() async throws {
        let client = MockClient(bundle: Bundle.module)
        let pluma = Pluma(client: client, decoder: Pluma.defaultDecoder())
        let shops: [Shop] = try await pluma.request(method: .GET, path: "shops", params: nil)

        XCTAssertEqual(shops.count, 2)

        let first = shops.first!
        XCTAssertEqual(first.id, 1)
        XCTAssertEqual(first.title, "Tres")
        XCTAssertEqual(first.hasDelivery, false)
        XCTAssertEqual(first.createdAt, Date(timeIntervalSince1970: 1650754012))
    }
}
