import SwiftUI


import SwiftUI

struct MainAppView: View {
    @State private var selection: RootTab = .home
    @EnvironmentObject var cart: CartStore

    private let tabBarHeight: CGFloat = 96  // adjust to your bar’s real height

    var body: some View {
        ZStack(alignment: .bottom) {
            // ---- CONTENT ----
            Group {
                switch selection {
                case .home:
                    NavigationStack { CountryHome(username: "Gautam", isLoggedIn: true) }
                case .booking:
                    NavigationStack { BookingHubView() }
                case .cart:
                    NavigationStack { CartView() }
                case .community:
                    NavigationStack { PlaceholderScreen(title: "Community") }
                case .more:
                    NavigationStack { PlaceholderScreen(title: "More") }
                }
            }
            // 👉 reserve vertical space equal to the tab bar
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: tabBarHeight)
            }

            // ---- TAB BAR ----
            CustomTabBar(selection: $selection)
        }
    }
}




private struct PlaceholderScreen: View {
    let title: String
    var body: some View {
        VStack(spacing: 12) {
            Text(title)
                .font(.instrument(28, weight: "SemiBold"))
                .foregroundColor(Color.black)
            Text("Coming soon")
                .font(.instrument(16))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.paper.ignoresSafeArea())
    }
}
//
//  MainAppView.swift
//  WayGo
//
//  Created by gautam jain on 30/08/2025.
//

struct DebugDetailView: View {
    let title: String
    let subtitle: String
    var body: some View {
        VStack(spacing: 12) {
            Text(title).font(.largeTitle).foregroundColor(.black)
            Text(subtitle).font(.title2).foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.ignoresSafeArea())
    }
}
