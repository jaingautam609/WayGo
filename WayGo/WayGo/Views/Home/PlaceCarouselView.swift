import SwiftUI
import Combine

struct PlaceCarouselView: View {
    let places: [Place]
    let onTap: (Place) -> Void

    @State private var index = 0
    @State private var timerCancellable: AnyCancellable?

    var body: some View {
        TabView(selection: $index) {
            ForEach(Array(places.enumerated()), id: \.offset) { (i, p) in
                Button {
                    onTap(p)
                } label: {
                    PlaceCard(place: p)
                        .padding(.horizontal, 16)
                }
                .buttonStyle(.plain)
                .tag(i)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(height: 320)
        .onAppear { startAuto() }
        .onDisappear { stopAuto() }
    }

    private func startAuto() {
        stopAuto()
        guard places.count > 1 else { return }
        timerCancellable = Timer.publish(every: 3, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                withAnimation(.easeInOut) {
                    index = (index + 1) % places.count
                }
            }
    }
    private func stopAuto() {
        timerCancellable?.cancel()
        timerCancellable = nil
    }
}

private struct PlaceCard: View {
    let place: Place

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color(white: 0.95))
                .frame(height: 320)
                .shadow(color: .black.opacity(0.10), radius: 12, y: 6)

            // top image
            ZStack(alignment: .topTrailing) {
                if let name = place.images.first, UIImage(named: name) != nil {
                    Image(name)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 320)
                        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                } else {
                    RoundedRectangle(cornerRadius: 22)
                        .fill(Color(white: 0.9))
                        .overlay(
                            Image(systemName: "photo")
                                .font(.system(size: 40))
                                .foregroundColor(.gray)
                        )
                        .frame(height: 320)
                }

                // heart button (visual only)
                Image(systemName: "heart")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(14)
                    .background(.ultraThinMaterial, in: Circle())
                    .padding(12)
            }

            // bottom overlay text
            LinearGradient(
                colors: [Color.black.opacity(0.0), Color.black.opacity(0.6)],
                startPoint: .top, endPoint: .bottom
            )
            .clipShape(RoundedRectangle(cornerRadius: 22))
            .frame(height: 140)
            .overlay(
                VStack(alignment: .leading, spacing: 6) {
                    Text(place.countryName).font(.subheadline).foregroundColor(.white.opacity(0.9))
                    Text(place.name).font(.title2.bold()).foregroundColor(.white)
                    HStack(spacing: 10) {
                        Label(String(format: "%.1f", place.rating), systemImage: "star.fill")
                            .foregroundColor(.white)
                        Text("See more")
                            .padding(.horizontal, 12).padding(.vertical, 6)
                            .background(.ultraThinMaterial, in: Capsule())
                            .foregroundColor(.white)
                    }
                }
                .padding(16),
                alignment: .bottomLeading
            )
        }
    }
}
