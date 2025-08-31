import SwiftUI

struct CabSearchView: View {
    @EnvironmentObject var cart: CartStore
    @State private var from = "Airport"
    @State private var to = "City Center"
    @State private var results: [CabRide] = []
    @State private var chosen: CabRide? = nil

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                TextField("Pickup", text: $from)
                Text("→")
                TextField("Drop", text: $to)
            }
            .padding(14).background(Color(white:0.96)).clipShape(RoundedRectangle(cornerRadius: 12))

            Button("Search") { search() }
                .frame(maxWidth: .infinity).padding(12)
                .background(Color.black).foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))

            if results.isEmpty {
                Spacer(); Text("No results yet").foregroundColor(.gray); Spacer()
            } else {
                List {
                    ForEach(results) { c in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("\(c.from) → \(c.to)").font(.headline)
                                Spacer()
                                Text("$\(c.price)")
                            }.foregroundColor(.black)
                            Text("\(c.provider) • \(c.carType) • ETA \(c.eta)").foregroundColor(.gray)
                            HStack {
                                Spacer()
                                Button("Book") { chosen = c }
                                    .padding(.vertical, 6).padding(.horizontal, 12)
                                    .background(Color.black).foregroundColor(.white)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        .sheet(item: $chosen) { c in
            AddCabToCartSheet(ride: c).presentationDetents([.height(300), .large])
        }
    }

    func search() {
        let f = from.trimmingCharacters(in: .whitespaces).lowercased()
        let t = to.trimmingCharacters(in: .whitespaces).lowercased()
        results = demoCabs.filter {
            (f.isEmpty || $0.from.lowercased().contains(f)) &&
            (t.isEmpty || $0.to.lowercased().contains(t))
        }
        if results.isEmpty { results = demoCabs }
    }
}

struct AddCabToCartSheet: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var cart: CartStore
    let ride: CabRide
    @State private var adults = 1
    @State private var kids = 0

    var body: some View {
        VStack(spacing: 14) {
            Text("Book cab: \(ride.from) → \(ride.to)").font(.headline)
            HStack {
                Stepper("Adults: \(adults)", value: $adults, in: 1...6)
                Stepper("Kids: \(kids)", value: $kids, in: 0...6)
            }
            Text("Fare: $\(ride.price)").font(.title3.bold())
            Button("Add to cart") {
                cart.addCab(ride, adults: adults, kids: kids)
                dismiss()
            }
            .frame(maxWidth: .infinity).padding(12)
            .background(Color.black).foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            Spacer()
        }
        .padding(16)
    }
}
