import Foundation
import StripePaymentSheet

enum StripeService {
    static let publishableKey = "pk_test_51S26BHQPG63ow9LZwvnGqSXJhTD78ycLU6b220B84dSa7XaCMYPPNW6vtQiIfSwzpaUVdZHckmnMfk751Wc446xE00c2SwiGZc"
    static let currency = "usd" // or "inr"

    struct IntentResponse: Decodable { let clientSecret: String }

    private struct CreateIntentBody: Encodable {
        let amount: Int     // smallest unit (cents/paise)
        let currency: String
    }

    static func createPaymentIntent(amountCents: Int) async throws -> String {
        guard let url = URL(string: "\(APIService.baseURL)/api/payments/create-intent") else {
            throw URLError(.badURL)
        }
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = CreateIntentBody(amount: amountCents, currency: currency)
        req.httpBody = try JSONEncoder().encode(body)

        let (data, resp) = try await URLSession.shared.data(for: req)
        guard (resp as? HTTPURLResponse)?.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        let decoded = try JSONDecoder().decode(IntentResponse.self, from: data)
        return decoded.clientSecret
    }
}
