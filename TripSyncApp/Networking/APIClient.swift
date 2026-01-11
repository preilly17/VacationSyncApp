import Foundation

struct APIClient {
    let session: URLSession
    let baseURL: URL

    init(session: URLSession = .shared) throws {
        let key = "API_BASE_URL"
        guard let baseURLString = Bundle.main.object(forInfoDictionaryKey: key) as? String,
              !baseURLString.isEmpty else {
            throw APIError.missingConfiguration(key)
        }
        guard let baseURL = URL(string: baseURLString) else {
            throw APIError.invalidBaseURL(baseURLString)
        }
        self.session = session
        self.baseURL = baseURL
    }

    func request<T: Decodable>(_ path: String, method: String = "GET") async throws -> T {
        guard let url = URL(string: path, relativeTo: baseURL) else {
            throw APIError.invalidURL(path)
        }
        var request = URLRequest(url: url)
        request.httpMethod = method

        do {
            let (data, response) = try await session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            guard (200..<300).contains(httpResponse.statusCode) else {
                throw APIError.httpStatus(httpResponse.statusCode, data)
            }
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw APIError.decoding(error)
            }
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.transport(error)
        }
    }
}
