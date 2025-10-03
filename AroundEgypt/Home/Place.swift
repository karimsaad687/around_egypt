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
    var likesNo: Int
    let recommended: Int
    let city: City
    let detailedDescription: String
    let address: String
    let isLiked: Bool?
    

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case coverPhoto = "cover_photo"
        case description
        case viewsNo = "views_no"
        case likesNo = "likes_no"
        case recommended
        case city
        case detailedDescription = "detailed_description"
        case address
        case isLiked = "is_liked"
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

// MARK: - Pagination
struct Pagination: Codable {
    // Add pagination properties if needed
    // Currently empty in the provided JSON
}
