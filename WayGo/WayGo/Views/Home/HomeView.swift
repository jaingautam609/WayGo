import SwiftUI

struct HomeView: View {
    // from MainAppView we'll pass username/isLoggedIn if you want; for now keep simple header
    let username: String?
    let isLoggedIn: Bool
    let onSelectCountry: (Country) -> Void
    let onSelectPlace: (Place) -> Void

    @State private var query = ""
    @State private var selectedCountryCode: String? = nil

    // carousel
    @State private var index = 0
    let timer = Timer.publish(every: 3.5, on: .main, in: .common).autoconnect()

    private var filteredCountries: [Country] {
        let q = query.trimmingCharacters(in: .whitespacesAndNewlines)
        let list = demoCountries
        if q.isEmpty { return list }
        return list.filter { $0.name.localizedCaseInsensitiveContains(q) || $0.code.localizedCaseInsensitiveContains(q) }
    }

    private var featuredPlaces: [Place] {
        if let code = selectedCountryCode {
            return demoPlaces.filter { $0.countryCode == code }
        }
        return demoPlaces
    }

    var body: some View {
        VStack(spacing: 14) {

            // Header
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(greeting)
                        .font(.largeTitle.bold())
                        .foregroundColor(.black)
                        .lineLimit(1)
                    Text("Welcome to WayGo")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
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
                        .font(.system(size: 28))
                        .foregroundColor(.black)
                        .frame(width: 36, height: 36)
                }
            }
            .padding(.horizontal, 20)
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
            .padding(.horizontal, 20)

            // Country chips (instead of continents)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(filteredCountries) { c in
                        let active = selectedCountryCode == c.code
                        Button {
                            withAnimation { selectedCountryCode = (active ? nil : c.code) }
                            if active == false {
                                // also navigate to packages when tapped twice if you want
                            }
                        } label: {
                            Text(c.name)
                                .font(.subheadline.weight(active ? .semibold : .regular))
                                .foregroundColor(active ? .white : .black)
                                .padding(.vertical, 8).padding(.horizontal, 14)
                                .background(active ? Color.black : Color(white: 0.95))
                                .clipShape(Capsule())
                        }
                        .contextMenu {
                            Button("View packages") { onSelectCountry(c) }
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.top, 2)

            // Section title
            HStack {
                Text("Plan your next trip")
                    .font(.title2.bold())
                    .foregroundColor(.black)
                Spacer()
            }
            .padding(.horizontal, 20)

            // Auto-rotating + swipeable place cards
            TabView(selection: $index) {
                ForEach(Array(featuredPlaces.enumerated()), id: \.offset) { idx, place in
                    PlaceCard(place: place) {
                        onSelectPlace(place)
                    }
                    .padding(.horizontal, 20)
                    .tag(idx)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 330)
            .onReceive(timer) { _ in
                guard !featuredPlaces.isEmpty else { return }
                withAnimation {
                    index = (index + 1) % featuredPlaces.count
                }
            }

            Spacer(minLength: 0)
        }
        .background(Color.white.ignoresSafeArea())
    }

    private var greeting: String {
        if let name = username, !name.isEmpty { return "Hello, \(name)" }
        return "Welcome, Back"
    }
}

private struct PlaceCard: View {
    let place: Place
    let tap: () -> Void

    var body: some View {
        Button(action: tap) {
            ZStack(alignment: .bottomLeading) {
                ZStack(alignment: .topTrailing) {
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .fill(Color(white: 0.95))
                        .frame(height: 280)

                    // image (first if exists)
                    if let first = place.images.first, UIImage(named: first) != nil {
                        Image(first)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 280)
                            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                    } else {
                        Image(systemName: "photo")
                            .font(.system(size: 44))
                            .foregroundColor(.gray.opacity(0.7))
                            .padding()
                    }

                    Circle()
                        .fill(Color.white.opacity(0.9))
                        .frame(width: 36, height: 36)
                        .padding(12)
                        .overlay(
                            Image(systemName: "heart")
                                .foregroundColor(.black)
                        )
                        .padding(8)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text(place.countryName)
                        .font(.caption).foregroundColor(.white.opacity(0.9))
                    Text(place.name)
                        .font(.headline).foregroundColor(.white)
                    HStack(spacing: 10) {
                        Label(String(format: "%.1f", place.rating), systemImage: "star.fill")
                        Text("\(place.reviews) reviews")
                    }
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.95))
                }
                .padding(16)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.55), .clear]),
                                   startPoint: .bottom, endPoint: .top)
                        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                )
            }
        }
        .buttonStyle(.plain)
    }
}
