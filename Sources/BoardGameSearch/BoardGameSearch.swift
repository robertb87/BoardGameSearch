import Foundation

public struct BoardGameSearch {
    public private(set) var text = "Hello, World!"

    public init() {
    }
}

public struct GameMechanics: Codable {
    let id: String
}

public struct SearchResults: Decodable {
    let games: [GameDetails]
    let count: Int
}

public struct GameDetails: Decodable {

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case names
        case yearPublished      = "year_published"
        case minPlayers         = "min_players"
        case maxPlayers         = "max_players"
        case minPlaytime        = "min_playtime"
        case maxPlaytime        = "max_playtime"
        case minAge             = "min_age"
        case description
        case descriptionPreview = "description_preview"
        case tumbleURL          = "thumb_url"
        case imageURL           = "image_url"
        case url
        case price
        case msrp
        case discount
        case primagePublisher   = "primary_publisher"
        case mechanics
        case categories
        case designers
        case developers
        case artists
    }

    let id: String
    let name: String
    let names: [String]
    let yearPublished: Int
    let minPlayers: Int
    let maxPlayers: Int
    let minPlaytime: Int
    let maxPlaytime: Int
    let minAge: Int
    let description: String
    let descriptionPreview: String
    let thumbUrl: String
    let imageUrl: String
//    let url: String?
//    let price: String
//    let msrp: Float
//    let discount: Float
//    let primaryPublisher: [String]
//    let mechanics: [GameMechanics]
//    let categories: [GameMechanics]
    let designers: [String]
    let developers: [String]
    let artists: [String]

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id                          = try container.decode(String.self, forKey: .id)
        name                        = try container.decode(String.self, forKey: .name)
        if let names                = try? container.decode([String].self, forKey: .names) {
            self.names = names
        } else {
            self.names = [String]()
        }
        if let yearPublished        = try? container.decode(Int.self, forKey: .yearPublished) {
            self.yearPublished = yearPublished
        } else  {
            self.yearPublished = -1
        }
        if let minPlayers           = try? container.decode(Int.self, forKey: .minPlayers) {
            self.minPlayers = minPlayers
        } else {
            self.minPlayers = -1
        }
        if let maxPlayers           = try? container.decode(Int.self, forKey:  .maxPlayers) {
            self.maxPlayers = maxPlayers
        } else {
            self.maxPlayers = -1
        }
        if let minPlaytime          = try? container.decode(Int.self, forKey: .minPlaytime) {
            self.minPlaytime = minPlaytime
        } else {
            self.minPlaytime = -1
        }
        if let maxPlaytime          = try? container.decode(Int.self, forKey: .maxPlaytime) {
            self.maxPlaytime = maxPlaytime
        } else {
            self.maxPlaytime = -1
        }
        if let minAge               = try? container.decode(Int.self, forKey: .minAge) {
            self.minAge = minAge
        } else {
            self.minAge = -1
        }
        if let description          = try? container.decode(String.self, forKey: .description) {
            self.description = description
        } else {
            self.description = "No description"
        }
        if let descriptionPreview   = try? container.decode(String.self, forKey: .descriptionPreview) {
            self.descriptionPreview = descriptionPreview
        } else {
            self.descriptionPreview = ""
        }
        if let thumbUrl             = try? container.decode(String.self, forKey: .tumbleURL) {
            self.thumbUrl = thumbUrl
        } else {
            self.thumbUrl = ""
        }
        if let imageUrl             = try? container.decode(String.self, forKey: .imageURL) {
            self.imageUrl = imageUrl
        } else  {
            self.imageUrl = ""
        }
//        price: String
//        msrp: Float
//        discount: Float
//        primaryPublisher: [String]
//        mechanics: [GameMechanics]
//        categories: [GameMechanics]
        if let designers            = try? container.decode([String].self, forKey: .designers) {
            self.designers = designers
        } else {
            self.designers = []
        }
        if let developers           = try? container.decode([String].self, forKey: .developers) {
            self.developers = developers
        } else {
            self.developers = []
        }
        if let artists              = try? container.decode([String].self, forKey: .artists) {
            self.artists = artists
        } else {
            self.artists = []
        }

    }



}

public class Search {
    var url: URL? //https://api.boardgameatlas.com/api/search?ids=TAAifFP590&client_id=JLBr5npPhV

    public init() {

    }

    public func search() {
        url = URL(string:"https://api.boardgameatlas.com/api/search?")
        let query = URLQueryItem(name: "name", value: "Monopoly")
        let clientID = URLQueryItem(name: "client_id", value: "GEFPATEZMn")
        if #available(iOS 16.0, *) {
            url?.append(queryItems: [query, clientID])
        } else {
            // Fallback on earlier versions
            fatalError()
        }
        if let url = url {
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    let gameDetails: SearchResults = try! JSONDecoder().decode(SearchResults.self, from: data)
                    print(gameDetails)
                }

                if let response = response {
                    print("RESPONSE \(response.description)")
                }

                if let error = error {
                    print("ERROR \(error.localizedDescription)")
                }
            }
            .resume()

        }



    }
}
