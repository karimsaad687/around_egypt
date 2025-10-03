import Foundation

// MARK: - Main Response
struct PlacesResponse: Codable {
    let meta: Meta
    let data: [Place]
    let pagination: Pagination?
}

// MARK: - Meta
struct Meta: Codable {
    let code: Int
    let errors: [String]
}

// MARK: - Experience
struct Place: Codable, Identifiable {
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
    let tourHTML: String
    let famousFigure: String
    let period: Period?
    let era: Era?
    let founded: String
    let detailedDescription: String
    let address: String
    let gmapLocation: GMapLocation
    let openingHours: [String: [String]]?
    let translatedOpeningHours: [String: TranslatedOpeningHour]?
    let startingPrice: Int?
    let ticketPrices: [TicketPrice]
    let experienceTips: [String]
    let isLiked: Bool?
    let reviews: [Review]
    let rating: Int
    let reviewsNo: Int
    let audioURL: String?
    let hasAudio: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case coverPhoto = "cover_photo"
        case description
        case viewsNo = "views_no"
        case likesNo = "likes_no"
        case recommended
        case hasVideo = "has_video"
        case tags
        case city
        case tourHTML = "tour_html"
        case famousFigure = "famous_figure"
        case period
        case era
        case founded
        case detailedDescription = "detailed_description"
        case address
        case gmapLocation = "gmap_location"
        case openingHours = "opening_hours"
        case translatedOpeningHours = "translated_opening_hours"
        case startingPrice = "starting_price"
        case ticketPrices = "ticket_prices"
        case experienceTips = "experience_tips"
        case isLiked = "is_liked"
        case reviews
        case rating
        case reviewsNo = "reviews_no"
        case audioURL = "audio_url"
        case hasAudio = "has_audio"
    }
}

// MARK: - Tag
struct Tag: Codable, Identifiable {
    let id: Int
    let name: String
    let disable: String?
    let topPick: Int

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case disable
        case topPick = "top_pick"
    }
}

// MARK: - City
struct City: Codable, Identifiable {
    let id: Int
    let name: String
    let disable: String?
    let topPick: Int

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case disable
        case topPick = "top_pick"
    }
}

// MARK: - Period
struct Period: Codable, Identifiable {
    let id: String
    let value: String
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case value
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Era
struct Era: Codable, Identifiable {
    let id: String
    let value: String
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case value
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - GMapLocation
struct GMapLocation: Codable {
    let type: String
    let coordinates: [Double]
}

// MARK: - TranslatedOpeningHour
struct TranslatedOpeningHour: Codable {
    let day: String
    let time: String
}

// MARK: - TicketPrice
struct TicketPrice: Codable {
    let type: String
    let price: Int
}

// MARK: - Review
struct Review: Codable, Identifiable {
    let id: String
    let experience: String
    let name: String
    let rating: Int
    let comment: String
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case experience
        case name
        case rating
        case comment
        case createdAt = "created_at"
    }
}

// MARK: - Pagination
struct Pagination: Codable {
    // Add pagination properties if needed
    // Currently empty in the provided JSON
}
