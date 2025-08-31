import Foundation

struct Flight: Identifiable, Hashable {
    let id = UUID()
    let airline: String
    let flightNo: String
    let from: String
    let to: String
    let departTime: String   // "10:25"
    let arriveTime: String   // "12:05"
    let duration: String     // "1h 40m"
    let price: Int
}

let demoFlights: [Flight] = [
    .init(airline: "Air India", flightNo: "AI803", from: "DEL", to: "BOM",
          departTime: "10:25", arriveTime: "12:40", duration: "2h 15m", price: 120),
    .init(airline: "IndiGo", flightNo: "6E2154", from: "DEL", to: "BOM",
          departTime: "14:10", arriveTime: "16:25", duration: "2h 15m", price: 95),
    .init(airline: "Vistara", flightNo: "UK943", from: "DEL", to: "BLR",
          departTime: "09:30", arriveTime: "12:05", duration: "2h 35m", price: 110),
]
