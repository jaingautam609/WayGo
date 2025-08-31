import Foundation

enum APIService {
    // Paste your ngrok HTTPS URL here (no trailing slash)
    static let baseURL = "https://ddf1a83d1e28.ngrok-free.app"

    static func healthCheck() async -> Bool {
        guard let url = URL(string: "\(baseURL)/health") else { return false }
        do {
            let (_, resp) = try await URLSession.shared.data(from: url)
            return (resp as? HTTPURLResponse)?.statusCode == 200
        } catch {
            return false
        }
    }
}
