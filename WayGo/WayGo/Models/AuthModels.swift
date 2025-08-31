import Foundation

struct SignupRequest: Codable {
    let email: String
    let password: String
    let displayName: String
}

struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct AuthResponse: Codable {
    let token: String        // JWT access token from your backend
    let userId: String?      // optional
    let email: String?
}
