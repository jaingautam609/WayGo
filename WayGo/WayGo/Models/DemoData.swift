import Foundation

let demoCountries: [Country] = [
    .init(code: "GB", name: "United Kingdom", emojiFlag: "🇬🇧"),
    .init(code: "FR", name: "France",         emojiFlag: "🇫🇷"),
    .init(code: "IT", name: "Italy",          emojiFlag: "🇮🇹"),
    .init(code: "ES", name: "Spain",          emojiFlag: "🇪🇸"),
    .init(code: "BR", name: "Brazil",         emojiFlag: "🇧🇷"),
    .init(code: "JP", name: "Japan",          emojiFlag: "🇯🇵"),
]

let demoPackages: [TravelPackage] = [
    .init(countryCode: "BR", placeName: "Rio de Janeiro", title: "Iconic Brazil",
          days: 8, price: 659, rating: 4.6, imageName: "br1",
          highlights: ["Christ", "Sugarloaf", "Ipanema"], category: .budget),
    .init(countryCode: "BR", placeName: "Rio de Janeiro", title: "Romantic Rio",
          days: 6, price: 899, rating: 4.8, imageName: "br2",
          highlights: ["Sunset Sail", "Santa Teresa", "Parque Lage"], category: .couple),
    .init(countryCode: "BR", placeName: "Rio de Janeiro", title: "Family Adventure",
          days: 7, price: 749, rating: 4.7, imageName: "br3",
          highlights: ["Aquario", "Botanical Garden", "Sugarloaf"], category: .family),

    .init(countryCode: "JP", placeName: "Kyoto", title: "Zen & Shrines",
          days: 5, price: 820, rating: 4.9, imageName: "jp1",
          highlights: ["Fushimi Inari", "Gion", "Arashiyama"], category: .couple),
    .init(countryCode: "JP", placeName: "Kyoto", title: "Kyoto on a Budget",
          days: 7, price: 600, rating: 4.6, imageName: "jp2",
          highlights: ["Tea House", "Kiyomizu-dera", "Nishiki"], category: .budget),

    .init(countryCode: "FR", placeName: "Paris", title: "Paris Essentials",
          days: 6, price: 799, rating: 4.8, imageName: "fr1",
          highlights: ["Eiffel", "Louvre", "Seine"], category: .longStay),
]

