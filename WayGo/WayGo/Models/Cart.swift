import Foundation

struct CartItem: Identifiable, Hashable {
    enum Kind: String {
        case tour, flight, train, hotel, airbnb, villa, cab
    }

    let id = UUID()
    let kind: Kind

    let title: String        // e.g. "DEL → BOM" or "Hotel Grand Plaza"
    let subtitle: String     // e.g. "AI803 • 10:25–12:40" or "3 nights • Kyoto"
    let unitPrice: Int       // base price per adult
    var adults: Int          // used as guest count / seat count
    var kids: Int            // 50% of unit price

    var total: Int {
        let a = unitPrice * adults
        let k = Int(Double(unitPrice) * 0.5) * kids
        return a + k
    }
}

final class CartStore: ObservableObject {
    @Published var items: [CartItem] = []

    var count: Int { items.count }
    var total: Int { items.reduce(0) { $0 + $1.total } }

    func clear() { items.removeAll() }
    func remove(_ item: CartItem) { items.removeAll { $0.id == item.id } }

    // -------- Add methods for all supported booking types --------
    func addTour(_ pkg: TravelPackage, adults: Int, kids: Int) {
        items.append(.init(kind: .tour,
                           title: pkg.title,
                           subtitle: "\(pkg.placeName) • \(pkg.days) nights",
                           unitPrice: pkg.price, adults: adults, kids: kids))
    }

    func addFlight(_ f: Flight, adults: Int, kids: Int) {
        items.append(.init(kind: .flight,
                           title: "\(f.from) → \(f.to)",
                           subtitle: "\(f.airline) \(f.flightNo) • \(f.departTime)–\(f.arriveTime)",
                           unitPrice: f.price, adults: adults, kids: kids))
    }

    func addTrain(_ t: Train, adults: Int, kids: Int) {
        items.append(.init(kind: .train,
                           title: "\(t.from) → \(t.to)",
                           subtitle: "\(t.trainName) \(t.trainNo) • \(t.departTime)–\(t.arriveTime)",
                           unitPrice: t.price, adults: adults, kids: kids))
    }

    func addStay(_ s: Stay, adults: Int, kids: Int) {
        let kind: CartItem.Kind = {
            switch s.kind {
            case .hotel: return .hotel
            case .airbnb: return .airbnb
            case .villa: return .villa
            }
        }()
        items.append(.init(kind: kind,
                           title: s.name,
                           subtitle: "\(s.city) • \(s.nights) nights",
                           unitPrice: s.pricePerNight,
                           adults: adults, kids: kids))
    }

    func addCab(_ c: CabRide, adults: Int, kids: Int) {
        items.append(.init(kind: .cab,
                           title: "\(c.from) → \(c.to)",
                           subtitle: "\(c.provider) • \(c.carType)",
                           unitPrice: c.price,
                           adults: adults, kids: kids))
    }
}
