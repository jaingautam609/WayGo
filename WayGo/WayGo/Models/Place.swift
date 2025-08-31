import SwiftUI

struct Place: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let countryCode: String
    let countryName: String
    let rating: Double
    let reviews: Int
    let images: [String]
    let blurb: String
}
