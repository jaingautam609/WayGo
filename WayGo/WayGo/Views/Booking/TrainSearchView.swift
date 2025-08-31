import SwiftUI

struct TrainSearchView: View {
    @EnvironmentObject var cart: CartStore
    @State private var from = "DEL"
    @State private var to = "AGC"
    @State private var dateStr = ""
    @State private var results: [Train] = []
    @State private var chosen: Train? = nil

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                TextField("From", text: $from).textInputAutocapitalization(.never)
                Text("→")
                TextField("To", text: $to).textInputAutocapitalization(.never)
            }
            .padding(14).background(Color(white:0.96)).clipShape(RoundedRectangle(cornerRadius: 12))

            TextField("Date (YYYY-MM-DD)", text: $dateStr)
                .padding(14).background(Color(white:0.96)).clipShape(RoundedRectangle(cornerRadius: 12))

            Button("Search") { search() }
                .frame(maxWidth: .infinity).padding(12)
                .background(Color.black).foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))

            if results.isEmpty {
                Spacer(); Text("No results yet").foregroundColor(.gray); Spacer()
            } else {
                List {
                    ForEach(results) { t in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("\(t.from) → \(t.to)").font(.headline)
                                Spacer()
                                Text("$\(t.price)")
                            }.foregroundColor(.black)
                            Text("\(t.trainName) \(t.trainNo) • \(t.departTime)–\(t.arriveTime) • \(t.duration)")
                                .foregroundColor(.gray)
                            HStack {
                                Spacer()
                                Button("Book") { chosen = t }
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
        .sheet(item: $chosen) { t in
            AddTrainToCartSheet(train: t)
                .presentationDetents([.height(320), .large])
        }
    }

    func search() {
        let f = from.uppercased().trimmingCharacters(in: .whitespaces)
        let tt = to.uppercased().trimmingCharacters(in: .whitespaces)
        results = demoTrains.filter { $0.from == f && $0.to == tt }
        if results.isEmpty { results = demoTrains.filter { $0.from == f || $0.to == tt } }
    }
}

struct AddTrainToCartSheet: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var cart: CartStore
    let train: Train
    @State private var adults = 1
    @State private var kids = 0

    var total: Int {
        train.price * adults + Int(Double(train.price) * 0.5) * kids
    }

    var body: some View {
        VStack(spacing: 14) {
            Text("Book \(train.from) → \(train.to)").font(.headline)
            HStack {
                Stepper("Adults: \(adults)", value: $adults, in: 1...9)
                Stepper("Kids: \(kids)", value: $kids, in: 0...9)
            }
            Text("Total: $\(total)").font(.title3.bold())
            Button("Add to cart") {
                cart.addTrain(train, adults: adults, kids: kids)
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
