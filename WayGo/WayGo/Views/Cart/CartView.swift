import SwiftUI
import StripePaymentSheet
import UIKit

struct CartView: View {
    @EnvironmentObject var cart: CartStore
    @EnvironmentObject var tabBar: TabBarState   // 👈 hide/show custom tab bar

    // MARK: - Stripe / UI state
    @State private var paymentSheet: PaymentSheet?
    @State private var presentSheet = false
    @State private var paying = false
    @State private var payMessage: String?
    @State private var showClear = false

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Your cart").font(.title.bold())
                Spacer()
                if cart.count > 0 {
                    Button("Clear") { showClear = true }
                        .foregroundColor(.red)
                }
            }

            if cart.items.isEmpty {
                Spacer()
                Text("Cart is empty").foregroundColor(.gray)
                Spacer()
            } else {
                List {
                    ForEach(cart.items) { item in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.title).font(.headline)
                                Text(item.subtitle).foregroundColor(.gray).font(.subheadline)
                                Text("Adults \(item.adults)  Kids \(item.kids)")
                                    .foregroundColor(.gray).font(.caption)
                            }
                            Spacer()
                            Text("$\(item.total)").font(.headline)
                        }
                        .swipeActions {
                            Button(role: .destructive) { cart.remove(item) } label: { Text("Delete") }
                        }
                    }
                }
                .listStyle(.plain)

                HStack {
                    Text("Total").font(.headline)
                    Spacer()
                    Text("$\(cart.total)").font(.title2.bold())
                }
                .padding(.horizontal, 16)

                // ✅ Checkout button launches PaymentSheet
                Button(paying ? "Preparing…" : "Checkout") {
                    Task { await preparePaymentSheet() }
                }
                .disabled(cart.total <= 0 || paying)
                .frame(maxWidth: .infinity).padding(12)
                .background(Color.black).foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal, 16)
            }
        }
        .padding(.top, 12)
        .padding(.bottom, 8)
        .background(Color.white.ignoresSafeArea())

        // Alerts & sheets attached to the top-level view
        .alert("Clear cart?", isPresented: $showClear) {
            Button("Cancel", role: .cancel) {}
            Button("Clear", role: .destructive) { cart.clear() }
        }
        .sheet(isPresented: $presentSheet) {
            PaymentSheetView(paymentSheet: $paymentSheet) { result in
                switch result {
                case .completed:
                    payMessage = "Payment succeeded 🎉"
                    cart.clear()
                case .canceled:
                    payMessage = "Payment canceled"
                case .failed(let err):
                    payMessage = "Payment failed: \(err.localizedDescription)"
                }
            }
            .presentationDetents([.large])
        }
        .alert(payMessage ?? "", isPresented: Binding(
            get: { payMessage != nil },
            set: { _ in payMessage = nil }
        )) { Button("OK", role: .cancel) {} }

        // 👇 Hide tab bar while viewing the cart
        .onAppear { tabBar.isHidden = true }
        .onDisappear { tabBar.isHidden = false }
    }

    // MARK: - Stripe: prepare & present sheet
    func preparePaymentSheet() async {
        guard cart.total > 0 else { return }
        paying = true
        defer { paying = false }

        do {
            // amount in the smallest currency unit (e.g., cents)
            let clientSecret = try await StripeService.createPaymentIntent(amountCents: cart.total * 100)

            STPAPIClient.shared.publishableKey = StripeService.publishableKey
            var config = PaymentSheet.Configuration()
            config.merchantDisplayName = "WayGo (Demo)"

            self.paymentSheet = PaymentSheet(
                paymentIntentClientSecret: clientSecret,
                configuration: config
            )
            presentSheet = true
        } catch {
            payMessage = "Failed to start payment. Please try again."
        }
    }
}

// MARK: - Stripe sheet presenter
struct PaymentSheetView: View {
    @Binding var paymentSheet: PaymentSheet?
    let onResult: (PaymentSheetResult) -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("Checkout").font(.title2.bold())
            Spacer()
            Button("Pay with Stripe") {
                guard let sheet = paymentSheet,
                      let presenter = UIApplication.shared.topMostController() else { return }
                sheet.present(from: presenter) { result in
                    onResult(result)
                }
            }
            .frame(maxWidth: .infinity).padding(12)
            .background(Color.black).foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            Spacer()
        }
        .padding(16)
    }
}

// MARK: - UIKit presenter helper
extension UIApplication {
    func topMostController(base: UIViewController? = {
        let scene = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first
        return scene?.keyWindow?.rootViewController
    }()) -> UIViewController? {
        if let nav = base as? UINavigationController { return topMostController(base: nav.visibleViewController) }
        if let tab = base as? UITabBarController { return topMostController(base: tab.selectedViewController) }
        if let presented = base?.presentedViewController { return topMostController(base: presented) }
        return base
    }
}
