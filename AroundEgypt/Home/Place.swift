import Foundation

struct PlaceResponse: Decodable {
    struct Meta: Decodable {
        let code: Int
        let errors: [String]
    }
    
    let meta: Meta
    let data: [Place]
}

struct Place: Decodable,Identifiable {
    let id: String
    let title: String
    let coverPhoto: String
    let description: String
    let viewsNo: Int
    let likesNo: Int
    let recommended: Int
    let hasVideo: Int
    let tags: [Tag]
    let city: City
    let tourHtml: String
    let famousFigure: String?
    let period: Period?
    let era: Era?
    let founded: String?
    let detailedDescription: String
    let address: String
    let gmapLocation: GeoLocation
    let openingHours: [String: [String]]?
    let translatedOpeningHours: [String: TranslatedOpeningHour]?
    let startingPrice: Int?
    let ticketPrices: [TicketPrice]?
    let experienceTips: [String]
    let isLiked: Bool?
    let reviews: [Review]
    let rating: Int
    let reviewsNo: Int
    let audioUrl: String
    let hasAudio: Bool
}

struct Tag: Decodable,Identifiable {
    let id: Int
    let name: String
    let disable: Bool?
    let topPick: Int
}

struct City: Decodable,Identifiable {
    let id: Int
    let name: String
    let disable: Bool?
    let topPick: Int
}

struct Period: Decodable,Identifiable {
    let id: String
    let value: String
    let createdAt: String
    let updatedAt: String
}

struct Era: Decodable,Identifiable {
    let id: String
    let value: String
    let createdAt: String
    let updatedAt: String
}

struct GeoLocation: Decodable {
    let type: String
    let coordinates: [Double]
}

struct TranslatedOpeningHour: Decodable {
    let day: String
    let time: String
}

struct TicketPrice: Decodable {
    let type: String
    let price: Int
}

struct Review: Decodable,Identifiable {
    let id: String
    let experience: String
    let name: String
    let rating: Int
    let comment: String
    let createdAt: String
}
