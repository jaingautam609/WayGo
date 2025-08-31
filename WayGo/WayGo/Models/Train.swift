import Foundation

struct Train: Identifiable, Hashable {
    let id = UUID()
    let trainName: String
    let trainNo: String
    let from: String
    let to: String
    let departTime: String
    let arriveTime: String
    let duration: String
    let price: Int
}

let demoTrains: [Train] = [
    .init(trainName: "Shatabdi", trainNo: "12001", from: "DEL", to: "AGC",
          departTime: "06:00", arriveTime: "08:00", duration: "2h", price: 18),
    .init(trainName: "Rajdhani", trainNo: "12952", from: "BOM", to: "DEL",
          departTime: "16:45", arriveTime: "08:35", duration: "15h 50m", price: 40)
]
