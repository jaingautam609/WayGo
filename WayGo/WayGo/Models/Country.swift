import Foundation

struct Country: Identifiable, Hashable {
    let id = UUID()
    let code: String   // "GB"
    let name: String   // "United Kingdom"
    let emojiFlag: String
}
