import SwiftUI
import FirebaseFirestore

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    var username: String
    var userBio: String
    var userBioLink: String
    var userUID: String
    var userEmail: String
    var userProfileURL: String  // Change to String, and you can later convert it to URLRequest if needed
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case userBio
        case userBioLink
        case userUID
        case userEmail
        case userProfileURL
    }
    
    // Optional: Custom decoding initializer if you need specific handling of properties.
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        id = try container.decodeIfPresent(String.self, forKey: .id)
//        username = try container.decode(String.self, forKey: .username)
//        userBio = try container.decode(String.self, forKey: .userBio)
//        userBioLink = try container.decode(String.self, forKey: .userBioLink)
//        userUID = try container.decode(String.self, forKey: .userUID)
//        userEmail = try container.decode(String.self, forKey: .userEmail)
//        
//        // Decode userProfileURL as a string, which you can convert to URLRequest later
//        let urlString = try container.decode(String.self, forKey: .userProfileURL)
//        userProfileURL = urlString  // Store as String initially
//    }
//    
//    // Optional: Encoding logic if you need to encode custom data
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encodeIfPresent(id, forKey: .id)
//        try container.encode(username, forKey: .username)
//        try container.encode(userBio, forKey: .userBio)
//        try container.encode(userBioLink, forKey: .userBioLink)
//        try container.encode(userUID, forKey: .userUID)
//        try container.encode(userEmail, forKey: .userEmail)
//        try container.encode(userProfileURL, forKey: .userProfileURL)
//    }
    
    
    
}
