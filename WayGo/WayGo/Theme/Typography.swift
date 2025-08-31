import SwiftUI

extension Font {
    static func instrument(_ size: CGFloat, weight: String = "Regular") -> Font {
        Font.custom("InstrumentSans-\(weight)", size: size)
    }
}
