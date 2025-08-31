import SwiftUI

struct StaySearchView: View {
    @EnvironmentObject var cart: CartStore
    let kind: StayKind

    @State private var city = ""
    @State private var nights = 2
    @State private var results: [Stay] = []
    @State private var chosen: Stay? = nil

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                TextField("City", text: $city)
                Stepper("Nights: \(nights)", value: $nights, in: 1...14)
                    .labelsHidden()
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
                    ForEach(results) { s in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(s.name).font(.headline)
                                Spacer()
                                Text("$\(s.pricePerNight)/night")
                            }.foregroundColor(.black)
                            Text("\(s.city) • \(String(format: "%.1f", s.rating)) ★").foregroundColor(.gray)
                            HStack {
                                Spacer()
                                Button("Book") { chosen = s }
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
        .sheet(item: $chosen) { stay in
            AddStayToCartSheet(stay: stay, nights: nights)
                .presentationDetents([.height(340), .large])
        }
    }

    func search() {
        let c = city.trimmingCharacters(in: .whitespaces).lowercased()
        results = demoStays.filter { $0.kind == kind && (c.isEmpty || $0.city.lowercased().contains(c)) }
        // adjust nights in UI context; price is per night at checkout we use adults/kids
    }
}

struct AddStayToCartSheet: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var cart: CartStore
    let stay: Stay
    let nights: Int
    @State private var adults = 2
    @State private var kids = 0

    var nightlyTotal: Int {
        stay.pricePerNight * adults + Int(Double(stay.pricePerNight) * 0.5) * kids
    }
    var total: Int { nightlyTotal * nights }

    var body: some View {
        VStack(spacing: 14) {
            Text("Book \(stay.name)").font(.headline)
            Text("\(stay.city) • \(nights) nights").foregroundColor(.gray)
            HStack {
                Stepper("Adults: \(adults)", value: $adults, in: 1...6)
                Stepper("Kids: \(kids)", value: $kids, in: 0...6)
            }
            Text("Total: $\(total)").font(.title3.bold())
            Button("Add to cart") {
                // store per-night price; Cart shows total based on adults/kids later
                cart.addStay(stay, adults: adults, kids: kids)
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
