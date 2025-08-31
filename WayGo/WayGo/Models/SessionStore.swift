import Foundation

@MainActor
final class SessionStore: ObservableObject {
    @Published var token: String? {
        didSet { persist() }
    }

    init() {
        token = UserDefaults.standard.string(forKey: "auth.token")
    }

    private func persist() {
        if let t = token {
            UserDefaults.standard.set(t, forKey: "auth.token")
        } else {
            UserDefaults.standard.removeObject(forKey: "auth.token")
        }
    }

    func logout() {
        token = nil
    }
}
