import Foundation

let demoPlaces: [Place] = [
    Place(name: "Rio de Janeiro",
          countryCode: "BR",
          countryName: "Brazil",
          rating: 5.0,
          reviews: 143,
          images: ["br1","br2","br3"],   // add any images you have; placeholder used if missing
          blurb: """
Rio de Janeiro, often simply called Rio, is one of Brazil’s most iconic cities, renowned for its dramatic mountains, samba, and golden beaches. From Christ the Redeemer watching over the bay to the cable cars of Sugarloaf, the city blends culture and nature like nowhere else. Explore Copacabana, experience Lapa’s nightlife, and hike Tijuca Forest for sweeping views. Take a favela tour with a trusted operator to learn the city’s complex history. Time your visit to Carnival to see the Sambadrome in full color. Boat trips to the Cagarras Islands show turquoise waters and marine life. Try feijoada, drink a caipirinha, and watch sunset at Arpoador. Rio is vibrant, soulful, and unforgettable.
"""),
    Place(name: "Paris",
          countryCode: "FR",
          countryName: "France",
          rating: 4.9,
          reviews: 143,
          images: ["fr1","fr2","fr3"],
          blurb: "Paris mixes grand boulevards, world‑class museums, cafés, and hidden courtyards... (keep long text)"),
    Place(name: "Kyoto",
          countryCode: "JP",
          countryName: "Japan",
          rating: 4.9,
          reviews: 143,
          images: ["jp1","jp2","jp3"],
          blurb: "Kyoto is temples, tea houses, and timeless streets. Wander Gion, see Fushimi Inari..."),
    Place(name: "London",
          countryCode: "GB",
          countryName: "United Kingdom",
          rating: 4.8,
          reviews: 143,
          images: ["uk1","uk2","uk3"],
          blurb: "A global city with layers of history from Westminster to the markets of Shoreditch..."),
]
