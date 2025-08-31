import SwiftUI

struct PackageListView: View {
    let country: Country

    @State private var navPkg: TravelPackage? = nil  // 👈 move it here

    var list: [TravelPackage] {
        demoPackages.filter { $0.countryCode == country.code }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("\(country.emojiFlag)  \(country.name)")
                    .font(.largeTitle.bold())
                    .foregroundColor(.black)

                ForEach(list) { p in
                    PackageListRow(pkg: p) { navPkg = p }
                }

                // 👇 keep this outside the ForEach
                .navigationDestination(item: $navPkg) { p in
                    PackageDetailView(pkg: p)
                }

                if list.isEmpty {
                    Text("No packages yet for \(country.name).")
                        .foregroundColor(.gray)
                }
            }
            .padding(16)
        }
        .background(Color.white.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
    }
}


private struct PackageListRow: View {
    let pkg: TravelPackage
    let open: () -> Void
    @State private var added = false

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Button(action: open) {
                VStack(alignment: .leading, spacing: 8) {
                    if UIImage(named: pkg.imageName) != nil {
                        Image(pkg.imageName).resizable().scaledToFill()
                            .frame(height: 160).clipped()
                            .cornerRadius(12)
                    } else {
                        RoundedRectangle(cornerRadius: 12).fill(Color(white: 0.92))
                            .frame(height: 160)
                            .overlay(Image(systemName: "photo").foregroundColor(.gray))
                    }
                    Text(pkg.title).font(.headline).foregroundColor(.black)
                    HStack(spacing: 12) {
                        Label("\(pkg.days) nights", systemImage: "clock")
                        Label("$\(pkg.price)", systemImage: "dollarsign.circle")
                        Label(String(format: "%.1f", pkg.rating), systemImage: "star.fill")
                    }
                    .font(.footnote).foregroundColor(.gray)
                }
                .padding(12)
                .background(RoundedRectangle(cornerRadius: 14).fill(Color.white).shadow(color: .black.opacity(0.06), radius: 6, y: 3))
            }
            .buttonStyle(.plain)

            Button {
                added = true
            } label: {
                Image(systemName: "cart.badge.plus")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(12)
                    .background(Color.black, in: Circle())
            }
            .padding(18)
            .alert("Added to cart", isPresented: $added) {
                Button("OK", role: .cancel) {}
            }
        }
    }
}
