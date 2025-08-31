import SwiftUI   // 👈 REQUIRED

@main
struct WayGoApp: App {
    @StateObject private var cart = CartStore()
    @StateObject private var tabBarState = TabBarState()

    var body: some Scene {
        WindowGroup {
            MainAppView()
                .environmentObject(cart)
                .environmentObject(tabBarState)
                .tint(.black)
        }
    }
}
