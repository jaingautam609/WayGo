import Foundation

enum PackageCategory: String, CaseIterable, Codable {
    case budget = "Budget"
    case couple = "Couple"
    case family = "Family"
    case longStay = "Long stay"
}

struct TravelPackage: Identifiable, Hashable, Codable {
    let id = UUID()
    let countryCode: String       // e.g., "BR"
    let placeName: String         // e.g., "Rio de Janeiro"
    let title: String
    let days: Int
    let price: Int                // any currency for demo
    let rating: Double
    let imageName: String
    let highlights: [String]
    let category: PackageCategory
}
