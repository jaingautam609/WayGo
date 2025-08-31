import SwiftUI

struct AuthView: View {
    @EnvironmentObject var session: SessionStore
    @State private var mode: Mode = .login

    enum Mode { case login, signup }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(alignment: .leading, spacing: 6) {
                Text(mode == .login ? "Welcome back" : "Create account")
                    .font(.instrument(28, weight: "SemiBold"))
                    .foregroundStyle(Color.ink)
                Text("WayGo")
                    .font(.instrument(16))
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.top, 36)

            // Segmented control
            HStack(spacing: 8) {
                TabPill(title: "Login", active: mode == .login) { mode = .login }
                TabPill(title: "Sign up", active: mode == .signup) { mode = .signup }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)

            ScrollView {
                if mode == .login { LoginForm() } else { SignupForm() }
            }
            .scrollDismissesKeyboard(.interactively)

            Spacer(minLength: 12)
        }
        .background(Color.paper)
    }
}

private struct TabPill: View {
    let title: String
    let active: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.instrument(14, weight: active ? "SemiBold" : "Regular"))
                .padding(.vertical, 8)
                .padding(.horizontal, 14)
                .background(active ? Color.smoke : .clear)
                .clipShape(Capsule())
                .foregroundStyle(Color.ink)
        }
    }
}

private struct LoginForm: View {
    @EnvironmentObject var session: SessionStore
    @State private var email = ""
    @State private var password = ""
    @State private var loading = false
    @State private var errorText: String?

    var body: some View {
        VStack(spacing: 14) {
            TextField("Email", text: $email).keyboardType(.emailAddress)
                .modifier(ThemedTextField())
                .font(.instrument(16))
            SecureField("Password", text: $password)
                .modifier(ThemedTextField())
                .font(.instrument(16))

            if let err = errorText {
                Text(err).foregroundStyle(.red).font(.instrument(14))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            Button {
                Task { await submit() }
            } label: {
                HStack {
                    if loading { ProgressView() }
                    Text("Login")
                }
            }
            .buttonStyle(ThemedButton())
            .disabled(loading || email.isEmpty || password.isEmpty)
        }
        .padding(20)
    }

    func submit() async {
        guard !loading else { return }
        loading = true; defer { loading = false }
        do {
            let res = try await AuthService.shared.login(.init(email: email, password: password))
            session.token = res.token
        } catch {
            errorText = (error as? LocalizedError)?.errorDescription ?? "Login failed."
        }
    }
}

private struct SignupForm: View {
    @EnvironmentObject var session: SessionStore
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var loading = false
    @State private var errorText: String?

    var body: some View {
        VStack(spacing: 14) {
            TextField("Full name", text: $name)
                .modifier(ThemedTextField())
                .font(.instrument(16))

            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .modifier(ThemedTextField())
                .font(.instrument(16))

            SecureField("Password", text: $password)
                .modifier(ThemedTextField())
                .font(.instrument(16))
                .submitLabel(.go)
                .onSubmit { Task { await submit() } }

            // ✅ Validation helper
            if email.isEmpty || password.count < 6 {
                Text("Please enter a valid email and password (6+ chars)")
                    .font(.instrument(12))
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            // Server error (if any)
            if let err = errorText {
                Text(err)
                    .foregroundStyle(.red)
                    .font(.instrument(14))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            Button {
                Task { await submit() }
            } label: {
                HStack {
                    if loading { ProgressView() }
                    Text("Create account")
                }
            }
            .buttonStyle(ThemedButton())
            .disabled(loading || email.isEmpty || password.count < 6)
        }
        .padding(20)
    }

    func submit() async {
        guard !loading else { return }
        // Trim spaces just in case
        let cleanEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanName = name.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !cleanEmail.isEmpty, cleanPassword.count >= 6 else { return }
        loading = true; defer { loading = false }

        do {
            let res = try await AuthService.shared.signup(.init(
                email: cleanEmail,
                password: cleanPassword,
                displayName: cleanName
            ))
            session.token = res.token
            errorText = nil
        } catch {
            errorText = (error as? LocalizedError)?.errorDescription ?? "Sign up failed."
        }
    }
}
