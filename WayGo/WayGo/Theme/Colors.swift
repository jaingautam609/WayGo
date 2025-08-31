import SwiftUI

extension Color {
    static let ink   = Color(hex: 0x212529)
    static let smoke = Color(hex: 0xF5F6F7)
    static let paper = Color.white
}

extension Color {
    init(hex: UInt, alpha: Double = 1.0) {
        self.init(.sRGB,
                  red:   Double((hex >> 16) & 0xff) / 255.0,
                  green: Double((hex >>  8) & 0xff) / 255.0,
                  blue:  Double((hex      ) & 0xff) / 255.0,
                  opacity: alpha)
    }
}

struct ThemedButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.custom("InstrumentSans-SemiBold", size: 17))
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity)
            .background(Color.ink)
            .foregroundStyle(Color.paper)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .opacity(configuration.isPressed ? 0.85 : 1.0)
    }
}

struct ThemedTextField: ViewModifier {
    func body(content: Content) -> some View {
        content
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .padding(14)
            .background(Color.smoke)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}
//
//  Colors.swift
//  WayGo
//
//  Created by gautam jain on 29/08/2025.
//

