import Foundation

struct CabRide: Identifiable, Hashable {
    let id = UUID()
    let provider: String       // "Uber", "Ola", "Local"
    let carType: String        // "Sedan", "SUV"
    let from: String
    let to: String
    let price: Int
    let eta: String            // "8 min"
}

let demoCabs: [CabRide] = [
    .init(provider: "Local", carType: "Sedan", from: "Airport", to: "City Center", price: 25, eta: "8 min"),
    .init(provider: "Local", carType: "SUV",   from: "City Center", to: "Beach",   price: 35, eta: "5 min")
]
