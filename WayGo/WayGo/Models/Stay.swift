import Foundation

enum StayKind: String, CaseIterable { case hotel = "Hotel", airbnb = "Airbnb", villa = "Villa" }

struct Stay: Identifiable, Hashable {
    let id = UUID()
    let kind: StayKind
    let name: String
    let city: String
    let nights: Int
    let pricePerNight: Int
    let rating: Double
}

let demoStays: [Stay] = [
    .init(kind: .hotel,  name: "Grand Plaza",   city: "Kyoto", nights: 3, pricePerNight: 120, rating: 4.5),
    .init(kind: .airbnb, name: "Old Town Loft", city: "Paris", nights: 2, pricePerNight: 90,  rating: 4.4),
    .init(kind: .villa,  name: "Seaside Villa", city: "Goa",   nights: 4, pricePerNight: 150, rating: 4.6)
]
