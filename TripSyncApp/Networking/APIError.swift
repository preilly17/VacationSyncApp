import Foundation

enum APIError: Error, LocalizedError {
    case missingConfiguration(String)
    case invalidBaseURL(String)
    case invalidURL(String)
    case invalidResponse
    case httpStatus(Int, Data)
    case decoding(Error)
    case transport(Error)

    var errorDescription: String? {
        switch self {
        case .missingConfiguration(let key):
            return "Missing configuration for \(key)."
        case .invalidBaseURL(let value):
            return "Invalid base URL: \(value)."
        case .invalidURL(let path):
            return "Invalid URL path: \(path)."
        case .invalidResponse:
            return "Invalid response from server."
        case .httpStatus(let statusCode, _):
            return "Unexpected status code: \(statusCode)."
        case .decoding(let error):
            return "Failed to decode response: \(error.localizedDescription)."
        case .transport(let error):
            return "Network transport error: \(error.localizedDescription)."
        }
    }
}
