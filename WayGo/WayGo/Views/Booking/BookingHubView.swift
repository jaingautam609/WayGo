import SwiftUI

enum BookingMode: String, CaseIterable {
    case flights = "Flights"
    case trains  = "Trains"
    case hotels  = "Hotels"
    case airbnb  = "Airbnb"
    case villas  = "Villas"
    case cabs    = "Cabs"
}

struct BookingHubView: View {
    @State private var mode: BookingMode = .flights   // default

    var body: some View {
        Group {
            switch mode {
            case .flights:
                FlightsSearchView()
            case .trains:
                TrainSearchView()
            case .hotels:
                StaySearchView(kind: .hotel)
            case .airbnb:
                StaySearchView(kind: .airbnb)
            case .villas:
                StaySearchView(kind: .villa)
            case .cabs:
                CabSearchView()
            }
        }
        .navigationTitle(mode.rawValue)                     // title reflects current mode
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    ForEach(BookingMode.allCases, id: \.self) { m in
                        Button {
                            mode = m
                        } label: {
                            Label(m.rawValue, systemImage: icon(for: m))
                        }
                    }
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                }
            }
        }
        .background(Color.white.ignoresSafeArea())
    }

    private func icon(for m: BookingMode) -> String {
        switch m {
        case .flights: return "airplane.departure"
        case .trains:  return "tram.fill"       // safe-ish stand‑in for trains
        case .hotels:  return "bed.double"
        case .airbnb:  return "house"
        case .villas:  return "house.lodge"
        case .cabs:    return "car"
        }
    }
}
