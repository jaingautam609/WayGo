import SwiftUI
import UIKit

// Rename to avoid confusion with the old file name
struct CountryHome: View {
    let username: String?
    let isLoggedIn: Bool

    @State private var query = ""
    @State private var selectedCountryCode: String? = nil

    // programmatic navigation
    @State private var navCountry: Country?
    @State private var navPlace: Place?

    private var filteredCountries: [Country] {
        let q = query.trimmingCharacters(in: .whitespacesAndNewlines)
        if q.isEmpty { return demoCountries }
        return demoCountries.filter { $0.name.localizedCaseInsensitiveContains(q) || $0.code.localizedCaseInsensitiveContains(q) }
    }
    private var featuredPlaces: [Place] {
        if let code = selectedCountryCode { return demoPlaces.filter { $0.countryCode == code } }
        return demoPlaces
    }

    private let grid = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            // Header with greeting + profile
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(greetingLine)
                        .font(.largeTitle.bold())
                        .foregroundColor(.black)
                    Text("Welcome to WayGo")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                ProfileMenuButton(username: username, isLoggedIn: isLoggedIn)
            }
            .padding(.top, 6)

            // Search
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass").foregroundColor(.gray)
                TextField("Search country", text: $query)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            }
            .padding(14)
            .background(Color(white: 0.96))
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

            // Country chips
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    Chip(title: "All", active: selectedCountryCode == nil) { selectedCountryCode = nil }
                    ForEach(demoCountries) { c in
                        Chip(title: c.name, active: selectedCountryCode == c.code) { selectedCountryCode = c.code }
                    }
                }
                .padding(.vertical, 4)
            }

            // Section title + carousel
            Text("Let’s plan your next trip")
                .font(.title2.bold())
                .foregroundColor(.black)
                .padding(.top, 4)

            PlaceCarouselView(places: featuredPlaces) { place in
                // direct programmatic push
                navPlace = place
            }

            // Countries grid
            Text("Browse by country")
                .font(.title3.bold())
                .foregroundColor(.black)
                .padding(.top, 8)

            ScrollView {
                LazyVGrid(columns: grid, spacing: 12) {
                    ForEach(filteredCountries) { c in
                        CountryTile(country: c) {
                            navCountry = c    // programmatic push
                        }
                    }
                }
                .padding(.top, 6)
                .padding(.bottom, 120) // room for tab bar
            }
        }
        .padding(.horizontal, 20)
        .background(Color.white.ignoresSafeArea())

        // 🔗 destinations owned by THIS view
        .navigationDestination(item: $navCountry) { c in
            PackageListView(country: c)
        }
        .navigationDestination(item: $navPlace) { p in
            PlaceDetailView(place: p)
        }
    }

    private var greetingLine: String {
        if let name = username, !name.isEmpty { return "Hello, \(name)" }
        return "Welcome, Back"
    }
}

// MARK: - Small helpers used on this screen

private struct Chip: View {
    let title: String
    let active: Bool
    let tap: () -> Void
    var body: some View {
        Button(action: tap) {
            Text(title)
                .font(.subheadline.weight(active ? .semibold : .regular))
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(active ? Color.black : Color(white: 0.92))
                .foregroundColor(active ? .white : .black)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

private struct CountryTile: View {
    let country: Country
    let tap: () -> Void
    var body: some View {
        Button(action: tap) {
            VStack(alignment: .leading, spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(Color(white: 0.96))
                        .frame(height: 110)
                    Text(country.emojiFlag).font(.system(size: 44))
                }
                Text(country.name)
                    .font(.headline)
                    .foregroundColor(.black)
                    .lineLimit(1)
            }
        }
        .buttonStyle(.plain)
    }
}

// reuse the profile button you already had
private struct ProfileMenuButton: View {
    let username: String?
    let isLoggedIn: Bool
    var body: some View {
        Menu {
            if isLoggedIn {
                Button { } label: { Label("Profile details", systemImage: "person.crop.circle") }
                Button { } label: { Label("Cart", systemImage: "cart") }
                Button { } label: { Label("Saved trips", systemImage: "heart") }
                Button { } label: { Label("Choose currency", systemImage: "sterlingsign.circle") }
                Button { } label: { Label("Settings", systemImage: "gearshape") }
                Divider()
                Button(role: .destructive) { } label: { Label("Logout", systemImage: "rectangle.portrait.and.arrow.right") }
            } else {
                Button { } label: { Label("Login", systemImage: "person.crop.circle.badge.checkmark") }
                Button { } label: { Label("Settings", systemImage: "gearshape") }
            }
        } label: {
            Image(systemName: "person.crop.circle")
                .font(.system(size: 28, weight: .regular))
                .foregroundColor(.black)
                .frame(width: 36, height: 36)
        }
    }
}
