import SwiftUI

struct FlightsSearchView: View {
    @EnvironmentObject var cart: CartStore

    @State private var from = "DEL"
    @State private var to = "BOM"
    @State private var isReturn = false
    @State private var dateStr = ""
    @State private var results: [Flight] = []
    @State private var chosen: Flight? = nil

    var body: some View {
        VStack(spacing: 12) {
            Text("Book flights").font(.title.bold()).foregroundColor(.black).frame(maxWidth: .infinity, alignment: .leading)

            HStack {
                TextField("From (e.g., DEL)", text: $from).textInputAutocapitalization(.never)
                Text("→")
                TextField("To (e.g., BOM)", text: $to).textInputAutocapitalization(.never)
            }
            .padding(14).background(Color(white:0.96)).clipShape(RoundedRectangle(cornerRadius: 12))

            HStack {
                TextField("Date (e.g., 2025-09-01)", text: $dateStr)
                Toggle("Return", isOn: $isReturn).labelsHidden()
            }
            .padding(14).background(Color(white:0.96)).clipShape(RoundedRectangle(cornerRadius: 12))

            Button("Search") { search() }
                .frame(maxWidth: .infinity).padding(12)
                .background(Color.black).foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))

            if results.isEmpty {
                Spacer()
                Text("No results yet").foregroundColor(.gray)
                Spacer()
            } else {
                List {
                    ForEach(results) { f in
                        FlightRow(f: f) { chosen = f }
                    }
                }
                .listStyle(.plain)
            }
        }
        .padding(16)
        .background(Color.white.ignoresSafeArea())
        .sheet(item: $chosen) { f in
            AddFlightToCartSheet(flight: f) // adds to cart
                .presentationDetents([.height(320), .large])
        }
    }

    func search() {
        let f = from.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        let t = to.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        results = demoFlights.filter { $0.from == f && $0.to == t }
        if results.isEmpty { results = demoFlights.filter { $0.from == f || $0.to == t } }
    }
}

private struct FlightRow: View {
    let f: Flight
    let book: () -> Void
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("\(f.from) → \(f.to)").font(.headline)
                Spacer()
                Text("$\(f.price)")
            }
            .foregroundColor(.black)
            HStack {
                Text("\(f.airline) \(f.flightNo)")
                Spacer()
                Text("\(f.departTime) – \(f.arriveTime) • \(f.duration)")
            }
            .foregroundColor(.gray)
            HStack {
                Spacer()
                Button("Book") { book() }
                    .padding(.vertical, 6).padding(.horizontal, 12)
                    .background(Color.black).foregroundColor(.white)
                    .clipShape(Capsule())
            }
        }
        .contentShape(Rectangle())
    }
}

struct AddFlightToCartSheet: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var cart: CartStore
    let flight: Flight
    @State private var adults = 1
    @State private var kids = 0

    var total: Int {
        let a = flight.price * adults
        let k = Int(Double(flight.price) * 0.5) * kids
        return a + k
    }

    var body: some View {
        VStack(spacing: 14) {
            Text("Book \(flight.from) → \(flight.to)").font(.headline)
            HStack {
                Stepper("Adults: \(adults)", value: $adults, in: 1...9)
                Stepper("Kids: \(kids)", value: $kids, in: 0...9)
            }
            .padding(.vertical, 6)
            Text("Total: $\(total)").font(.title3.bold())
            Button("Add to cart") {
                cart.addFlight(flight, adults: adults, kids: kids)
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
