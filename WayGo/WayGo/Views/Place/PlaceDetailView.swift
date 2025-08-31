import SwiftUI
import UIKit

struct PlaceDetailView: View {
    // for navigating to a full package page
    @EnvironmentObject var cart: CartStore
    @State private var showAddSheet = false

    @State private var navPkg: TravelPackage? = nil

    let place: Place
    @State private var expanded = false
    @State private var selectedCat: PackageCategory? = nil

    // packages belonging to this place
    private var pkgs: [TravelPackage] {
        demoPackages.filter { $0.placeName == place.name }
    }
    private var filtered: [TravelPackage] {
        selectedCat == nil ? pkgs : pkgs.filter { $0.category == selectedCat }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // HERO image (safe fallback)
                if let first = place.images.first, UIImage(named: first) != nil {
                    Image(first)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 280)
                        .clipped()
                        .cornerRadius(16)
                } else {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(white: 0.92))
                        .frame(height: 280)
                        .overlay(
                            Image(systemName: "photo")
                                .font(.system(size: 36))
                                .foregroundColor(.gray)
                        )
                }

                // Title + meta
                Text(place.name)
                    .font(.title.bold())
                    .foregroundColor(.black)

                HStack(spacing: 8) {
                    Text(place.countryName)
                    Circle().frame(width: 4, height: 4)
                    Label(String(format: "%.1f", place.rating), systemImage: "star.fill")
                }
                .font(.subheadline)
                .foregroundColor(.gray)

                // Collapsible description
                Group {
                    if expanded {
                        Text(place.blurb)
                            .foregroundColor(.black)
                        Button("Read less") { withAnimation { expanded = false } }
                    } else {
                        Text(place.blurb)
                            .foregroundColor(.black)
                            .lineLimit(2)
                        Button("Read more") { withAnimation { expanded = true } }
                    }
                }
                .font(.body)

                // Packages section
                HStack {
                    Text("Upcoming tours")
                        .font(.title2.bold())
                        .foregroundColor(.black)
                    Spacer()
                    Button("See all") { /* TODO: push a full list screen */ }
                        .font(.subheadline)
                        .foregroundColor(.black)
                }

                // Category chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        chip("All", active: selectedCat == nil) { selectedCat = nil }
                        ForEach(PackageCategory.allCases, id: \.self) { c in
                            chip(c.rawValue, active: selectedCat == c) { selectedCat = c }
                        }
                    }
                }

                // Carousel of packages
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 14) {
                        ForEach(filtered) { p in
                            Button(action: { navPkg = p }) {
                                PackageMiniCard(pkg: p)
                            }
                            .buttonStyle(.plain)
                        }

                    }
                    .padding(.vertical, 6)
                }
            }
            .padding(16)
        }
        .background(Color.white.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showAddSheet = true
                } label: {
                    Image(systemName: "cart.badge.plus")
                }
                .disabled(pkgs.first == nil)   // no packages for this place
            }
        }
        .sheet(isPresented: $showAddSheet) {
            if let first = pkgs.first {
                AddTourToCartSheet(pkg: first)
                    .environmentObject(cart)
                    .presentationDetents([.height(320), .large])
            }
        }


        // 👇 This is the piece that actually pushes the package detail screen
        .navigationDestination(item: $navPkg) { p in
            PackageDetailView(pkg: p)
        }
    }

    private func chip(_ title: String, active: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.weight(active ? .semibold : .regular))
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .background(active ? Color.black : Color(white: 0.92))
                .foregroundColor(active ? .white : .black)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

private struct PackageMiniCard: View {
    let pkg: TravelPackage
    @State private var added = false

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(alignment: .leading, spacing: 8) {
                if UIImage(named: pkg.imageName) != nil {
                    Image(pkg.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 260, height: 160)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                } else {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(white: 0.92))
                        .frame(width: 260, height: 160)
                        .overlay(
                            Image(systemName: "photo")
                                .font(.system(size: 32))
                                .foregroundColor(.gray)
                        )
                }

                Text(pkg.title)
                    .font(.headline)
                    .foregroundColor(.black)

                HStack(spacing: 12) {
                    Label("\(pkg.days) nights", systemImage: "clock")
                    Label("$\(pkg.price)", systemImage: "dollarsign.circle")
                    Label(String(format: "%.1f", pkg.rating), systemImage: "star.fill")
                }
                .font(.footnote)
                .foregroundColor(.gray)
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.06), radius: 6, y: 3)
            )
            .frame(width: 280)

            // Add to cart button
            Button {
                added = true
                // TODO: hook to a CartStore later
            } label: {
                Image(systemName: "cart.badge.plus")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(12)
                    .background(Color.black, in: Circle())
            }
            .padding(10)
            .alert("Added to cart", isPresented: $added) {
                Button("OK", role: .cancel) { }
            }
        }
    }
}
struct AddTourToCartSheet: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var cart: CartStore
    let pkg: TravelPackage
    @State private var adults = 1
    @State private var kids = 0

    var total: Int {
        let a = pkg.price * adults
        let k = Int(Double(pkg.price) * 0.5) * kids
        return a + k
    }

    var body: some View {
        VStack(spacing: 14) {
            Text("Add “\(pkg.title)”").font(.headline)
            HStack {
                Stepper("Adults: \(adults)", value: $adults, in: 1...9)
                Stepper("Kids: \(kids)", value: $kids, in: 0...9)
            }
            Text("Total: $\(total)").font(.title3.bold())
            Button("Add to cart") {
                cart.addTour(pkg, adults: adults, kids: kids)
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
