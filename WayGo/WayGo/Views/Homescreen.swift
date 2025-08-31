import SwiftUI

struct HomeScreen: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                Text("Home").font(.instrument(28, weight: "SemiBold"))
                Text("You’re logged in.").font(.instrument(16))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.paper)
        }
    }
}
