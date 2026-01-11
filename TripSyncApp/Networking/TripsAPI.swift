import Foundation

struct TripsAPI {
    private let client: APIClient

    init(client: APIClient = try APIClient()) throws {
        self.client = client
    }

    func fetchTrips() async throws -> [TripCalendar] {
        try await client.request("/api/trips")
    }
}
