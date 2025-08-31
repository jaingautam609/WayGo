import Foundation

enum AuthError: LocalizedError {
    case badStatus(Int)
    case decoding
    case network(Error)
    case message(String)

    var errorDescription: String? {
        switch self {
        case .badStatus(let code): return "Server error (\(code))."
        case .decoding: return "Could not read server response."
        case .network(let err): return err.localizedDescription
        case .message(let msg): return msg
        }
    }
}

final class AuthService {
    static let shared = AuthService()
    private init() {}

    private var baseURL: String { APIService.baseURL } // reuse your API base

    func signup(_ body: SignupRequest) async throws -> AuthResponse {
        try await request(path: "/signup", body: body)
    }

    func login(_ body: LoginRequest) async throws -> AuthResponse {
        try await request(path: "/login", body: body)
    }

    private func request<T: Codable, R: Codable>(path: String, body: T) async throws -> R {
        guard let url = URL(string: baseURL + path) else { throw AuthError.message("Bad URL") }
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try JSONEncoder().encode(body)

        do {
            let (data, resp) = try await URLSession.shared.data(for: req)
            guard let http = resp as? HTTPURLResponse else { throw AuthError.decoding }
            guard (200..<300).contains(http.statusCode) else {
                // try to read server message
                if let msg = String(data: data, encoding: .utf8), !msg.isEmpty {
                    throw AuthError.message(msg)
                }
                throw AuthError.badStatus(http.statusCode)
            }
            do {
                return try JSONDecoder().decode(R.self, from: data)
            } catch {
                throw AuthError.decoding
            }
        } catch {
            throw AuthError.network(error)
        }
    }
}
