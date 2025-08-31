import SwiftUI

struct ContentView: View {
    @State private var statusText = "Checking API…"

    var body: some View {
        VStack(spacing: 16) {
            Text("WayGo").font(.largeTitle).bold()
            Text(statusText).font(.title3)
        }
        .padding()
        .task {
            let ok = await APIService.healthCheck()
            statusText = ok ? "✅ API is reachable" : "❌ API error"
        }
    }
}

#Preview {
    ContentView()
}
