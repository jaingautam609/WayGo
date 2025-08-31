import SwiftUI
import UIKit

struct PackageDetailView: View {
    let pkg: TravelPackage
    @State private var showIncluded = true
    @State private var showExcluded = false
    @State private var planOpen: Set<Int> = []

    // ---- Demo data (fast to show) ----
    private var pricePerPerson: Int { pkg.price }
    private var bestTime: String {
        switch pkg.countryCode {
        case "JP": return "Mar–May, Oct–Nov"
        case "FR": return "Apr–Jun, Sep–Oct"
        case "BR": return "May–Oct"
        default:   return "Year-round"
        }
    }
    private var hotels: [String] {
        ["Grand Plaza", "Cityview Suites", "Sunrise Inn", "Riverside Hotel"]
    }
    private var included: [String] {
        ["Accommodation \(pkg.days) nights", "Daily breakfast", "Airport pickup & drop", "City tour guide", "All internal transfers"]
    }
    private var excluded: [String] {
        ["International flights", "Personal expenses", "Travel insurance", "Visa fees", "Meals not mentioned"]
    }
    private var tourPlan: [String] {
        [
            "Arrival and hotel check-in. Evening leisure walk and local market.",
            "City sightseeing: top landmarks and museum entry.",
            "Day trip to a scenic viewpoint with lunch.",
            "Cultural neighborhood tour + evening show.",
            "Free morning; optional activity; sunset spot.",
            "Transfer to next city with stopovers.",
            "Departure after breakfast."
        ].prefix(max(pkg.days, 5)).map { $0 }
    }
    // ----------------------------------

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // HERO image from package
                if UIImage(named: pkg.imageName) != nil {
                    Image(pkg.imageName).resizable().scaledToFill()
                        .frame(height: 280).clipped()
                        .cornerRadius(16)
                } else {
                    RoundedRectangle(cornerRadius: 16).fill(Color(white: 0.92))
                        .frame(height: 280)
                        .overlay(Image(systemName: "photo").font(.system(size: 36)).foregroundColor(.gray))
                }

                // Title + Map button
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(pkg.placeName).font(.title.bold()).foregroundColor(.black)
                        Text(pkg.title).font(.subheadline).foregroundColor(.gray)
                    }
                    Spacer()
                    Button {
                        // TODO: push to map later
                    } label: {
                        Label("Map", systemImage: "map")
                            .padding(.horizontal, 12).padding(.vertical, 8)
                            .background(Color.black).foregroundColor(.white)
                            .clipShape(Capsule())
                    }
                }

                // SECTION 1: quick details card
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Label("$\(pricePerPerson)/person", systemImage: "dollarsign.circle")
                        Spacer()
                        Label("\(pkg.days) nights", systemImage: "clock")
                    }
                    .foregroundColor(.black)

                    Divider()

                    Label("Best time: \(bestTime)", systemImage: "calendar")
                        .foregroundColor(.black)

                    VStack(alignment: .leading, spacing: 6) {
                        Text("Hotels (sample)").font(.subheadline).foregroundColor(.gray)
                        ForEach(hotels, id: \.self) { h in
                            HStack {
                                Image(systemName: "bed.double").foregroundColor(.gray)
                                Text(h).foregroundColor(.black)
                                Spacer()
                            }
                        }
                    }
                }
                .padding(14)
                .background(RoundedRectangle(cornerRadius: 14).fill(Color.white).shadow(color: .black.opacity(0.06), radius: 6, y: 3))

                // SECTION 2: Included / Excluded as dropdowns
                Group {
                    DisclosureGroup(isExpanded: $showIncluded) {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(included, id: \.self) { item in
                                HStack(alignment: .top, spacing: 8) {
                                    Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                                    Text(item).foregroundColor(.black)
                                }
                            }
                        }
                        .padding(.top, 6)
                    } label: {
                        Text("Included in package").font(.headline).foregroundColor(.black)
                    }
                    .padding(14)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color(white: 0.97)))

                    DisclosureGroup(isExpanded: $showExcluded) {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(excluded, id: \.self) { item in
                                HStack(alignment: .top, spacing: 8) {
                                    Image(systemName: "xmark.circle.fill").foregroundColor(.red)
                                    Text(item).foregroundColor(.black)
                                }
                            }
                        }
                        .padding(.top, 6)
                    } label: {
                        Text("Excluded from package").font(.headline).foregroundColor(.black)
                    }
                    .padding(14)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color(white: 0.97)))
                }

                // SECTION 3: Tour Plan accordion
                VStack(alignment: .leading, spacing: 10) {
                    Text("Tour Plan").font(.title2.bold()).foregroundColor(.black)
                    ForEach(Array(tourPlan.enumerated()), id: \.offset) { (i, text) in
                        TourDayRow(dayIndex: i, text: text, isOpen: planOpen.contains(i)) {
                            if planOpen.contains(i) { planOpen.remove(i) } else { planOpen.insert(i) }
                        }
                    }
                }

                Spacer(minLength: 20)
            }
            .padding(16)
        }
        .background(Color.white.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct TourDayRow: View {
    let dayIndex: Int
    let text: String
    let isOpen: Bool
    let toggle: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Button(action: toggle) {
                HStack {
                    Text("Day \(String(format: "%02d", dayIndex + 1))")
                        .font(.subheadline.weight(.semibold))
                        .padding(.vertical, 6)
                        .padding(.horizontal, 10)
                        .background(Color.blue.opacity(0.85))
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))

                    Text("Destination – \(text)")
                        .foregroundColor(.black)
                        .font(.subheadline)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)

                    Spacer()
                    Image(systemName: isOpen ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding(12)
                .background(Color(white: 0.97))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            if isOpen {
                Text("""
Breakfast at hotel. Morning city exploration with guided stops.
Lunch at a recommended local restaurant. Afternoon attractions per itinerary.
Evening free time and dinner. Overnight at hotel.
""")
                    .foregroundColor(.black)
                    .font(.footnote)
                    .padding(12)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(white: 0.92))
                    )
            }
        }
    }
}
